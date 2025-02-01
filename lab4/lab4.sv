// lab3.sv - ELEX 7660 lab4 top-level module
// Teylor Wong 01/31/25

module lab4 (
    input logic CLOCK_50,       // 50 MHz clock
    input logic s1, s2,          // Pushbuttons (active low)
    (* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *) 
    input logic enc1_a, enc1_b, //Encoder 1 pins
    output logic [7:0] leds,    // 7-seg LED enables
    output logic [3:0] ct ) ;   // Digit cathodes

    logic [2:0] chan;           // Channel from enc2chan
    logic reset_n;              // Reset
    logic enc1_cw, enc1_ccw;    // Encoder module outputs

    // Display lower 16 bits of freq on 7-segment display
    logic [1:0] digit;          // Select digit to display
    logic [3:0] disp_digit;     // Current digit of count to display
    logic [15:0] clk_div_count; // Count used to divide clock

    // Pushbuttons for control signals
    assign reset_n = s1;        // s1 is active low reset
    assign onOff = ~s2;         // s2 is active low mute

    // Instantiate modules to implement design
    decode2 decode2_0 (.digit(digit),.ct(ct));
    decode7 decode7_0 (.num(disp_digit),.leds(leds));
    encoder encoder_1 (.clk(CLOCK_50),.a(enc1_a),.b(enc1_b),.cw(enc1_cw),.ccw(enc1_ccw));
    enc2chan enc2chan_0 (.cw(enc1_cw),.ccw(enc1_ccw),.chan(chan),.reset_n(reset_n),.clk(CLOCK_50));
    adcinterface adcinterface_0 (.clk(CLOCK_50),.reset_n(reset_n),.chan(chan),.result(result),
    .ADC_SDO(ADC_SDO),.ADC_CONVST(ADC_CONVST),.ADC_SCK(ADC_SCK),.ADC_SDI(ADC_SDI));
    
    // Use count to divide clock and generate a 2-bit digit counter
    always_ff @(posedge CLOCK_50)
        clk_div_count <= clk_div_count + 1'b1;

    // Assign the top two bits of count to select digit to display
    assign digit = clk_div_count[15:14];

    // Select digit to display (disp_digit)
    always_comb begin
        case (digit)
            2'b00 : disp_digit = result[3:0];     // Least significant nibble
            2'b01 : disp_digit = result[7:4];
            2'b10 : disp_digit = result[11:8];   // Most significant nibble
            2'b11 : disp_digit = {1'b0, chan};
            default: disp_digit = 4'b0000;
        endcase
    end

endmodule