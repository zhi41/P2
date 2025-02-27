

module fade #(
    parameter INC_DEC_INTERVAL = 10000,   // 1/6 X 200 = 12000000 
    parameter INC_DEC_MAX = 200,         // gradient increment/decrement
    parameter PWM_INTERVAL = 600,     
    parameter INC_DEC_VAL = PWM_INTERVAL / INC_DEC_MAX,
    parameter INITIAL_PWM = 1200
)(
    input  logic clk, 
    output logic [$clog2(PWM_INTERVAL) - 1:0] pwm_value
);

    localparam PWM_INC = 1'b0;
    localparam PWM_DEC = 1'b1;

    logic current_state = PWM_INC;
    logic next_state;

    logic [$clog2(INC_DEC_INTERVAL) - 1:0] count = 0;
    logic [$clog2(INC_DEC_MAX) - 1:0] inc_dec_count = 0;
    logic time_to_inc_dec = 1'b0;
    logic time_to_transition = 1'b0;

    initial begin
        pwm_value = INITIAL_PWM;
    end

    always_ff @(posedge clk) begin
        current_state <= next_state;
    end

    always_comb begin
        case (current_state)
            PWM_INC: next_state = (pwm_value >= PWM_INTERVAL - INC_DEC_VAL) ? PWM_DEC : PWM_INC;
            PWM_DEC: next_state = (pwm_value <= 0) ? PWM_INC : PWM_DEC;
            default: next_state = PWM_INC;
        endcase
    end

    always_ff @(posedge clk) begin
        if (count == INC_DEC_INTERVAL - 1) begin
            count <= 0;
            time_to_inc_dec <= 1'b1;
        end else begin
            count <= count + 1;
            time_to_inc_dec <= 1'b0;
        end
    end

    always_ff @(posedge clk) begin
        if (time_to_inc_dec) begin
            case (current_state)
                PWM_INC: pwm_value <= (pwm_value + INC_DEC_VAL >= PWM_INTERVAL) ? PWM_INTERVAL : pwm_value + INC_DEC_VAL;
                PWM_DEC: pwm_value <= (pwm_value <= INC_DEC_VAL) ? 0 : pwm_value - INC_DEC_VAL;
            endcase
        end
    end

    always_ff @(posedge clk) begin
        if (time_to_inc_dec) begin
            if (inc_dec_count == INC_DEC_MAX - 1) begin
                inc_dec_count <= 0;
                time_to_transition <= 1'b1;
            end else begin
                inc_dec_count <= inc_dec_count + 1;
                time_to_transition <= 1'b0;
            end
        end
    end

endmodule

