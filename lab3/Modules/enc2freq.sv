// enc2freq.sv - module that maps encoder signals to a set of frequencies
// in order to play a scle (C major scale)
// Teylor Wong 01/25/25

module enc2freq (
    input logic cw, ccw,         // Rotary encoder signals
    output logic [31:0] freq,    // Output frequency
    input logic reset_n, clk);   // Reset and clock

    // Frequencies for C Major scale
    localparam [31:0] FREQ_TABLE [8] = '{262, 295, 328, 349, 393, 437, 491, 524};

    logic [2:0] index = 0;        // Index for frequency table
    logic [1:0] pulse_count = 0;  // Count pulses for cw/ccw

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
        index <= 0;
        pulse_count <= 0;
        freq <= FREQ_TABLE[0];
        end else begin
        if (cw && pulse_count == 3) begin
            index <= (index == 7) ? 0 : index + 1; // Wrap around at max index
            pulse_count <= 0;
        end else if (ccw && pulse_count == 3) begin
            index <= (index == 0) ? 7 : index - 1; // Wrap around at min index
            pulse_count <= 0;
        end else if (cw || ccw) begin
            pulse_count <= pulse_count + 1;
        end
        freq <= FREQ_TABLE[index]; // Update frequency output
        end
    end
endmodule
