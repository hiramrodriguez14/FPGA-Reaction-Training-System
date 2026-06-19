`timescale 1ns / 1ps
module reaction_fsm (
    input  wire clk,
    input  wire reset,
    input  wire button_start,
    input  wire stop_button,
    input  wire red_finished,
    input  wire yellow_finished,
    input  wire half_sec_tick,

    output reg  red_on,
    output reg  yellow_on,
    output reg  green_on,
    output reg  start,
    output reg  stopped,
    output reg half_sec_enable,
    output reg which_counter
);
    // State encoding
    localparam INIT        = 3'd0;
    localparam RED         = 3'd1;
    localparam WAIT_RED    = 3'd2;
    localparam YELLOW      = 3'd3;
    localparam WAIT_YELLOW = 3'd4;
    localparam GREEN       = 3'd5;
    localparam STOP        = 3'd6;

    reg [2:0] current_state, next_state;

    always @(posedge clk) begin
        if (reset)
            current_state <= INIT;
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)

            INIT: begin
                if (button_start)
                    next_state = RED;
                else
                    next_state = INIT;
            end

            RED: begin
                if (red_finished)
                    next_state = WAIT_RED;
                else
                    next_state = RED;
            end

            WAIT_RED: begin
                if (half_sec_tick)
                    next_state = YELLOW;
                else
                    next_state = WAIT_RED;
            end

            YELLOW: begin
                if (yellow_finished)
                    next_state = WAIT_YELLOW;
                else
                    next_state = YELLOW;
            end

            WAIT_YELLOW: begin
                if (half_sec_tick)
                    next_state = GREEN;
                else
                    next_state = WAIT_YELLOW;
            end

            GREEN: begin
                if (stop_button)
                    next_state = STOP;
                else
                    next_state = GREEN;
            end

            STOP: begin
                if (button_start)
                    next_state = INIT;
                else
                    next_state = STOP;
            end

            default: begin
                next_state = INIT;
            end

        endcase
    end

    // Output logic
    always @(*) begin
        red_on          = 1'b0;
        yellow_on       = 1'b0;
        green_on        = 1'b0;
        which_counter   = 1'b0;
        start           = 1'b0;
        stopped         = 1'b0;
        half_sec_enable = 1'b0;

        case (current_state)

            INIT: begin
                start = 1'b1;
            end

            RED: begin
                red_on        = 1'b1;
                which_counter = 1'b0;
            end

            WAIT_RED: begin
                half_sec_enable = 1'b1;
            end

            YELLOW: begin
                yellow_on     = 1'b1;
                which_counter = 1'b1;
            end

            WAIT_YELLOW: begin
                half_sec_enable = 1'b1;
            end

            GREEN: begin
                green_on = 1'b1;
            end

            STOP: begin
                stopped = 1'b1;
                //green_on = 1'b1;
            end

            default: begin
                red_on          = 1'b0;
                yellow_on       = 1'b0;
                green_on        = 1'b0;
                which_counter   = 1'b0;
                start           = 1'b0;
                stopped         = 1'b0;
                half_sec_enable = 1'b0;
            end

        endcase
    end

endmodule