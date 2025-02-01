// problem2_tb.sv - for Assignment 1: Tetbench simulation for the 8-bit shift register
// Teylor Wong 01-29-25

module problem2_tb();
    logic [7:0] q;        // output
    logic [7:0] a;        // input
    logic [1:0] s;        // input
    logic shiftIn;        // input
    logic clk, reset_n;

    problem2 dut(.q(q), .a(a), .s(s), .shiftIn(shiftIn), .clk(clk), .reset_n(reset_n));

    // clock that toggles every 5 time units
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    // Testing
    initial begin
        // Initialize signals
        reset_n = 0;
        a = 8'b10101010;  // Test data
        s = 2'b00;
        shiftIn = 0;
        #10;

        reset_n = 1;
        #10;

        // Test parallel load (s = 00)
        $display("Testing parallel load");
        #10;
        // Test shift right (s = 01)
        s = 2'b01;
        shiftIn = 1;
        $display("Testing shift right");
        #20;
        // Test shift left (s = 10)
        s = 2'b10;
        shiftIn = 0;
        $display("Testing shift left");
        #20;
        // Test hold (s = 11)
        s = 2'b11;
        $display("Testing hold");
        #20;

        $stop;
    end

    // Create waveform - by ChatGPT
    initial begin
        $dumpfile("shiftreg_wave.vcd");
        $dumpvars(0, problem2_tb);
    end

endmodule
