// problem1.sv - for Assignment 1: designign a priority encoder
// Teylor Wong 01-29-25

module problem1 (
    input logic [3:0] a,
    output logic [1:0] y,
    output logic valid );

    always_comb begin
            casex(a)
            4'b1xxx: begin y = 2'b11; valid = 1'b1; end
            4'b01xx: begin y = 2'b10; valid = 1'b1; end
            4'b001x: begin y = 2'b01; valid = 1'b1; end
            4'b0001: begin y = 2'b00; valid = 1'b1; end
            4'b0000: begin y = 2'b00; valid = 1'b0; end
            default: begin y = 2'b00; valid = 1'b0; end
        endcase
    end

endmodule