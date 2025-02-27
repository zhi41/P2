`include "fade.sv"
`include "pwm.sv"

module top #(   
    parameter PWM_INTERVAL = 600  
)(
    input  logic clk, 
    output logic RGB_R,
    output logic RGB_G,
    output logic RGB_B
);


    logic [$clog2(PWM_INTERVAL) - 1:0] red_value;
    logic [$clog2(PWM_INTERVAL) - 1:0] green_value;
    logic [$clog2(PWM_INTERVAL) - 1:0] blue_value;

    logic red_pwm;
    logic green_pwm;
    logic blue_pwm;

    // Red Fade
    fade #(
        .PWM_INTERVAL   (PWM_INTERVAL),
        .INITIAL_PWM    (600)
    ) fade_red (
        .clk            (clk), 
        .pwm_value      (red_value)
    );

    // Green Fade
    fade #(
        .PWM_INTERVAL   (PWM_INTERVAL),
        .INITIAL_PWM    (600 / 3)
    ) fade_green (
        .clk            (clk), 
        .pwm_value      (green_value)
    );

    // Blue Fade
    fade #(
        .PWM_INTERVAL   (PWM_INTERVAL),
        .INITIAL_PWM    (600  / 6)
    ) fade_blue (
        .clk            (clk), 
        .pwm_value      (blue_value)
    );

    // Red PWM
    pwm #(
        .PWM_INTERVAL (PWM_INTERVAL)
    ) pwm_red (
        .clk        (clk), 
        .pwm_value  (red_value), 
        .pwm_out    (red_pwm)
    );

    // Green PWM
    pwm #(
        .PWM_INTERVAL (PWM_INTERVAL)
    ) pwm_green (
        .clk        (clk), 
        .pwm_value  (green_value), 
        .pwm_out    (green_pwm)
    );

    // Blue PWM
    pwm #(
        .PWM_INTERVAL (PWM_INTERVAL)
    ) pwm_blue (
        .clk        (clk), 
        .pwm_value  (blue_value), 
        .pwm_out    (blue_pwm)
    );

    assign RGB_R = ~red_pwm;
    assign RGB_G = ~green_pwm;
    assign RGB_B = ~blue_pwm;

endmodule

