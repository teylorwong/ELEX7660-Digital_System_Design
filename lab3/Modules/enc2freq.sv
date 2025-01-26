// enc2freq.sv - module that maps encoder signals to a set of frequencies
// in order to play a scale (C major scale)
// Teylor Wong 01/25/25

module enc2freq (
    input logic cw, ccw,         // Rotary encoder signals
    output logic [31:0] freq,    // Output frequency
    input logic reset_n,         // Active-low reset
    input logic clk              // Clock
);

    // Define frequencies for the C Major scale (in Hz)
    localparam [31:0] FREQ_C     = 32'd262;
    localparam [31:0] FREQ_D     = 32'd294;
    localparam [31:0] FREQ_E     = 32'd330;
    localparam [31:0] FREQ_F     = 32'd349;
    localparam [31:0] FREQ_G     = 32'd392;
    localparam [31:0] FREQ_A     = 32'd440;
    localparam [31:0] FREQ_B     = 32'd494;
    localparam [31:0] FREQ_C_HIGH = 32'd523;

    // Current note index
    logic [2:0] note_index;

    // Sequential logic: Update note index based on encoder signals
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            note_index <= 3'd0;  // Reset to first note (C)
        end else begin
            if (cw && !ccw && note_index < 3'd7) begin
                note_index <= note_index + 1'b1;  // Increment note index
            end else if (!cw && ccw && note_index > 3'd0) begin
                note_index <= note_index - 1'b1;  // Decrement note index
            end
        end
    end

    // Combinational logic: Map note index to frequency
    always_comb begin
        case (note_index)
            3'd0: freq = FREQ_C;
            3'd1: freq = FREQ_D;
            3'd2: freq = FREQ_E;
            3'd3: freq = FREQ_F;
            3'd4: freq = FREQ_G;
            3'd5: freq = FREQ_A;
            3'd6: freq = FREQ_B;
            3'd7: freq = FREQ_C_HIGH;
            default: freq = FREQ_C;
        endcase
    end

endmodule
