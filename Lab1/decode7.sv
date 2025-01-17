// decode7.sv - ELEX7660 module for Lab1
// Teylor Wong 2025-01-14

module decode7 (
    input logic [3:0] idnum,
    output logic [7:0] leds );

    always_comb
        case (idnum)
            4'h0 : leds = 8'h7E;   // 0 on 7-Segment Display
            4'h1 : leds = 8'h30;   // 1 on 7-Segment Display
            4'h2 : leds = 8'h6D;   // 2 on 7-Segment Display
            4'h3 : leds = 8'h79;   // 3 on 7-Segment Display
            4'h4 : leds = 8'h33;   // 4 on 7-Segment Display
            4'h5 : leds = 8'h5B;   // 5 on 7-Segment Display
            4'h6 : leds = 8'h5F;   // 6 on 7-Segment Display
            4'h7 : leds = 8'h70;   // 7 on 7-Segment Display
            4'h8 : leds = 8'h7F;   // 8 on 7-Segment Display
            4'h9 : leds = 8'h7B;   // 9 on 7-Segment Display
            4'hA : leds = 8'h77;   // A on 7-Segment Display
            4'hB : leds = 8'h1F;   // b on 7-Segment Display
            4'hC : leds = 8'h4E;   // C on 7-Segment Display
            4'hD : leds = 8'h3D;   // d on 7-Segment Display
            4'hE : leds = 8'h4F;   // E on 7-Segment Display
            4'hF : leds = 8'h47;   // F on 7-Segment Display
        endcase
endmodule