module rv32i ;
    parameter mode = 32;  //32 or 64
    parameter instruction_memory_size = 800 ;
    parameter data_memory_size = 1024 ;

logic clk;
logic reset_n;
logic en_pc;
logic RegWrite;                 //enable wirte to reg file
logic AluSrc;                   //select alu suorce 
logic [3:0] AluSel;             //to select alu opration
logic Mem_read;                 //enable mem read
logic Mem_write;                //enable mem write 
logic [1:0]sel_data_to_reg;
logic [31:0]instruction;





///////////////////////
//data path 
////////////////////

 data_path #(
    .mode(mode),
    .IMEM_size(instruction_memory_size),
    .data_memory_size(data_memory_size)
 ) DataPath (
    .clk(clk),
    .reset_n(reset_n),
    .en_pc(en_pc),
    .RegWrite(RegWrite),  
    .AluSrc(AluSrc),  
    .AluSel(AluSel),  
    .Mem_read(Mem_read),  
    .Mem_write(Mem_write),  
    .sel_data_to_reg(sel_data_to_reg),
    .instruction(instruction)
 );     




//////////////////////
//control path
///////////////////
 
//main controller
logic [1:0]aluop;

 control_unit main_controller (
   .clk(clk) , 
    .reset_n(reset_n) ,
    .opcode(instruction[6:0]),
    .en_pc(en_pc),
    .RegWrite(RegWrite),
    .AluSrc(AluSrc),
    .Mem_read(Mem_read),
    .Mem_write(Mem_write),
    .sel_data_to_reg(sel_data_to_reg),
    .Alu_op(aluop)
 );


//alu controller
alu_control_unit  alu_controller(
.aluop(aluop),
.fun3(instruction[14:12]),
.fun7(instruction[30]),  // instruction bit [30]
.mode(AluSel)
); 






    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset_n = 0;
        #5;
        reset_n = 1;
    end

 

    
    initial begin
        #500;
        $finish;
    end

endmodule