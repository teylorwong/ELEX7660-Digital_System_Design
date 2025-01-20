module encoder (
    input logic a, b, clk,  // a corresponds to cw movement, b to ccw movement
    output logic cw, ccw
);

    // Define states for the finite state machine
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        CW_DETECT = 2'b01,
        CCW_DETECT = 2'b10
    } state_t;

    // Declare state variables
    state_t current_state;

    logic prev_a, prev_b;  // Previous states of signals `a` and `b`

    // Sequential logic: Detect transitions and generate pulses
    always_ff @(posedge clk) begin
        // Default outputs
        cw <= 1'b0;
        ccw <= 1'b0;

        // Transition detection
        if ((prev_a != a) || (prev_b != b)) begin
            if ((prev_a == 0 && prev_b == 0 && a == 1 && b == 0) || // 00 -> 10
                (prev_a == 1 && prev_b == 0 && a == 1 && b == 1) || // 10 -> 11
                (prev_a == 1 && prev_b == 1 && a == 0 && b == 1) || // 11 -> 01
                (prev_a == 0 && prev_b == 1 && a == 0 && b == 0))   // 01 -> 00
            begin
                cw <= 1'b1;  // Generate CW pulse
                current_state <= CW_DETECT;  // Update to CW_DETECT state
            end
            else if ((prev_a == 0 && prev_b == 0 && a == 0 && b == 1) || // 00 -> 01
                     (prev_a == 0 && prev_b == 1 && a == 1 && b == 1) || // 01 -> 11
                     (prev_a == 1 && prev_b == 1 && a == 1 && b == 0) || // 11 -> 10
                     (prev_a == 1 && prev_b == 0 && a == 0 && b == 0))   // 10 -> 00
            begin
                ccw <= 1'b1;  // Generate CCW pulse
                current_state <= CCW_DETECT;  // Update to CCW_DETECT state
            end
        end
        else begin
            current_state <= IDLE;  // No valid transition, return to IDLE
        end

        // Update previous values
        prev_a <= a;
        prev_b <= b;
    end

endmodule