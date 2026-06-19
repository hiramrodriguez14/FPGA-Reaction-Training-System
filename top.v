`timescale 1ns / 1ps

module top (

    input wire clk,
    input wire reset,

    input wire button_start,
    input wire stop_button,

    output wire red_on,
    output wire yellow_on,
    output wire green_on2,
    output wire start,
    output wire stopped,
    output wire toBuzzer,
    output wire [6:0] seg,
    output wire [3:0] an ,
    output wire point
);

    wire green_on;
    assign green_on2= green_on && !stopped;
    wire start_clean;
    wire stop_clean;
    wire half_sec_enable;
    wire which_counter;
    wire [2:0]red_data;
    wire [2:0]  yellow_data;
    wire [13:0] green_data;
    wire half_sec_tick;
    wire red_finished;
    wire yellow_finished;
    
    
    debounce db_start (
        .clk(clk),
        .n_reset(!reset),
        .button_in(button_start),
        .DB_out(start_clean)
    );

    debounce db_stop (
        .clk(clk),
        .n_reset(!reset),
        .button_in(stop_button),
        .DB_out(stop_clean)
    );

    reg start_clean_d;
    reg stop_clean_d;
    wire stop_pulse;
    wire start_pulse;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            start_clean_d <= 0;
            stop_clean_d <= 0;
        end
        else begin
            start_clean_d <= start_clean;
            stop_clean_d <= stop_clean;
        end
    end
    
    assign start_pulse = start_clean & ~start_clean_d;
    assign stop_pulse = stop_clean & ~stop_clean_d;
    
    reaction_fsm fsm (
        .clk(clk),
        .reset(reset),

        .button_start(start_pulse),
        .stop_button(stop_pulse),

        .red_finished(red_finished),
        .yellow_finished(yellow_finished),
        .half_sec_tick(half_sec_tick),

        .red_on(red_on),
        .yellow_on(yellow_on),
        .green_on(green_on),
        .start(start),
        .stopped(stopped),
        .half_sec_enable(half_sec_enable),
        .which_counter(which_counter)
    );
    
    buzzer buzzer(
    .red_en(red_on),
    .reset(reset),
    .yellow_en(yellow_on),
    .green_en(green_on),
    .clk100MHz(clk),
    .pwm(toBuzzer)
    );
    
    randomGenerator randomGenerator(
    .clk(clk),
    .reset(reset),
    .red_data(red_data),
    .yellow_data(yellow_data),
    .button_start(start_pulse),
    .which_counter(which_counter),
    .red_finished(red_finished),
    .yellow_finished(yellow_finished)
    );
    
    traffic_timers traffic_timers(
    .clk(clk),
    .reset(reset),
    .red_on(red_on),
    .yellow_on(yellow_on),
    .green_on(green_on),
    .half_sec_enable(half_sec_enable),
    .start(start),
    .red_data(red_data),
    .yellow_data(yellow_data),
    .green_data(green_data),
    .half_sec_tick(half_sec_tick)
    );
    
    display_system display_system(
    .clk(clk),
    .rst(reset),
    .green_data(green_data),
    .seg(seg),
    .an(an),
    .stopped(stopped),
    .point(point)
    );

endmodule