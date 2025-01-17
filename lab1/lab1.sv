// File: lab1.sv
// Description: ELEX 7660 lab1 top-level module.  Displays last
//              four digits of student number of 4 digit 7-segment
//              display module.
// Author: Robert Trost 
// Date: 2024-01-11

module lab1 ( input logic CLOCK_50,     // 50 MHz clock
              output logic [7:0] leds,  // 7-seg LED cathodes
              output logic [3:0] ct ) ; // digit enable

   logic [1:0] digit;  // select digit of student number to display
   logic [3:0] idnum;  // current digit of student nummber to display
   logic [15:0] count; // count used to divide clock

   // instantiate modules to implement design
   decode2 decode2_0 (.digit,.ct) ;
   bcitid  bcitid_0  (.digit,.idnum) ;
   decode7 decode7_0 (.num(idnum),.leds) ;


   // use count to divide clock and generate a 2 bit counter 
   always_ff @(posedge CLOCK_50) 
     count <= count + 1'b1 ;

  // assign the top two bits of count to select student number digit to display
  assign digit = count[15:14]; 

endmodule


