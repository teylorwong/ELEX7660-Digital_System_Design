// enc2bcd.sv - ELEX7660 module for Lab2
// Double-Dabble algorithm to convert binary to BCD
// Teylor Wong 2025-01-20

module enc2bcd (
    input logic clk,                 // Clock input
    input logic [7:0] binary,        // 8-bit binary input
    output logic [7:0] bcd_count     // 8-bit BCD output (2-digit BCD)
);

    logic [15:0] shift_register;     // Shift register for double-dabble
    logic [3:0] i;                   // Loop counter for 8 iterations

    always_ff @(posedge clk) begin
        // Initialize shift register with the binary value
        shift_register = {8'b0, binary};  // Append 8 zeros to the binary input

        // Perform the double-dabble algorithm
        for (i = 0; i < 8; i = i + 1) begin
            // Check and adjust lower nibble (BCD digit 0)
            if (shift_register[11:8] > 4)
                shift_register[11:8] = shift_register[11:8] + 3;
            // Check and adjust upper nibble (BCD digit 1)
            if (shift_register[15:12] > 4)
                shift_register[15:12] = shift_register[15:12] + 3;

            // Shift left by 1 bit
            shift_register = shift_register << 1;
        end

        // Extract the final BCD value from the shift register
        bcd_count = shift_register[15:8];
    end

endmodule
