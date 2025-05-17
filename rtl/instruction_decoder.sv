`ifndef SIC_DECODER_SV
`define SIC_DECODER_SV

module moduleName #(
    parameter DATA_WIDTH = 24,
    parameter OPCODE_WIDTH = 6,
    parameter ADDRESS_WIDTH = 15
) (
    input logic [DATA_WIDTH-1:0] instruction,
    output logic [OPCODE_WIDTH-1:0] opcode,
    output logic [ADDRESS_WIDTH-1:0] address,
    output logic index_flag
);

    assign opcode = instruction[23:18];
    assign address = instruction[17:3];
    assign index_flag = instruction[2];
    
endmodule

`endif