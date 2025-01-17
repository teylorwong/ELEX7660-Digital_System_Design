// bcitid.sv - ELEX7660 module for Lab1
// Teylor Wong 2025-01-14

module bcitid (
    input logic [1:0] digit,
    output logic [3:0] idnum );

    logic [3:0] id_mem [3:0];

    initial begin
        id_mem[3] = 4'd5;
        id_mem[2] = 4'd9;
        id_mem[1] = 4'd9;
        id_mem[0] = 4'd4;
    end

    always_comb
        case(digit)
        4'b11 : idnum = id_mem[3];
        4'b10 : idnum = id_mem[2];
        4'b01 : idnum = id_mem[1];
        4'b00 : idnum = id_mem[0];
        endcase
endmodule