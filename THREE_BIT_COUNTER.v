`timescale 1ns / 1ps

module THREE_BIT_COUNTER(
    input wire clk,
    input wire reset,
    output reg [2:0] count = 3'b001
    );

always @(posedge clk or posedge reset) begin
    if (reset)
        count <= 3'b001;
    else if(count == 3'b111)
        count <= 3'b001;
     else
        count <= count + 1;
end
endmodule