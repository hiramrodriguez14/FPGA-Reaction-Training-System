`timescale 1ns / 1ps

module buzzer(
    input  wire red_en,
    input  wire reset,
    input  wire yellow_en,
    input  wire green_en,
    input  wire clk100MHz,
    input  wire stopped,
    output reg  pwm
);

    localparam RED_YELLOW_LOAD    = 17'd113635; // 880 Hz
    localparam RED_YELLOW_COMPARE = 17'd56817; //50% duty

    localparam GREEN_LOAD         = 17'd75756;  // 1320 Hz
    localparam GREEN_COMPARE      = 17'd37878; //50% duty

    reg [16:0] counter;
    reg [16:0] load;
    reg [16:0] compare;
    reg active;

always @(*) begin

    // default
    load    = 17'd0;
    compare = 17'd0;
    active  = 1'b0;

    if (!stopped) begin

        if (red_en || yellow_en) begin
            load    = RED_YELLOW_LOAD;
            compare = RED_YELLOW_COMPARE;
            active  = 1'b1;

        end 
       
        else if (green_en) begin
            load    = GREEN_LOAD;
            compare = GREEN_COMPARE;
            active  = 1'b1;
        end
    end
end

    always @(posedge clk100MHz or posedge reset) begin
        if (reset) begin
            counter <= 17'd0;
            pwm <= 1'b0;
       end else if (active) begin

            if (counter >= load)
                counter <= 17'd0;
            else
                counter <= counter + 17'd1;

            if (counter < compare)
                pwm <= 1'b1;
            else
                pwm <= 1'b0;

        end else begin
            counter <= 17'd0;
            pwm <= 1'b0;
        end
    end

endmodule
