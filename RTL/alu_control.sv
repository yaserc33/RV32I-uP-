module alu_control_unit (
    input  logic [1:0] aluop,
    input  logic [2:0] fun3,
    input  logic       fun7,  // instruction bit [30]
    output logic [3:0] mode
);

     alu_op_t mode; // enum type defined in alu module

    always_comb begin
        case (aluop)
            2'b00: mode = ADD;// loads/stores ,  always ADD
            

            2'b01: begin
                // R-type
                case (fun3)
                    3'b000: mode = (fun7) ? SUB : ADD; 
                    3'b111: mode = AND;
                    3'b110: mode = OR;
                    3'b100: mode = XOR;
                    3'b001: mode = SLL;
                    3'b101: mode = (fun7) ? SRA : SRL;
                    3'b010: mode = SLT;
                    3'b011: mode = SLTU;
                    default: mode = ADD;
                endcase
            end

            2'b10: begin
                case (fun3)
                    3'b000: mode = ADD;    
                    3'b111: mode = AND;    
                    3'b110: mode = OR;    
                    3'b100: mode = XOR;    
                    3'b001: mode = SLL;    
                    3'b101: mode = (fun7) ? SRA : SRL; 
                    3'b010: mode = SLT;  
                    3'b011: mode = SLTU;  
                    default: mode = ADD;
                endcase
            end

            default: mode = ADD;
        endcase
    end

endmodule
