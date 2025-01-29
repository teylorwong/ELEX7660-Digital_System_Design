// tonegen.sv - Module for lab3 that generates a square wave at teh desired frequency
// Teylor Wong 01/25/25

module tonegen
    #(parameter FCLK = 50_000_000)  // Default clock frequency: 50 MHz
    (input logic [31:0] freq,       // Desired frequency
        input logic onOff,          // Enable/disable tone generation
        output logic spkr,          // Speaker output
        input logic reset_n, clk);  // Reset and clock

    logic [31:0] count = 0;         // Counter for frequency generation
    logic toggle = 0;               // Toggle signal for square wave

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
        count <= 0;
        toggle <= 0;
        spkr <= 0;
        end else if (onOff) begin
        if (count >= FCLK) begin
            count <= 0;
            toggle <= ~toggle;              // Toggle the speaker output
            spkr <= toggle;
        end else begin
            count <= count + (freq << 1);   // Increment by 2 * freq
        end
        end else begin
        spkr <= 0;                          // Mute the speaker
        end
    end
endmodule
