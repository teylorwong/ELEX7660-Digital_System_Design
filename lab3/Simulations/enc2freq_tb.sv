// enc2freq_tb.sv - Testbench for enc2freq module
// Teylor Wong 01/25/25

`timescale 1ns / 1ps

module enc2freq_tb;

    // Testbench signals
    logic clk;                  // Clock signal
    logic reset_n;              // Active-low reset
    logic cw, ccw;              // Encoder signals (clockwise and counterclockwise)
    logic [31:0] freq;          // Output frequency
    logic [31:0] expected_freq; // Expected frequency for verification

    // Instantiate the enc2freq module
    enc2freq dut (
        .cw(cw),
        .ccw(ccw),
        .freq(freq),
        .reset_n(reset_n),
        .clk(clk)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10 ns clock period (50 MHz)
    end

    // Testbench stimulus and verification
    initial begin
        // Initialize signals
        reset_n = 0;
        cw = 0;
        ccw = 0;
        expected_freq = 262; // Initial frequency (C4)

        // Apply reset
        #20;
        reset_n = 1;

        // Test 1: Rotate clockwise (increase frequency)
        $display("Test 1: Rotate clockwise (increase frequency)");
        repeat (4) begin
            cw = 1; #10; cw = 0; #10; // Simulate 4 cw pulses
        end
        expected_freq = 295; // Expected frequency (D4)
        if (freq == expected_freq)
            $display("PASS: Frequency = %0d Hz (Expected %0d Hz)", freq, expected_freq);
        else
            $display("FAIL: Frequency = %0d Hz (Expected %0d Hz)", freq, expected_freq);

        // Test 2: Rotate counterclockwise (decrease frequency)
        $display("Test 2: Rotate counterclockwise (decrease frequency)");
        repeat (4) begin
            ccw = 1; #10; ccw = 0; #10; // Simulate 4 ccw pulses
        end
        expected_freq = 262; // Expected frequency (C4)
        if (freq == expected_freq)
            $display("PASS: Frequency = %0d Hz (Expected %0d Hz)", freq, expected_freq);
        else
            $display("FAIL: Frequency = %0d Hz (Expected %0d Hz)", freq, expected_freq);

        // Test 3: Rotate clockwise multiple times (wrap around)
        $display("Test 3: Rotate clockwise multiple times (wrap around)");
        repeat (16) begin
            cw = 1; #10; cw = 0; #10; // Simulate 16 cw pulses
        end
        expected_freq = 262; // Expected frequency (C4, after wrapping around)
        if (freq == expected_freq)
            $display("PASS: Frequency = %0d Hz (Expected %0d Hz)", freq, expected_freq);
        else
            $display("FAIL: Frequency = %0d Hz (Expected %0d Hz)", freq, expected_freq);

        // Test 4: Rotate counterclockwise multiple times (wrap around)
        $display("Test 4: Rotate counterclockwise multiple times (wrap around)");
        repeat (16) begin
            ccw = 1; #10; ccw = 0; #10; // Simulate 16 ccw pulses
        end
        expected_freq = 262; // Expected frequency (C4, after wrapping around)
        if (freq == expected_freq)
            $display("PASS: Frequency = %0d Hz (Expected %0d Hz)", freq, expected_freq);
        else
            $display("FAIL: Frequency = %0d Hz (Expected %0d Hz)", freq, expected_freq);

        // Test 5: Reset the module
        $display("Test 5: Reset the module");
        reset_n = 0; #20; reset_n = 1; // Apply reset
        expected_freq = 262; // Expected frequency (C4, after reset)
        if (freq == expected_freq)
            $display("PASS: Frequency = %0d Hz (Expected %0d Hz)", freq, expected_freq);
        else
            $display("FAIL: Frequency = %0d Hz (Expected %0d Hz)", freq, expected_freq);

        // End simulation
        $display("Simulation complete.");
        $stop;
    end

endmodule
