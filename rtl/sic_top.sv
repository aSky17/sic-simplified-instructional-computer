`ifndef SIC_TOP_SV
`define SIC_TOP_SV

module sic_top #(
    parameter ADDRESS_WIDTH = 15,
    parameter DATA_WIDTH = 24
)(
    input logic clk,
    input logic rst
);
    
    logic [DATA_WIDTH-1:0] instruction;
    logic [ADDRESS_WIDTH-1:0] memory_address;
    logic [DATA_WIDTH-1:0] memory_read_data, memory_write_data;
    logic memory_write_enable;

    // Memory and CPU
    sic_memory u_mem(
    .clk(clk),
    .write_enable(memory_write_enable),
    .address(memory_address),
    .memory_write_data(memory_write_data),
    .memory_read_data(memory_read_data)
  );

  sic_cpu #(
    .ADDR_WIDTH(ADDRESS_WIDTH),
    .DATA_WIDTH(DATA_WIDTH)
  ) u_cpu(
    .clk(clk),
    .rst(rst),
    .instruction(instruction),
    .memory_address(memory_address),
    .memory_read_data(memory_read_data),
    .memory_write_data(memory_write_data),
    .write_enable(memory_write_enable)
  );

    //fetch current instruction
    assign instruction = memory_read_data;
endmodule

`endif