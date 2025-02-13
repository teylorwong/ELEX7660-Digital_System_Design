// Assignment 2: Problem1 - Sequence Detector
// seqDetect.sv - valid is asserted for one clock cycle if last N 'a' bits match the sequence
// Teylor Wong 12-02-2025

module seqDetect #(parameter N=6) (
    output logic valid,
    input logic a, input logic [N-1:0] seq,
    input logic clk, reset_n );

    logic [N-1:0] reg_seq; // register to store the sequence
    int bit_counter;  // tracks # of bits input

always_ff @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        reg_seq <= 0;
        valid <= 0;
        bit_counter <= 0;
    end
    else begin
        if (bit_counter < N) 
            bit_counter <= bit_counter + 1;

        if (bit_counter >= N-1) begin
            if (reg_seq == seq) 
                valid <= 1;
            else 
                valid <= 0;
        end
        
        reg_seq <= {reg_seq[N-2:0], a}; // Now shift AFTER checking
    end
end

endmodule
