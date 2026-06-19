`timescale 1ns / 1ps

module TOP_LFSR_COUNTER(
    input wire clk,
    input wire reset,
    input wire load,
    output wire [2:0] lfsr_out
    );
    
wire [2:0] counter_out;

THREE_BIT_COUNTER counter (
    .clk(clk),
    .reset(reset),
    .count(counter_out)
);

THREE_BIT_LFSR lfsr(
    .clk(clk),
    .reset(reset),
    .load(load),
    .seed(counter_out),
    .out(lfsr_out)
);

endmodule