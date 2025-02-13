// Assignment 2: Problem2 - Vending Machine
// vendingMachine.sv - keeps track of the amount of money put
// into a vending machine and asserts the valid output for one cycle
// Teylor Wong 12-02-2025

module vendingMachine (
    output logic valid,
    input logic nickel, dime, quarter,
    input logic clk, reset_n
);
    logic [6:0] total; // Using 7 bits to store cents (max 100)
    
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            total <= 0;
            valid <= 0;
        end
        else begin
            // Add coin values: nickel = 5, dime = 10, quarter = 25
            total <= total + (nickel * 5) + (dime * 10) + (quarter * 25);
            
            if (total >= 100) begin
                valid <= 1;  // Assert valid for one cycle
                total <= 0;   // Reset after purchase
            end
            else begin
                valid <= 0;
            end
        end
    end
endmodule
