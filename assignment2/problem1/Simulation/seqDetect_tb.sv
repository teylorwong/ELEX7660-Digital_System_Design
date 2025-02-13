// Assignment 2: Problem1 - Sequence Detector Testbench
// seqDetect_tb.sv - tests module as a 3-bit sequence detector (N=3)
// Teylor Wong 12-02-2025

module seqDetect_tb;

    logic valid, a;  
    logic [2:0] seq;
    logic clk, reset_n;

    seqDetect #(.N(3)) dut(.valid(valid), .a(a), .seq(seq), .clk(clk), .reset_n(reset_n));

    // clock that toggles every 5 time units
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    // Testing
    initial begin
        // Initialize signals
        reset_n = 0;
        a = 0;
        seq = 3'b110; // Set a specific sequence
        $display("Sequence to detect: %b", seq);
        #10;

        reset_n = 1;
        #10;

        // Test all 3-bit combinations
        a = 0; #10; a = 0; #10; a = 0; #10; #10;
        $display("Input: 000, Valid: %b", valid);

        a = 0; #10; a = 0; #10; a = 1; #10; #10;
        $display("Input: 001, Valid: %b", valid);

        a = 0; #10; a = 1; #10; a = 0; #10; #10;
        $display("Input: 010, Valid: %b", valid);

        a = 0; #10; a = 1; #10; a = 1; #10; #10;
        $display("Input: 011, Valid: %b", valid);

        a = 1; #10; a = 0; #10; a = 0; #10; #10;
        $display("Input: 100, Valid: %b", valid);

        a = 1; #10; a = 0; #10; a = 1; #10; #10;
        $display("Input: 101, Valid: %b", valid);

        a = 1; #10; a = 1; #10; a = 0; #10; #10;
        $display("Input: 110, Valid: %b", valid);

        a = 1; #10; a = 1; #10; a = 1; #10; #10;
        $display("Input: 111, Valid: %b", valid);

        $stop;
    end

    initial begin
        $dumpfile("seqDetect_wave.vcd");
        $dumpvars(0, seqDetect_tb);
    end
endmodule
