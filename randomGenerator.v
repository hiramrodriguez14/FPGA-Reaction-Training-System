`timescale 1ns / 1ps

module randomGenerator(
    input  wire clk,
    input  wire reset,
    input  wire [2:0] red_data,
    input  wire [2:0] yellow_data,
    input  wire button_start,
    input  wire which_counter,
    output reg red_finished,
    output reg yellow_finished
);

    wire [2:0] lfsr_out;
    reg  [2:0] muxData;
    reg load;

    TOP_LFSR_COUNTER u_lfsr (
        .clk(clk),
        .reset(reset),
        .load(load),
        .lfsr_out(lfsr_out)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            muxData         <= 0;
            red_finished    <= 0;
            yellow_finished <= 0;
            load            <= 0;

        end else begin
            // default outputs
            red_finished    <= 0;
            yellow_finished <= 0;

            if (which_counter)
                muxData <= yellow_data;
            else
                muxData <= red_data;

            if (muxData == lfsr_out) begin
                if (which_counter)
                    yellow_finished <= 1;
                else
                    red_finished <= 1;
            end
            
            load <= button_start;
        end
    end

endmodule