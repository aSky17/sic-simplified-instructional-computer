`ifndef SIC_ALU_SV
`define SIC_ALU_SV

module alu #(
    parameter DATA_WIDTH = 24,
    parameter OPCODE_WIDTH = 6,
    parameter FLAG_WIDTH = 3
) (
    input logic [OPCODE_WIDTH-1:0] opcode,
    input logic [DATA_WIDTH-1:0] A,
    input logic [DATA_WIDTH-1:0] B,
    output logic [DATA_WIDTH-1:0] result,
    //100 for EQ, 010 for LT, 001 for GT
    output logic [FLAG_WIDTH-1:0] flags
);
    
    always_comb begin
        case(opcode)
            6'h18: result = A+B;
            6'h1C: result = A-B;
            6'h28: result = 24'd0; //for COMP
            default: result = 23'd0;
        endcase

        if (opcode == 6'h28) begin
            flags = (A==B) ? 3'b100 : ((A<B) ? 3'b010 : 3'b001);
        end else begin 
            flags = 3'b000;
        end
    end

endmodule
`endif