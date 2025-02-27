`timescale 10ns/10ns
`include "top.sv"

module fade_tb;
    parameter PWM_INTERVAL = 1200;
    logic clk = 0;
    logic RGB_R, RGB_G, RGB_B;

    top #(
        .PWM_INTERVAL   (PWM_INTERVAL)
    ) u_top (
        .clk(clk),
        .RGB_R(RGB_R),
        .RGB_G(RGB_G),
        .RGB_B(RGB_B)
    );

    initial begin
        $dumpfile("fade.vcd");
        $dumpvars(0, fade_tb);
        #60000000;
        $finish;
    end

    always #4 clk = ~clk;

endmodule
