`ifndef SIC_MEMORY_SV
`define SIC_MEMORY_SV

module sic_memory #(
    parameter MEMORY_SIZE = 32768,
    parameter DATA_SIZE = 24,
    parameter ADDRESS_WIDTH = 15
) (
    input logic clk,
    input logic write_enable,
    input logic [ADDRESS_WIDTH-1:0] address,
    input logic [DATA_SIZE-1:0] memory_write_data,
    output logic [DATA_SIZE-1:0] memory_read_data
);
    
    //byte addressable 32kB memory
    logic [7:0] memory [0:MEMORY_SIZE-1];

    always_ff @(posedge clk) begin 
        if (write_enable) begin 
            memory[address] <= memory_write_data[23:16];
            memory[address + 1] <= memory_write_data[15:8];
            memory[address + 2] <= memory_write_data[7:0];
        end
    end

    always_comb begin
        memory_read_data = {memory[address],memory[address + 1],memory[address + 2]};
    end
    
endmodule

`endif