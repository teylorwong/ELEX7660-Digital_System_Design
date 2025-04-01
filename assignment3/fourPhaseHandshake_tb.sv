// fourPhaseHandshake_tb.sv - Testbench for fourPhaseHandshake
// Teylor Wong 01/31/25

module fourPhaseHandshake_tb;
    localparam int DATA_WIDTH = 8;

    logic clk1, clk2;
    logic [DATA_WIDTH-1:0] dataIn;
    logic validIn, ready;
    logic [DATA_WIDTH-1:0] dataOut;
    logic validOut;

    // DUT
    fourPhaseHandshake #(.DATA_WIDTH(DATA_WIDTH)) dut (.clk1(clk1),.clk2(clk2),.dataIn(dataIn),
    .validIn(validIn),.ready(ready),.dataOut(dataOut),.validOut(validOut));

    // Clock generation
    always #5 clk1 = ~clk1; // 100 MHz
    always #7 clk2 = ~clk2; // 71.4 MHz

    initial begin
        // Initialize signals
        clk1 = 0; clk2 = 0;
        dataIn = 0; validIn = 0;

        // Send first data
        #20;
        dataIn = 8'hA5;
        validIn = 1;
        wait (ready);
        #10 validIn = 0;

        // Send second data
        #50;
        dataIn = 8'h3C;
        validIn = 1;
        wait (ready);
        #10 validIn = 0;

        // Finish test
        #100;
        $stop;
    end

endmodule
