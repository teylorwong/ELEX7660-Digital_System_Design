// Assignment 2: Problem2 - Vending Machine
// vendingMachine_tb.sv - testbench for vending machine
// Teylor Wong 12-02-2025

module vendingMachine_tb;
    logic valid;
    logic nickel, dime, quarter;
    logic clk, reset_n;

    vendingMachine dut (.valid(valid), .nickel(nickel), .dime(dime), .quarter(quarter), .clk(clk), .reset_n(reset_n));

    // Generate a clock signal (10ns period)
    always begin
        clk = 0; #5;
        clk = 1; #5;
    end

    initial begin
        // Initialize signals
        reset_n = 0; nickel = 0; dime = 0; quarter = 0;
        #10;
        reset_n = 1;  // Release reset
        #10;
        
        dime = 1; quarter = 1; #10; // resting multipl inputs simultaneously
        quarter = 0; dime = 0; #10;
        dime = 1; #10; dime = 0; #10;
        dime = 1; #10; dime = 0; #10;
        
        quarter = 1; #10; quarter = 0; #10;

        nickel = 1; #10; nickel = 0; #10;
        nickel = 1; #10; nickel = 0; #10;
        nickel = 1; #10; nickel = 0; #10;
        nickel = 1; #10; nickel = 0; #10;

        // valid should be asserted at this point
        #10

        $stop;
    end

    initial begin
        $dumpfile("vendingMachine_wave.vcd");
        $dumpvars(0, vendingMachine_tb);
    end
endmodule
