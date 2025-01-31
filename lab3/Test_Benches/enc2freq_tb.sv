`timescale 1ns / 1ps

module enc2freq_tb;

    // Testbench signals
    logic clk;                  // Clock signal
    logic reset_n;              // Active-low reset
    logic cw, ccw;              // Encoder signals (clockwise and counterclockwise)
    logic [31:0] freq;          // Output frequency
    logic [31:0] expected_freq; // Expected frequency for verification

    // Instantiate the enc2freq module
    enc2freq dut (.cw(cw),.ccw(ccw),.freq(freq),.reset_n(reset_n),.clk(clk));

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

        // Test 1: Rotate clockwise through all frequencies (C4 -> C5)
        $display("Test 1: Rotate clockwise (C4 -> C5)");
        for (int i = 0; i < 7; i++) begin
            cw = 1; #10; cw = 0; #10; // Simulate 1 cw pulse
            expected_freq = (i == 0) ? 295 : (i == 1) ? 328 : (i == 2) ? 349 : 
                           (i == 3) ? 393 : (i == 4) ? 437 : (i == 5) ? 491 : 524;
            if (freq == expected_freq)
                $display("PASS: Frequency = %0d Hz (Expected %0d Hz)", freq, expected_freq);
            else
                $display("FAIL: Frequency = %0d Hz (Expected %0d Hz)", freq, expected_freq);
        end

        // Test 2: Rotate counterclockwise through all frequencies (C5 -> C4)
        $display("Test 2: Rotate counterclockwise (C5 -> C4)");
        for (int i = 0; i < 7; i++) begin
            ccw = 1; #10; ccw = 0; #10; // Simulate 1 ccw pulse
            expected_freq = (i == 0) ? 491 : (i == 1) ? 437 : (i == 2) ? 393 : 
                           (i == 3) ? 349 : (i == 4) ? 328 : (i == 5) ? 295 : 262;
            if (freq == expected_freq)
                $display("PASS: Frequency = %0d Hz (Expected %0d Hz)", freq, expected_freq);
            else
                $display("FAIL: Frequency = %0d Hz (Expected %0d Hz)", freq, expected_freq);
        end

        // Test 3: Reset the module
        $display("Test 3: Reset the module");
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
