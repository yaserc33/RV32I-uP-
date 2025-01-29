typedef enum logic [5:0] {
    R, 
    I, 
    Load,
    Store,
    B,
    jal,
    jalr,
    Lui,
    auipc,
    ecall_ebreak,
    ebreak,
    fence
} instructions;

module control_unit (
    input logic clk , reset_n ,
    input  logic [6:0] opcode,
    output logic       en_pc,
    output logic       RegWrite,
    output logic       AluSrc,
    output logic       Mem_read,
    output logic       Mem_write,
    output logic [1:0] sel_data_to_reg,
    output logic [1:0]  Alu_op

);

    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            en_pc <= 1'b0;
        end 
        else begin
            en_pc <= 1'b1;
        end
    end







    instructions op;


    always_comb begin : decode_op
        op = ecall_ebreak;  
        
        case (opcode)
            7'b0110011: op = R;      // R-type
            7'b0010011: op = I;      // I-type
            7'b0000011: op = Load;
            7'b0100011: op = Store;
            7'b1100011: op = B;     // B-type
            7'b1101111: op = jal;
            7'b1100111: op = jalr;
            7'b0110111: op = Lui;
            7'b0010111: op = auipc;
            

            7'b1110011: op = ecall_ebreak; 
            // ecall_ebreak and ebreak both share opcode=1110011
            // distinguish them with funct3/funct12. 
            7'b0001111: op = fence;
            
        endcase
    end


   
    always_comb begin : generate_signals
        RegWrite      = 1'b0;
        AluSrc        = 1'bx;
        Mem_read      = 1'b0;
        Mem_write     = 1'b0;
        sel_data_to_reg = 2'bxx;

        case (op)

            R: begin
                RegWrite        = 1;
                AluSrc          = 1'b1;      
                Mem_read        = 0;
                Mem_write       = 0;
                sel_data_to_reg = 2'b01; 
                Alu_op          = 2'b01;    
            end

            I: begin
                RegWrite        = 1;
                AluSrc          = 1'b0;
                Mem_read        = 0;
                Mem_write       = 0;
                sel_data_to_reg = 2'b01;
                Alu_op          = 2'b10;       
            end

            Load: begin
                RegWrite        = 1;
                AluSrc          = 1'b0;
                Mem_read        = 1;
                Mem_write       = 0;
                sel_data_to_reg = 2'b00; 
                Alu_op          = 2'b00;       
            end

            Store: begin
                RegWrite        = 0;
                AluSrc          = 1'b0;
                Mem_read        = 0;
                Mem_write       = 1;
                sel_data_to_reg = 2'bxx; 
                Alu_op          = 2'b00;       
            end

            B: begin
                RegWrite        = 0;
                AluSrc          = 1'bx;       
                Mem_read        = 0;
                Mem_write       = 0;
                sel_data_to_reg = 2'bxx; 
                Alu_op          = 2'b11;     
            end

            jal: begin
                RegWrite        = 1;
                AluSrc          = 1'bx;
                Mem_read        = 0;
                Mem_write       = 0;
                sel_data_to_reg = 2'b10;
                Alu_op          = 2'b11;      
            end

            jalr: begin
                RegWrite        = 1;
                AluSrc          = 1'bx;
                Mem_read        = 0;
                Mem_write       = 0;
                sel_data_to_reg = 2'b10;
                Alu_op          = 2'b11;      
            end

            Lui: begin
                RegWrite        = 1;
                AluSrc          = 1'bx;
                Mem_read        = 0;
                Mem_write       = 0;
                sel_data_to_reg = 2'b11; 
                Alu_op          = 2'b11;     
            end

            auipc: begin
                RegWrite        = 1;
                AluSrc          = 1'bx;
                Mem_read        = 0;
                Mem_write       = 0;
                sel_data_to_reg = 2'b11;
                Alu_op          = 2'b11;      
            end

            ecall_ebreak: begin
                // Tnote correct but to save mem and reg when these are called
                RegWrite        = 0;
                AluSrc          = 1'bx;
                Mem_read        = 0;
                Mem_write       = 0;
                sel_data_to_reg = 2'bxx; 
                Alu_op          = 2'b11;    
            end

            fence: begin
                RegWrite        = 0;
                AluSrc          = 1'bx;
                Mem_read        = 0;
                Mem_write       = 0;
                sel_data_to_reg = 2'bxx;
                Alu_op          = 2'b11;      
            end

        endcase
    end

endmodule

