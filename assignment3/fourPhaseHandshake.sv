// fourPhaseHandshake.sv - Transfers data from one clock domain to another
// Teylor Wong 01/31/25

module fourPhaseHandshake #(parameter DATA_WIDTH = 8) (
    input logic clk1, clk2,
    input logic [DATA_WIDTH-1:0] dataIn,
    input logic validIn,
    output logic ready,
    output logic [DATA_WIDTH-1:0] dataOut
    output logic validOut
);

    logic req, ack;
    logic [DATA_WIDTH-1:0] buffer;

    // Stuff for clk1
    always_ff @(posedge clk1) begin
        if (validIn && reay) begin
            buffer <= dataIn;
            req <= 1;
            ready <= 0;
        end else if (ack) begin
            req <= 0;
            ready <= 1;
        end
    end

    // clk2 stuff
    always_ff @(posedge clk2) begin
        if (req && !ack) begin
            dataOut <= buffer;
            validOut <= 1;
            ack <= 1;
        end else begin
            validOut <= 0;
            ack <= 0;
        end
    end
    
endmodule