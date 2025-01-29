module tb_data_path;

    // Parameters
    parameter mode = 32;

    // Testbench signals
    logic clk;
    logic reset_n;


    // Control signals
    logic en_pc;
    logic RegWrite;
    logic AluSrc;
    logic [3:0] AluSel;
    logic Mem_read;
    logic Mem_write;
    logic [1:0] sel_data_to_reg;

    // Instantiate the DUT (Device Under Test)
    data_path #(mode) dut (
        .clk(clk),
        .reset_n(reset_n),
        .en_pc(en_pc),
        .RegWrite(RegWrite),
        .AluSrc(AluSrc),
        .AluSel(AluSel),
        .Mem_read(Mem_read),
        .Mem_write(Mem_write),
        .sel_data_to_reg(sel_data_to_reg)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test procedure
    initial begin
        en_pc = 0;
        Mem_read = 0;
        Mem_write= 0;
        reset_n  = 0;
        AluSel   = 0; 
        AluSrc   = 0;

        sel_data_to_reg =0;
        RegWrite = 0;



// Test Case 1: Simple ADD instruction       addi	x1,x0,10  ::  0x00A0093
        #5 reset_n = 1;
        RegWrite= 1'b1;
        AluSrc = 1'b1;
        AluSel = 0; 
        sel_data_to_reg = 1;


// igonore
        #10 en_pc  = 1;



// Test Case 2: load upeer immediate   lui x5 , 0xabcde   :: 	0xABCDE2B7
        sel_data_to_reg = 3;
        RegWrite= 1'b1;
        #10;

// Test Case 3: r type        or x20 x1 x5   :: 	0x0050EA33
        sel_data_to_reg = 1;
        RegWrite= 1;
        AluSrc = 0;
        AluSel = 3; 
        #10

        // Test Case 4: s type       sw x20 0(x1)  :: 		0x0140A023
        RegWrite=1;
        Mem_write=1;
        AluSrc = 1'b1;
        AluSel = 0; 
        #10;





               $finish;



    end

endmodule
