// fourPhaseHandshake.sv - 4-phase handshake module between two clock domains
// Which makes sure that clk1 and clk2 In's and Out's are only vvalid for one clock cycle
// and also shows the internal handshake signals

module fourPhaseHandshake #(
    parameter WIDTH = 8
)(
    input  logic clk1, clk2,
    input  logic rst1, rst2,

    // clk1 domain
    input  logic [WIDTH-1:0] dataIn,
    input  logic             validIn,
    output logic             ready,

    // clk2 domain
    output logic [WIDTH-1:0] dataOut,
    output logic             validOut,

    // handshake signals
    output logic req, ack,
    output logic req2a, req2b,
    output logic ack1a, ack1b
);

    logic [WIDTH-1:0] dataReg;
    logic [WIDTH-1:0] dataBuffer;

    ////////////////////////////////////////////////
    // clk1 domain logic

    always_ff @(posedge clk1 or posedge rst1) begin
        if (rst1) begin
            req     <= 0;
            ready   <= 1;
            dataReg <= 0;
        end else begin
            if (ready && validIn) begin
                req     <= 1;
                ready   <= 0;
                dataReg <= dataIn;
            end else if (!ready && ack1b) begin
                req   <= 0;
                ready <= 1;
            end
        end
    end

    // sync ack back to clk1
    always_ff @(posedge clk1 or posedge rst1) begin
        if (rst1) begin
            ack1a <= 0;
            ack1b <= 0;
        end else begin
            ack1a <= ack;
            ack1b <= ack1a;
        end
    end

    ////////////////////////////////////////////////
    // clk2 domain logic
    
    typedef enum logic [1:0] {IDLE, VALID} state_t;
    state_t state;

    always_ff @(posedge clk2 or posedge rst2) begin
        if (rst2) begin
            req2a     <= 0;
            req2b     <= 0;
            ack       <= 0;
            validOut  <= 0;
            dataOut   <= 0;
            dataBuffer <= 0;
            state     <= IDLE;
        end else begin
            // sync req from clk1 to clk2
            req2a <= req;
            req2b <= req2a;

            case (state)
                IDLE: begin
                    if (req2b) begin
                        dataBuffer <= dataReg;
                        dataOut    <= dataReg;
                        ack        <= 1;
                        validOut   <= 1;
                        state      <= VALID;
                    end else begin
                        ack      <= 0;
                        validOut <= 0;
                    end
                end

                VALID: begin
                    ack      <= 1;
                    validOut <= 0;

                    if (!req2b) begin
                        ack   <= 0;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule
