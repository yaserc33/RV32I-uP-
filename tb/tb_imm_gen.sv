module tb_imm_gen;
    // Parameters
    parameter mode = 32;

    // Inputs
    reg [mode-1:0] instruction;

    // Outputs
    wire [mode-1:0] imm;

    // Instantiate the imm_gen module
    imm_gen #(mode) uut (
        .instruction(instruction),
        .imm(imm)
    );



    initial begin



        instruction = 32'h002081B3 ;	//add x3 x1 x2
        #10;


        instruction = 32'h00508113;	//addi x2 x1 5
        #10;


        instruction = 32'h02812183;	//lw x3 40(x2)
        #10;


        instruction = 32'h02D08167;	//jalr x2 x1 45
        #10;


        instruction = 32'h0220ABA3;	//sw x2 55(x1)
        #10;

        instruction = 32'h51000137;	//lui x2 510000
        #10;

        instruction = 32'h52000117;	 //auipc x2 520000
        #10;

        instruction = 	32'h02208E63;	// beq x1 x2 60
        #10;

         instruction = 	32'hF9DFF16F;	// jal x2 -100
        #10;

        $finish;
    end
endmodule



























