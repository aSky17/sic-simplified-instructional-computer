`ifndef SIC_CPU_SV
`define SIC_CPU_SV

module sic_cpu #(parameter ADDRESS_WIDTH = 15, DATA_WIDTH = 24)(
    input logic clk,
    input logic rst,
    input logic [DATA_WIDTH-1:0] instruction,
    output logic [ADDRESS_WIDTH-1:0] memory_address,
    output logic [DATA_WIDTH-1:0] memory_write_data,
    input logic [DATA_WIDTH-1:0] memory_read_data,
    output logic write_enable
);
    
    /**
     *6-registers: all 24 bits
     *A: accumulator, used for mathematical operations
     *X: index register, used in indexed addressing
     *L: linkage register, stores return address
     *PC: program counter
     *SW: status word, contains mode,state,PID,condition codes,interurput fields etc
     *IR: intruction register, temporarily holds the current instruction begin decoded/executed
    */
    logic [DATA_WIDTH-1:0] A,X,L,PC,SW,IR;

    /**
    *intruction decoder outputs
    *6 bit opcode
    *15 bit address
    *1 bit index flag, check whether indexed addressing is enabled(2nd bit of IR)
    */
    logic [5:0] opcode;
    logic [ADDRESS_WIDTH-1:0] address;
    logic index_flag;

    //if index_flag is 1, effective address is calculated as address+X
    logic [ADDRESS_WIDTH-1:0] effective_address;

    //alu signals
    logic [DATA_WIDTH-1:0] alu_output;
    logic [2:0] condition_flags;

    //instantiating instruction decode
    instruction_decoder u_decoder(
        .instruction(IR),
        .opcode(opcode),
        .address(address),
        .index_flag(index_flag)
    );

    //instantiating alu 
    alu u_alu(
        .opcode(opcode),
        .A(A),
        .B(memory_read_data),
        .result(alu_output),
        .flags(condition_flags)
    );

    typedef enum logic [1:0] {FETCH, DECODE, EXECUTE} state_t;
    state_t state;

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            PC <= 24'd0;
            state <= FETCH;
        end else begin
            case (state)
                FETCH: begin 
                    memory_address <= PC[ADDRESS_WIDTH-1:0];
                    write_enable <= 0;
                    state <= DECODE;
                end
                DECODE: begin 
                    IR <= memory_read_data;
                    state <= EXECUTE;
                end
                EXECUTE: begin 
                    effective_address = index_flag ? (address+X[ADDRESS_WIDTH-1:0]) : address;
                    case(opcode)
                        //LDA
                        6'h00: A <= memory_read_data; 
                        //STA
                        6'h0C: begin 
                            memory_address <= effective_address;
                            memory_write_data <= A;
                            write_enable <= 1;
                        end
                        //LDX
                        6'h04: X <= memory_read_data;
                        //STX
                        6'h10: begin
                            memory_address <= effective_address;
                            memory_write_data <= X;
                            write_enable <= 1;
                        end  
                        //ADD
                        6'h18: A <= alu_output;
                        //SUB
                        6'h1C: A <= alu_output;
                        //COMP, sets cc flag
                        6'h28: SW[6:4] <= condition_flags;
                        //JUMP
                        6'h3C: PC <= address;
                    endcase
                    write_enable <= 0;
                    PC <= PC+3; //next instruction as word size is 3 bytes
                    state <= FETCH;
                end
            endcase
        end
    end
endmodule
`endif