// fourPhaseHandshake_tb.sv - testbench for fourPhaseHandshake
// Generates two clock domains and drives valildIn for one clk1 cycle, then
// shows th handshake signals and data transfer.

module fourPhaseHandshake_tb;

    parameter WIDTH = 8;

    logic clk1 = 0, clk2 = 0;
    logic rst1 = 1, rst2 = 1;

    logic [WIDTH-1:0] dataIn;
    logic             validIn;
    logic             ready;

    logic [WIDTH-1:0] dataOut;
    logic             validOut;

    logic req, ack;
    logic req2a, req2b;
    logic ack1a, ack1b;

    // clocks
    always #5  clk1 = ~clk1;
    always #7  clk2 = ~clk2;

    fourPhaseHandshake #(.WIDTH(WIDTH)) dut (
        .clk1, .clk2, .rst1, .rst2,
        .dataIn, .validIn, .ready,
        .dataOut, .validOut,
        .req, .ack, .req2a, .req2b, .ack1a, .ack1b
    );

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, fourPhaseHandshake_tb);

        dataIn  = 0;
        validIn = 0;

        // deassert resets
        #20;
        rst1 = 0;
        rst2 = 0;

        // wait until clk1 is ready
        @(posedge clk1);
        wait(ready);

        // 1-cycle transaction
        dataIn   = $urandom_range(1, 255);
        validIn  = 1;
        @(posedge clk1);
        validIn  = 0;

        // observe behavior
        #200;
        $stop;
    end

endmodule
