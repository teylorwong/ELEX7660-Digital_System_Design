// adcinterface.sv - lab4 module that interfaces with the ltc2308 ADC
// Teylo Wong 01/31/25

module adcinterface(
    input  logic clk, reset_n,     // clock and reset
    input  logic [2:0] chan,       // ADC channel to sample
    output logic [11:0] result,    // ADC result
    // ltc2308 signals
    input  logic ADC_SDO,
    output logic ADC_CONVST, ADC_SCK, ADC_SDI );

    typedef enum logic [2:0] {IDLE, CONV_HIGH, CONV_LOW, SHIFTING, WAIT_NEXT} state_t;
    state_t state;
    logic [3:0] sck_count;
    logic [5:0] config_word;

    // Config word for SDI signal: S/D - O/S - S1 - S0 - UNI - SLP
    assign config_word = {1'b1, 1'b0, chan[2], chan[1], chan[0], 1'b0};
    // gate the clock output to the ADC_SCK signal
    assign ADC_SCK = (state == SHIFTING) ? clk : 1'b0;

    // ChatGPT helped me with this block of code
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            sck_count <= '0;
            result <= '0;
            ADC_CONVST <= 1'b1;
            ADC_SDI <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    ADC_CONVST <= 1'b1;
                    sck_count <= '0;
                    state <= CONV_HIGH;
                end
                CONV_HIGH: begin
                    ADC_CONVST <= 1'b0;
                    state <= CONV_LOW;
                end
                CONV_LOW: begin
                    ADC_CONVST <= 1'b1;
                    state <= SHIFTING;
                end
                SHIFTING: begin
                    if (sck_count < 12) begin
                        if (!ADC_SCK) ADC_SDI <= config_word[5 - sck_count];
                        else begin
                            result <= {result[10:0], ADC_SDO};
                            sck_count <= sck_count + 1'b1;
                        end
                    end else state <= WAIT_NEXT;
                end
                WAIT_NEXT: state <= IDLE;
            endcase
        end
    end
endmodule
