// File: lab2.sv
// Description: ELEX 7660 lab2 top-level module. Converts binary to BCD.
// Author: Teylor Wong
// Date: 2024-01-20

module lab2 ( input logic CLOCK_50,       // 50 MHz clock
              (* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *) 
              input logic enc1_a, enc1_b, //Encoder 1 pins
              (* altera_attribute = "-name WEAK_PULL_UP_RESISTOR ON" *) 
              input logic enc2_a, enc2_b, //Encoder 2 pins
              output logic [7:0] leds,    // 7-seg LED enables
              output logic [3:0] ct ) ;   // digit cathodes

   logic [1:0] digit;               // Select digit to display
   logic [3:0] disp_digit;          // Current digit of count to display
   logic [15:0] clk_div_count;      // Count used to divide clock

   logic [7:0] enc1_count_bin, enc2_count_bin; // Binary counts for encoders
   logic [7:0] enc1_count_bcd, enc2_count_bcd; // BCD counts for encoders
   logic enc1_cw, enc1_ccw, enc2_cw, enc2_ccw; // Encoder module outputs

   // Instantiate modules to implement design
   decode2 decode2_0 (.digit,.ct);
   decode7 decode7_0 (.num(disp_digit),.leds);

   encoder encoder_1 (.clk(CLOCK_50), .a(enc1_a), .b(enc1_b), .cw(enc1_cw), .ccw(enc1_ccw));
   encoder encoder_2 (.clk(CLOCK_50), .a(enc2_a), .b(enc2_b), .cw(enc2_cw), .ccw(enc2_ccw));

   // Encoder counts: Increment or decrement binary count
   always_ff @(posedge CLOCK_50) begin
      if (enc1_cw) enc1_count_bin <= enc1_count_bin + 1'b1;
      else if (enc1_ccw) enc1_count_bin <= enc1_count_bin - 1'b1;

      if (enc2_cw) enc2_count_bin <= enc2_count_bin + 1'b1;
      else if (enc2_ccw) enc2_count_bin <= enc2_count_bin - 1'b1;
   end

   // Instantiate enc2bcd modules for binary-to-BCD conversion
   enc2bcd enc2bcd_1 (.clk(CLOCK_50), .binary(enc1_count_bin), .bcd_count(enc1_count_bcd));
   enc2bcd enc2bcd_2 (.clk(CLOCK_50), .binary(enc2_count_bin), .bcd_count(enc2_count_bcd));

   // Use count to divide clock and generate a 2-bit digit counter
   always_ff @(posedge CLOCK_50)
      clk_div_count <= clk_div_count + 1'b1;

   // Assign the top two bits of count to select digit to display
   assign digit = clk_div_count[15:14];

   // Select digit to display (disp_digit)
   // Left two digits (3,2) display encoder 1 BCD count and right two digits (1,0) display encoder 2 BCD count
   always_comb begin
      case (digit)
         2'b00 : disp_digit = enc2_count_bcd[3:0];
         2'b01 : disp_digit = enc2_count_bcd[7:4];
         2'b10 : disp_digit = enc1_count_bcd[3:0];
         2'b11 : disp_digit = enc1_count_bcd[7:4];
         default: disp_digit = 4'b0000;
      endcase
   end

endmodule
