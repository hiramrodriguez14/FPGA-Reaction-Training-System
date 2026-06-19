`timescale 1ns / 1ps

module display_system (
    input wire clk,                 
    input wire rst,                  
    input wire [13:0] green_data,    
    output wire [6:0] seg,           
    output wire [3:0] an,
    output wire point,
    input wire stopped          
);
    reg [13:0] display_data;
    
    always @(posedge clk or posedge rst) begin
    if (rst) begin
        display_data <= 14'd0;
    end else if (!stopped) begin
        display_data <= (green_data > 14'd9999) ? 14'd9999 : green_data;
    end
    end

    wire [3:0] bcd_thousands;
    wire [3:0] bcd_hundreds;
    wire [3:0] bcd_tens;
    wire [3:0] bcd_ones;
    wire [6:0] seg_thousands;
    wire [6:0] seg_hundreds;
    wire [6:0] seg_tens;
    wire [6:0] seg_ones;
    wire [6:0] seg_high;
    wire point_internal;
    
    bcd_converter u_bcd_converter (
        .binary(display_data),
        .thousands(bcd_thousands),
        .hundreds(bcd_hundreds),
        .tens(bcd_tens),
        .ones(bcd_ones)
    );
    decoder u_decoder (
        .thousands(bcd_thousands),
        .hundreds(bcd_hundreds),
        .tens(bcd_tens),
        .ones(bcd_ones),
        .seg_th(seg_thousands),
        .seg_h(seg_hundreds),
        .seg_t(seg_tens),
        .seg_o(seg_ones)
    );

    seven_segment_multiplexer u_mux (
        .clk(clk),
        .rst(rst),
        .seg_th(seg_thousands),
        .seg_h(seg_hundreds),
        .seg_t(seg_tens),
        .seg_o(seg_ones),
        .seg(seg_high),
        .an(an),
        .point(point_internal)
    );
    
    assign seg = ~seg_high;
    assign point = point_internal;

endmodule

module bcd_converter (
    input wire [13:0] binary,
    output reg [3:0] thousands,
    output reg [3:0] hundreds,
    output reg [3:0] tens,
    output reg [3:0] ones
);
    integer i;
    
    always @(*) begin
        thousands     = 4'd0;
        hundreds      = 4'd0;
        tens          = 4'd0;
        ones          = 4'd0;
        
        for (i = 13; i >= 0; i = i - 1) begin
            if (thousands >= 5)     thousands = thousands + 3;
            if (hundreds >= 5)      hundreds = hundreds + 3;
            if (tens >= 5)          tens = tens + 3;
            if (ones >= 5)          ones = ones + 3;
            
            thousands     = {thousands[2:0], hundreds[3]};
            hundreds      = {hundreds[2:0], tens[3]};
            tens          = {tens[2:0], ones[3]};
            ones          = {ones[2:0], binary[i]};
        end
    end
endmodule

module decoder (
    input wire [3:0] thousands,
    input wire [3:0] hundreds,
    input wire [3:0] tens,
    input wire [3:0] ones,
    output wire [6:0] seg_th,
    output wire [6:0] seg_h,
    output wire [6:0] seg_t,
    output wire [6:0] seg_o
);
    bcd_to_7seg dec_thousands     (.bcd(thousands),     .seg(seg_th));
    bcd_to_7seg dec_hundreds      (.bcd(hundreds),      .seg(seg_h));
    bcd_to_7seg dec_tens          (.bcd(tens),          .seg(seg_t));
    bcd_to_7seg dec_ones          (.bcd(ones),          .seg(seg_o));
endmodule

module bcd_to_7seg (
    input wire [3:0] bcd,
    output reg [6:0] seg
);
    always @(*) begin
        case (bcd)
            4'd0: seg = 7'b1111110;
            4'd1: seg = 7'b0110000;
            4'd2: seg = 7'b1101101;
            4'd3: seg = 7'b1111001;
            4'd4: seg = 7'b0110011;
            4'd5: seg = 7'b1011011;
            4'd6: seg = 7'b1011111;
            4'd7: seg = 7'b1110000;
            4'd8: seg = 7'b1111111;
            4'd9: seg = 7'b1111011;
            default: seg = 7'b0000000;
        endcase
    end
endmodule

module seven_segment_multiplexer (
    input wire clk,
    input wire rst,
    input wire [6:0] seg_th,
    input wire [6:0] seg_h,
    input wire [6:0] seg_t,
    input wire [6:0] seg_o,
    output reg [6:0] seg,
    output reg [3:0] an,
    output reg point     
);

    reg [15:0] refresh_counter;
    wire [1:0] active_digit = refresh_counter[15:14]; 

    always @(posedge clk or posedge rst) begin
        if (rst)
            refresh_counter <= 16'd0;
        else
            refresh_counter <= refresh_counter + 1'b1;
    end

    always @(*) begin
        case (active_digit)
            2'b00: begin
                an  = 4'b1110; 
                seg = seg_o;
                point = 1'b1; 
            end
            2'b01: begin
                an  = 4'b1101;
                seg = seg_t;
                point = 1'b1; 
            end
            2'b10: begin
                an  = 4'b1011;
                seg = seg_h;
                point = 1'b1; 
            end
            2'b11: begin
                an  = 4'b0111;
                seg = seg_th;
                point = 1'b0;
            end
        endcase
    end
endmodule