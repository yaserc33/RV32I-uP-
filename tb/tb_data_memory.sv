module tb_data_memory;

  
    // Parameters
    parameter size = 1024;

    // Signals
    logic clk;
    logic reset_n;
    logic mem_write, mem_read;
    logic [31:0] addr;
    logic [2:0] fun3;
    logic [6:0] opcode;
    logic [31:0] data_in;
    logic [31:0] data_out;

    // DUT instance
    data_memory #(.size(size)) dut (
        .clk(clk),
        .reset_n(reset_n),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .addr(addr),
        .fun3(fun3),
        .opcode(opcode),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Tasks for write and read operations
    task write_data(input [31:0] address, input [31:0] data, input [6:0] op , input [2:0] sel );
        begin
            addr = address;
            data_in = data;
            fun3 = sel;
            opcode = op;
            mem_write = 1;
            mem_read = 0;
            #10; // Wait for one clock cycle
            mem_write = 0;
        end
    endtask

    task read_data(input [31:0] address, input [6:0] op , input [2:0] sel );
        begin
            addr = address;
            fun3 = sel;
            opcode = op;
            mem_read = 1;
            mem_write = 0;
            #10; // Wait for one clock cycle
            mem_read = 0;
        end
    endtask

    // Testbench procedure
    initial begin
        // Initialize signals
        clk = 0;
        reset_n = 0;
        mem_write = 0;
        mem_read = 0;
        addr = 0;
        fun3 = 0;
        opcode=0;
        data_in = 0;

        // Reset the DUT
        #10 reset_n = 1;

        // Test SW (Store Word)
        write_data(10, 32'hAABBCCDD, 7'b0100011, 3'b010);
    //     write_data(32'h00000004, 32'h11223344, 7'b0100011, 3'b010);

    //     // Test SH (Store Halfword)
    //     write_data(32'h00000000, 32'h00001234, 7'b0100011, 3'b001);
    //     write_data(32'h00000002, 32'h00005678, 7'b0100011, 3'b001);

    //     // Test SB (Store Byte)
    //     write_data(32'h00000000, 32'h000000AA, 7'b0100011, 3'b000);
    //     write_data(32'h00000001, 32'h000000BB, 7'b0100011, 3'b000);

    //     // Test LW (Load Word)
    //     read_data(32'h00000000, 7'b0000011, 3'b010);
    //     #10 ;
        
    //        // Test LW (Load Word)
    //     read_data(32'h00000004, 7'b0000011, 3'b010);
    //     #10 ;


    //     // Test LH (Load Halfword)
    //     read_data(32'h00000000, 7'b0000011, 3'b001);
    //     #10;

    //     // Test LHU (Load Halfword Unsigned)
    //     read_data(32'h00000002, 7'b0000011, 3'b101);
    //     #10 ;

    //     // Test LB (Load Byte)
    //     read_data(32'h00000000, 7'b0000011, 3'b000);
    //     #10 ;

    //     // Test LBU (Load Byte Unsigned)
    //     read_data(32'h00000001, 7'b0000011, 3'b100);
    //     #10 ;




    // //test resert
    //   // Reset the DUT
    //     #10 reset_n = 0;
    //     #10 reset_n = 1;
        
    //     // Test LW (Load Word)
    //     read_data(32'h00000000, 7'b0000011, 3'b010);
    //     #10 ;
        
    //        // Test LW (Load Word)
    //     read_data(32'h00000004, 7'b0000011, 3'b010);
    //     #10 ;


    //     // Test LH (Load Halfword)
    //     read_data(32'h00000000, 7'b0000011, 3'b001);
    //     #10;

    //     // Test LHU (Load Halfword Unsigned)
    //     read_data(32'h00000002, 7'b0000011, 3'b101);
    //     #10 ;

    //     // Test LB (Load Byte)
    //     read_data(32'h00000000, 7'b0000011, 3'b000);
    //     #10 ;

    //     // Test LBU (Load Byte Unsigned)
    //     read_data(32'h00000001, 7'b0000011, 3'b100);
    //     #10 ;





        // End simulation
        $finish;
    end

endmodule
