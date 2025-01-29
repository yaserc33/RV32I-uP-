module tb_ins_mem;
    

    logic [31:0] addr;
    logic [31:0] inst;

    inst_mem  uut (
    
        .addr(addr),
        .inst(inst)   
         );



    initial begin


        #10 addr = 0;

        #10 addr = 4;

        #10 addr = 8;



        #20 $stop;
    end
endmodule