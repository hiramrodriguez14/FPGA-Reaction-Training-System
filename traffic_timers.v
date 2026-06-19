`timescale 1ns / 1ps

module traffic_timers (
    input  wire clk,
    input  wire reset,
    input  wire red_on,
    input  wire yellow_on,
    input  wire green_on,
    input  wire half_sec_enable,
    input  wire start,

    output reg [2:0]  red_data,
    output reg [2:0]  yellow_data,
    output reg [13:0] green_data,

    output reg half_sec_tick
);

    // 1 Hz tick 
    reg [26:0] clk_counter;
    reg one_hz_tick;

    always @(posedge clk or posedge reset) begin
        if (reset || start) begin
            clk_counter <= 0;
            one_hz_tick <= 0;
        end else begin
            one_hz_tick <= 0;

            if (clk_counter == 100_000_000 - 1) begin
                clk_counter <= 0;
                one_hz_tick <= 1;
            end else begin
                clk_counter <= clk_counter + 1;
            end
        end
    end

    // 1 ms tick
    reg [16:0] green_clk_counter;
    reg green_tick;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            green_clk_counter <= 0;
            green_tick <= 0;
        end else begin
            green_tick <= 0;

            if (green_clk_counter == 100_000 - 1) begin
                green_clk_counter <= 0;
                green_tick <= 1;
            end else begin
                green_clk_counter <= green_clk_counter + 1;
            end
        end
    end

    // 0.5 second timer (FIXED)
    reg [25:0] half_sec_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            half_sec_counter <= 0;
            half_sec_tick    <= 0;
        end else begin
            half_sec_tick <= 0;

            if (half_sec_enable) begin
                if (half_sec_counter == 50_000_000 - 1) begin
                    half_sec_counter <= 0;
                    half_sec_tick    <= 1;
                end else begin
                    half_sec_counter <= half_sec_counter + 1;
                end
            end else begin
                half_sec_counter <= 0;
            end
        end
    end

    // Red counter (1 Hz)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            red_data <= 0;
        end else if (!red_on) begin
            red_data <= 0;
        end else if (one_hz_tick) begin
            if (red_data < 3'd4)
                red_data <= red_data + 1;
        end
    end

    // Yellow counter (1 Hz)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            yellow_data <= 0;
        end else if (!yellow_on) begin
            yellow_data <= 0;
        end else if (one_hz_tick) begin
            if (yellow_data < 3'd2)
                yellow_data <= yellow_data + 1;
        end
    end

    // Green counter (1 ms tick)
    always @(posedge clk or posedge reset) begin
        if (reset || start) begin
            green_data <= 0;
        end else if (!green_on) begin
//            green_data <= 0;
        end else if (green_tick) begin
            if (green_data < 14'd9999)
                green_data <= green_data + 1;
        end
    end

endmodule