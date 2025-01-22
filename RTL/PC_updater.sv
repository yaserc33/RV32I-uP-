module PC_updater #(parameter mode = 32)(

    input logic [mode-1:0] current_pc,
    input logic [mode-1:0] rs1,
    input logic [mode-1:0] rs2,
    input logic [31:0] imm,
    input logic [6:0] opcode,
    input logic [2:0] fun3,
    output logic [mode-1:0] next_pc
);
    logic [mode-1:0] next_pc;
    
    always_comb begin    
        case (opcode)
            7'b1100011: // Branch instructions
                if (fun3 == 3'b000) begin // BEQ
                    next_pc = (rs1 == rs2) ? (current_pc + imm) : (current_pc + 4);
                end else if (fun3 == 3'b001) begin // BNE
                    next_pc = (rs1 != rs2) ? (current_pc + imm) : (current_pc + 4);
                end else if (fun3 == 3'b100) begin // BLT
                    next_pc = (rs1 < rs2) ? (current_pc + imm) : (current_pc + 4);
                end else if (fun3 == 3'b101) begin // BGE
                    next_pc = (rs1 >= rs2) ? (current_pc + imm) : (current_pc + 4);
                end else if (fun3 == 3'b110) begin // BLTU
                    next_pc = ($unsigned(rs1) < $unsigned(rs2)) ? (current_pc + imm) : (current_pc + 4);
                end else if (fun3 == 3'b111) begin // BGEU
                    next_pc = ($unsigned(rs1) >= $unsigned(rs2)) ? (current_pc + imm) : (current_pc + 4);
                end else begin
                    next_pc = current_pc + 4; // Default for unexpected `fun3`
                end

            7'b1101111: begin // JAL
                next_pc = current_pc + imm;
            end

            7'b1100111: begin // JALR
                next_pc = rs1 + imm;
            end

            default: begin
                next_pc = current_pc + 4; // Default for other opcodes
            end
        endcase

        
    end







endmodule
