// Assignment 2: Problem1 - Sequence Detector
// seqDetect.sv - valid is asserted for one clock cycle if last N 'a' bits match the sequence
// Teylor Wong 02-12-2025

module seqDetect #(parameter N=6) (
    output logic valid,
    input logic a, input logic [N-1:0] seq,
    input logic clk, reset_n
);

    logic [N-1:0] reg_seq, reg_seq_next; // Register to store sequence

always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        reg_seq <= 0;
        valid <= 0;
    end else begin
        reg_seq_next = {reg_seq[N-2:0], a};  // Shift in new bit
        reg_seq <= reg_seq_next;  // Store the new sequence

        if (reg_seq_next == seq)  
            valid <= 1;  // Assert valid when sequence matches
        else 
            valid <= 0;  // Otherwise, clear valid
    end
end

endmodule

