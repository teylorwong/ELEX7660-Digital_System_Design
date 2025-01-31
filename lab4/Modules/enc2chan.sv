// enc2chan.sv - module that maps encoder signals to output channels
// (0-7) for an ADC interface
// Teylor Wong 01/25/25

module enc2chan (
    input logic cw, ccw,         // Rotary encoder signals
    output logic [2:0] chan,    // OutADCput channel
    input logic reset_n,         // Active-low reset
    input logic clk              // Clock
);

    // 3 bits for 8 channels (0-7)
    logic [2:0] chan_index;

    // Had some help form ChatGPT on this block of code
    always_ff @(posedge clk or negedge reset_n) begin   // negedge because reset_n is active low
        if (!reset_n) begin
            chan_index <= 3'd0;  // Reset to first channel 0
        end else begin
            if (cw && !ccw) begin
                note_index <= (chan_index == 3'd7) ? 3'd0 : chan_index + 1'b1;
            end else if (!cw && ccw) begin
                note_index <= (chan_index == 3'd0) ? 3'd7 : chan_index - 1'b1;
            end
        end
    end

    assign chan = chan_index;

endmodule
