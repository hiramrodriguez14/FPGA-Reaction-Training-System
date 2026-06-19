`timescale 1ns / 1ps

module THREE_BIT_LFSR(
    input wire clk,
    input wire reset,
    input wire load,
    input wire [2:0] seed,
    output reg [2:0] out
    );

wire feedback;

assign feedback = out[2] ^ out[0];

always @(posedge clk or posedge reset) begin
    if(reset)
        out <= 3'b001;
    else if(load)
        out <= seed;
    else 
        out <= {out[1], out[0], feedback};
end
endmodule