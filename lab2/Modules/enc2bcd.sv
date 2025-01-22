// File: enc2bcd.sv
// Description: ELEX 7660 lab2 encoder to BCD conversion module.
// Author: Teylor Wong
// Date: 2024-01-21

module enc2bcd (
    input logic clk,               // Clock input
    input logic cw,                // CW pulse input
    input logic ccw,               // CCW pulse input
    output logic [7:0] bcd_count   // 8-bit BCD output
);

    logic [1:0] cw_count;          // 2-bit counter for CW pulses (0–3)
    logic [1:0] ccw_count;         // 2-bit counter for CCW pulses (0–3)
    logic [7:0] binary_count;      // Binary count to be converted to BCD
    logic [15:0] shift_register;   // Shift register for Double-Dabble
    logic [3:0] i;                 // Loop counter

    always_ff @(posedge clk) begin
        // Increment CW pulse counter
        if (cw) begin
            cw_count <= cw_count + 1;
            if (cw_count == 2'b11) begin
                cw_count <= 0; // Reset CW pulse counter
                if (binary_count < 8'd99) // Increment binary count
                    binary_count <= binary_count + 1;
            end
        end

        // Increment CCW pulse counter
        if (ccw) begin
            ccw_count <= ccw_count + 1;
            if (ccw_count == 2'b11) begin
                ccw_count <= 0; // Reset CCW pulse counter
                if (binary_count > 8'd0) // Decrement binary count
                    binary_count <= binary_count - 1;
            end
        end

        // Initialize the shift register with the binary count
        shift_register = {8'b0, binary_count}; // Append 8 zeros to binary input

        // Perform the Double-Dabble algorithm
        for (i = 0; i < 8; i = i + 1) begin
            // Adjust lower BCD digit
            if (shift_register[11:8] > 4)
                shift_register[11:8] = shift_register[11:8] + 3;

            // Adjust upper BCD digit
            if (shift_register[15:12] > 4)
                shift_register[15:12] = shift_register[15:12] + 3;

            // Shift left by 1 bit
            shift_register = shift_register << 1;
        end

        // Assign the final BCD value
        bcd_count = shift_register[15:8];
    end

endmodule
