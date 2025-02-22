// Assignment 2: Problem1 - Sequence Detector Testbench
// seqDetect_tb.sv - tests module as a 3-bit sequence detector (N=3)
// Teylor Wong 02-12-2025

`timescale 1ms/1ms

module seqDetect_tb;
    logic clk = 1;       // Clock signal
    logic reset_n;       // Reset signal
    logic a;
    logic valid;
    logic [2:0] seq = 3'b100;  // Expected sequence
    logic [2:0] test_register = 0;  // Tracks input bits

    // Instantiate sequence detector with N=3
    seqDetect #(3) DUT (.valid(valid), .a(a), .seq(seq), .clk(clk), .reset_n(reset_n));

    // Generate clock
    always #25ms clk = ~clk;

    initial begin
        // Apply reset
        reset_n = 0;
        a = 0;
        repeat(2) @(negedge clk);
        reset_n = 1;

        // Test all 3-bit sequences (000 - 111)

        // 000 - Incorrect
        a = 0; test_register = {test_register[1:0], a}; @(negedge clk);
        a = 0; test_register = {test_register[1:0], a}; @(negedge clk);
        a = 0; test_register = {test_register[1:0], a}; @(negedge clk);
        check_result();

        // 001 - Incorrect
        a = 0; test_register = {test_register[1:0], a}; @(negedge clk);
        a = 0; test_register = {test_register[1:0], a}; @(negedge clk);
        a = 1; test_register = {test_register[1:0], a}; @(negedge clk);
        check_result();

        // 010 - Incorrect
        a = 0; test_register = {test_register[1:0], a}; @(negedge clk);
        a = 1; test_register = {test_register[1:0], a}; @(negedge clk);
        a = 0; test_register = {test_register[1:0], a}; @(negedge clk);
        check_result();

        // 011 - Incorrect
        a = 0; test_register = {test_register[1:0], a}; @(negedge clk);
        a = 1; test_register = {test_register[1:0], a}; @(negedge clk);
        a = 1; test_register = {test_register[1:0], a}; @(negedge clk);
        check_result();

        // 100 - Correct
        a = 1; test_register = {test_register[1:0], a}; @(negedge clk);
        a = 0; test_register = {test_register[1:0], a}; @(negedge clk);
        a = 0; test_register = {test_register[1:0], a}; @(negedge clk);
        check_result();

        // 101 - Incorrect
        a = 1; test_register = {test_register[1:0], a}; @(negedge clk);
        a = 0; test_register = {test_register[1:0], a}; @(negedge clk);
        a = 1; test_register = {test_register[1:0], a}; @(negedge clk);
        check_result();

        // 110 - Incorrect
        a = 1; test_register = {test_register[1:0], a}; @(negedge clk);
        a = 1; test_register = {test_register[1:0], a}; @(negedge clk);
        a = 0; test_register = {test_register[1:0], a}; @(negedge clk);
        check_result();

        // 111 - Incorrect
        a = 1; test_register = {test_register[1:0], a}; @(negedge clk);
        a = 1; test_register = {test_register[1:0], a}; @(negedge clk);
        a = 1; test_register = {test_register[1:0], a}; @(negedge clk);
        check_result();

        $stop;  // End simulation
    end

    // Function to check result and print test outcome
    task check_result;
        if (valid) begin
            if (test_register == seq)
                $display("PASS: Sequence %b detected correctly", test_register);
            else
                $display("FAIL: False detection for %b", test_register);
        end else begin
            if (test_register == seq)
                $display("FAIL: Expected detection for %b, but valid was not asserted", test_register);
            else
                $display("PASS: No detection as expected for %b", test_register);
        end
    endtask
endmodule
