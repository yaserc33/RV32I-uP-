`timescale 1ns / 1ps

module tb_PC_updater;

    // Parameters
    parameter mode = 32;

    // Testbench signals
    logic [mode-1:0] current_pc;
    logic [mode-1:0] rs1;
    logic [mode-1:0] rs2;
    logic [31:0] imm;
    logic [6:0] opcode;
    logic [2:0] fun3;
    logic [mode-1:0] next_pc;

    // Instantiate the DUT (Device Under Test)
    PC_updater #(mode) dut (
        .current_pc(current_pc),
        .rs1(rs1),
        .rs2(rs2),
        .imm(imm),
        .opcode(opcode),
        .fun3(fun3),
        .next_pc(next_pc)
    );

    // Test procedure
    initial begin
        $display("Starting Testbench for PC_updater\n");

        // Test Case 1: BEQ (Branch Equal, Taken)
        current_pc = 32'h00000010;
        rs1 = 32'h00000005;
        rs2 = 32'h00000005;
        imm = 32'h00000008;
        opcode = 7'b1100011; // Branch
        fun3 = 3'b000; // BEQ
        #1;
        $display("BEQ Taken: next_pc = %h", next_pc);

        // Test Case 2: BEQ (Branch Equal, Not Taken)
        rs2 = 32'h00000004; // rs1 != rs2
        #1;
        $display("BEQ Not Taken: next_pc = %h", next_pc);



        // Test Case 3: BNE (Branch Not Equal, Taken)
        fun3 = 3'b001; // BNE
        rs2 = 32'h00000004; // rs1 != rs2
        #1;
        $display("BNE Taken: next_pc = %h", next_pc);

        // Test Case 4: BLT (Branch Less Than, Taken)
        fun3 = 3'b100; // BLT
        rs1 = 32'h00000003;
        rs2 = 32'h00000005; // rs1 < rs2
        #1;
        $display("BLT Taken: next_pc = %h", next_pc);

        // Test Case 5: BLT (Branch Less Than, Not Taken)
        rs1 = 32'h00000005;
        rs2 = 32'h00000003; // rs1 >= rs2
        #1;
        $display("BLT Not Taken: next_pc = %h", next_pc);

        // Test Case 6: JAL (Jump and Link)
        opcode = 7'b1101111; // JAL
        imm = 32'h00000010;
        #1;
        $display("JAL: next_pc = %h", next_pc);

        // Test Case 7: JALR (Jump and Link Register)
        opcode = 7'b1100111; // JALR
        rs1 = 32'h00000020;
        imm = 32'h00000004;
        #1;
        $display("JALR: next_pc = %h", next_pc);

        $display("\nTestbench completed.");



        
        // Test Case 8: other opcode
        current_pc = 32'h000001111;
        opcode = 7'b0110011; // R
        fun3 = 3'b000; 
        #1;




        $finish;


    end

endmodule
