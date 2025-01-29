// problem2.sv - for Assignment 1: Designing an 8-bit shift register with
// an asynchronous active low reset and functionality from given table
// Teylor Wong 01-29-25

module problem2 (
    input logic [7:0] a,
    input logic [1:0] s,
    input logic shiftIn, clk, reset_n,
    output logic [7:0] q );

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            q <= 8'b0;  // reset to zeros
        end
        else begin
            case(s)
                2'b00: q <= a;                  // Parallel load
                2'b01: q <= {shiftIn, a[7:1]};  // Shift right
                2'b10: q <= {a[6:0], shiftIn};  // Shift left
                2'b11: q <= q;                  // Hold
            endcase
        end
    end
endmodule