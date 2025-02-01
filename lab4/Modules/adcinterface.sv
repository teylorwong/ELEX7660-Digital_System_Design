// adcinterface.sv - lab4 module that interfaces with the ltc2308 ADC
// Teylo Wong 01/31/25

module adcinterface(
    input logic clk, reset_n,    // clock and reset
    input logic [2:0] chan,      // ADC channel to sample
    output logic [11:0] result,  // ADC result
    // ltc2308 signals
    output logic ADC_CONVST, ADC_SCK, ADC_SDI,
    input logic ADC_SDO
);

    // Define states for the state machine
    typedef enum logic [1:0] {
        STATE_IDLE,          // Waiting to start conversion
        STATE_CONVST_PULSE,  // Pulse ADC_CONVST high
        STATE_SEND_CONFIG,   // Send configuration bits
        STATE_CAPTURE_DATA   // Capture ADC result
    } state_t;

    state_t state;          // Current state
    logic [3:0] sck_count;      // sck_counter for clock cycles

    // State transition logic
    always_ff @(negedge clk or negedge reset_n) begin
        if (~reset_n) begin
            state <= STATE_IDLE;
            sck_count <= 4'b0000;
            ADC_CONVST <= 1'b0;
        end else begin
            case (state)
                STATE_IDLE: begin
                    state <= STATE_CONVST_PULSE;
                    sck_count <= 4'b0000;
                end

                STATE_CONVST_PULSE: begin
                    ADC_CONVST <= (sck_count == 4'b0000) ? 1'b1 : 1'b0;  // Pulse CONVST high for one cycle
                    state <= (sck_count == 4'b0000) ? STATE_CONVST_PULSE : STATE_SEND_CONFIG;
                    sck_count <= sck_count + 1;
                end

                STATE_SEND_CONFIG: begin
                    state <= (sck_count == 4'b1101) ? STATE_CAPTURE_DATA : STATE_SEND_CONFIG;
                    sck_count <= sck_count + 1;
                end

                STATE_CAPTURE_DATA: begin
                    state <= (sck_count == 4'b1110) ? STATE_IDLE : STATE_CAPTURE_DATA;
                    sck_count <= sck_count + 1;
                end

                default: state <= STATE_IDLE;
            endcase
        end
    end

    // Clock gating for ADC_SCK
    assign ADC_SCK = ((sck_count > 4'b0010) && (sck_count <= 4'b1110)) ? clk : 1'b0;

    // Control ADC_SDI based on the sck_count value
    always_ff @(negedge clk) begin
        ADC_SDI <= (sck_count == 4'b0010) ? 1'b1 :
                   (sck_count == 4'b0011) ? chan[0] :
                   (sck_count == 4'b0100) ? chan[2] :
                   (sck_count == 4'b0101) ? chan[1] :
                   (sck_count == 4'b0110) ? 1'b1 :
                   (sck_count == 4'b0111) ? 1'b0 :
                   1'b0;  // Default value
    end

    // Capture ADC_SDO data into the result register
    always_ff @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            result <= 12'h0;
        end else if ((sck_count > 4'b0010) && (sck_count <= 4'b1110)) begin
            result <= {result[10:0], ADC_SDO};  // Shift left and capture ADC_SDO
        end
    end

endmodule