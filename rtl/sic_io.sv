`ifndef SIC_IO_SV
`define SIC_IO_SV

module sic_io (
    input logic clk,
    input logic rst,
    input logic read_enable,
    input logic write_enable,
    output logic device_ready,
    input logic [7:0] in_data,
    output logic [7:0] out_data,
    output logic write_event
);
    
    always_ff @(posedge clk or posedge rst) begin 

        if(rst) begin 
            out_data <= 8'd0;
            write_event <= 1'b0;
        end else begin 
            if (write_enable) begin 
                out_data <= in_data;
                write_event <= 1'b1;
            end else begin 
                write_event <= 1'b0;
            end
        end
    end

    //device always ready
    assign device_ready = 1'b1;
endmodule

`endif