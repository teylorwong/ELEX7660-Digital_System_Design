// adcinterface.sv - lab4 module that interfaces the ltc2308 ADC to the FPGA
// Teylor Wong 01-31-25

module adcinterface(
    input logic clk, reset_n, // clock and reset
    input logic [2:0] chan, // ADC channel to sample
    output logic [11:0] result, // ADC result
    // ltc2308 signals
    input logic ADC_SDO,
    output logic ADC_CONVST, ADC_SCK, ADC_SDI );

    typdef enum logic [2:0] {
        IDLE,           // Waiting state
        CONV_HIGH,      // CONVST pulse high
        CONV_LOW,       // CONVST pulse low
        SHIFTING,       // 12 cycles of data tranfer
        WAIT_NEXT       // Wait 1 cycle before next conversation
    } state_t;

    state_t state

endmodule