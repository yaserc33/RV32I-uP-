
module imm_gen (
    input [ 31 : 0]instruction,
    output[ 31 : 0]imm
);


// opcode for each type

typedef enum logic [6:0] {
   R       =  7'b0110011 ,
   I       =  7'b0010011 ,    
   L       =  7'b0000011,     //for load instructions 
   L_JALR  =  7'b1100111 , 
   S       =  7'b0100011,
   U_AUIPC =  7'b0010111,
   U_LUI   =  7'b0110111 ,
   B       =  7'b1100011,
   J       =  7'b1101111

} opcode_type;


opcode_type op;
assign  op = opcode_type'(instruction[7:0]);// type cast


// assign output_signal = (condition1) ? value1 :
//                        (condition2) ? value2 :
//                        (condition3) ? value3 :
//                        default_value;




assign imm[0] = (op == L || op == L_JALR || op == I) ? instruction[20] :
                (op == S) ? instruction[7] :
                0;


assign imm[4:1] = (op == L || op == L_JALR  || op == I|| op == J) ? instruction[24:21] :
                  (op == S || op == B ) ? instruction[11:8] :
                   0;

assign imm[10:5] = (op == L || op == L_JALR  || op == I|| op == J || op == S || op == B ) ? instruction[30:25] :
                   0;

assign imm[31] = instruction[31];

assign imm[19:12] = (op == U_AUIPC || op == U_LUI || op == J) ? instruction[19:12] : {8{instruction[31]}};

assign imm[30:21] = (op == U_AUIPC || op == U_LUI) ? instruction[30:21] : {10{instruction[31]}};


assign imm[20] = (op ==U_LUI  || op== U_AUIPC   ) ? instruction[20] :  instruction[31];

assign imm[11] =    (op == B )  ? instruction[7] :
                    (op == J )  ? instruction[20] :
                    (op ==U_LUI  || op == U_AUIPC )   ? 0 : instruction[31];

    
    



endmodule





// always_comb begin

//             case(op) 

//             R :  imm  = 0 ;

//             I :  imm =   { {19{instruction[31]}}, instruction[31:20]} ;

//             L , L_JALR : {}; 

//             S : 
//             U_AUIPC , U_LUI :

//             B :

//             J : 



//             default: /*nothing*/; 
//             endcase  

//  end  
