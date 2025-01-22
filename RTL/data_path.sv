module data_path # (parameter mode=32) (
    input  logic clk, 
    input  logic reset_n,

    //control signals 
    input logic en_pc,
    input logic RegWrite,    //enable wirte to reg file
    input logic AluSrc,      //select alu suorce 
    input logic [3:0]AluSel, //to select alu opration
    input logic Mem_read,    //enable mem read
    input logic Mem_write,   //enable mem write 
    input logic [1:0]sel_data_to_reg     //select write to reg file from alu or data memory or PC+4 or Upper
);



logic [mode-1:0]alu_out;
logic [mode-1:0]data_out1;  //rs1
logic [mode-1:0]data_out2;  //rs2
logic [mode-1:0]data_in;    //data in reg file
logic [mode-1:0]current_pc  , next_pc ;
logic [mode-1:0]instruction ;
logic [31:0]imm;            //immediate value
logic [mode-1:0]mem_out;    //data out from memory


//pc
program_counter #(
    .n(mode)
)pc(
    .clk(clk),
    .reset_n(reset_n),
    .enable(en_pc),
    .pc_in(next_pc),
    .pc_out(current_pc)
);



//PC_updater 
PC_updater #(.mode(mode))PC_updater(
    .current_pc(current_pc),
    .rs1(data_out1),
    .rs2(data_out2),
    .imm(imm),
    .opcode(instruction[6:0]),
    .fun3(instruction[14:12]),
    .next_pc(next_pc)
);


//instruction memory 
inst_mem #(
    .IMEM_size(800), 
    .mode(mode)
)instruction_memory(
    .addr(current_pc),
    .inst(instruction)
);





//reg file
always_comb begin // mux to select which the path  of the data going to reg file 
    case (sel_data_to_reg)
        0: data_in= mem_out; //from mem
        1: data_in= alu_out; //from alu
        2: data_in= current_pc+4; // jal & jalr
        3: if (instruction[6:0]==7'b0110111) 
           data_in= imm; //LUI
           else
           data_in= imm+current_pc; // auipc
    endcase
end


reg_file #(
    .mode(mode) ,
    .reg_number(32)

)registers_file(
    .clk(clk), 
    .reset_n(reset_n),
    .write(RegWrite),                      // enable write to rs (reg_file[sel_write_reg] <= data_in;) 
    .sel_read_reg1(instruction[19:15]),    // address for reading from rs1 (we need 5 bit to address 32 Registers ) 
    .sel_read_reg2(instruction[24:20]),    // address for reading from rs2
    .sel_write_reg(instruction[11:7]),     // address for wrting to  rd
    .data_in(data_in),                     // rd  data coming from alu or memory
    .data_out1(data_out1),                 // rs1 data going to alu1
    .data_out2(data_out2)                  // rs2 data going to mux
);




//immediate_generator
imm_gen immediate_generator(
    .instruction(instruction),
    .imm(imm)
);




//ALU
alu #(
    .ALU_WIDTH(mode)
)alu(
    .op1(data_out1), 
    .op2(AluSrc? imm:data_out2),
    .alu_op(AluSel), // we have 10 instruction so we need 4 bit to select amoung them
    .alu_out(alu_out)
);


//mem
data_memory #(
    .size(1024) 
)memory(
    .clk(clk), 
    .reset_n(reset_n),
    .mem_write(Mem_write),  //enable signals
    .mem_read(Mem_read),
    .addr(alu_out), 
    .fun3(instruction[14:12]),  
    .opcode(instruction[6:0]),  
    .data_in(data_out2),
    .data_out(mem_out)
);


endmodule
