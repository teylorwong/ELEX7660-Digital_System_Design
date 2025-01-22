// enc2bcd.sv - ELEX7660 module for Lab2
// Updated to count every 4 pulses with simple debounce logic
// Teylor Wong 2025-01-20

// enc2bcd.sv - Converts encoder CW/CCW pulses into a BCD count
// Uses Double-Dabble algorithm to convert binary to BCD

module enc2bcd (
    input logic clk,               // Clock input
    input logic cw,                // CW pulse input
    input logic ccw,               // CCW pulse input
    output logic [7:0] bcd_count   // 8-bit BCD output
);

    logic [7:0] binary_count;      // Binary count to be converted to BCD
    logic [15:0] shift_register;   // Shift register for Double-Dabble
    logic [3:0] i;                 // Loop counter

    always_ff @(posedge clk) begin
        // Update binary_count based on CW and CCW pulses
        if (cw && binary_count < 8'd99) begin
            binary_count <= binary_count + 1;
        end else if (ccw && binary_count > 8'd0) begin
            binary_count <= binary_count - 1;
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
