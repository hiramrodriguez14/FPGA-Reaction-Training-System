`timescale 1ns / 100ps

module debounce(
    input clk,
    input n_reset,
    input button_in,
    output reg DB_out
);

parameter N = 22;

reg [N-1:0] q_reg;
reg [N-1:0] q_next;

reg DFF1, DFF2;

wire q_reset;
wire q_add;

assign q_reset = DFF1 ^ DFF2;
assign q_add   = ~q_reg[N-1];

always @(*) begin
    case ({q_reset, q_add})

        2'b00:
            q_next = q_reg;

        2'b01:
            q_next = q_reg + 1'b1;

        default:
            q_next = {N{1'b0}};

    endcase
end

always @(posedge clk) begin
    if(!n_reset) begin
        DFF1  <= 1'b0;
        DFF2  <= 1'b0;
        q_reg <= {N{1'b0}};
    end else begin
        DFF1  <= button_in;
        DFF2  <= DFF1;
        q_reg <= q_next;
    end
end

always @(posedge clk) begin
    if(!n_reset)
        DB_out <= 1'b0;
    else if(q_reg[N-1])
        DB_out <= DFF2;
end

endmodule