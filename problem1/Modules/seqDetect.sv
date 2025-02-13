// Assignment 2: Problem1 - Sequence Detector
// seqDetect.sv - valid is asserted for one clock cycle if last N 'a' bits match the sequence
// Teylor Wong 12-02-2025

module seqDetect #(parameter N=6) (
    output logic valid,
    input logic a, input logic [N-1:0] seq,
    input logic clk, reset_n );

    logic [N-1:0] reg_seq; // register to store the sequence
    logic [N-1:0] bit_counter;  // tracks # of bits input

    always_ff @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            reg_seq <= 0;
            valid <= 0;
            bit_counter <= 0;
        end
        else begin
            reg_seq <= {reg_seq[N-2:0], a}; // shift in the new input
            if (bit_counter < N) begin   // compare the sequence with new input
                bit_counter <= bit_counter + 1;
            end else if (bit_counter >= N-1 && reg_seq == seq) begin
                valid <= 1; // valid for one clock cycle
            end else
                valid <= 0;
        end
    end

endmodule