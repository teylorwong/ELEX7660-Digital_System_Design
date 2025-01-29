// problem1_tb.sv - for Assignment 1: Testbench for the priority encoder
// Teylor Wong 01-29-25

module problem1_tb ();
    // Test signals
    logic [3:0] a;
    logic [1:0] y;
    logic valid;

    // Instantiate the encoder
    encoder dut(.y(y), .valid(valid), .a(a));
    
    // Test stimulus
    initial begin
        $display("Starting test");

        // Test 16 combinations (0000 to 1111)
        for (int i = 0; i < 16; i++) begin
            a = i;
            #10;
            $display("Input a=%4b, Output y=%2b, valid=%b", a, y, valid);
        end

    $stop;

    end

    // Create waveform
    initial begin
        $dumpfile("encoder_wave.vcd");  // Create wave file
        $dumpvars(0, encoder_tb);       // Dump variables
    end

endmodule