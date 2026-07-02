module CPU(BUS,carry_flag,instruction,opcode,address_dip8,address,number,jump_number,A_load,B_load,RegA_load,RegB_load,Bus_enable_A,Bus_enable_B,out_load,out_enable,Mar_enable,load_number,address_sel,ir_load,wr,jump,prt,rst,clk);
input [2:0] opcode;
input [7:0] address_dip8,address,number,jump_number;
input A_load,B_load,RegA_load,RegB_load,Bus_enable_A,Bus_enable_B,out_load,out_enable,Mar_enable,load_number,address_sel,ir_load,wr,jump,prt,rst,clk;
inout [7:0] BUS;
output carry_flag;
output [7:0]instruction;
wire [7:0] out_A,out_B,address_MAR,address_PC,OUT;
wire CF;
PC A1(address_PC,jump_number,jump,prt,rst,clk);
MAR A2(address_MAR,address_dip8,Mar_enable,rst,clk);
RAM A3(address_MAR,address_PC,address_sel,address,number,BUS,load_number,wr,rst,clk);
IR A4(instruction,BUS,ir_load,rst,clk);
Reg_A A5(out_A,BUS,RegA_load,Bus_enable_A,rst,clk);
Reg_B A6(out_B,BUS,RegB_load,Bus_enable_B,rst,clk);
ALU_8Bit A7(OUT,CF,out_A,out_B,opcode,A_load,B_load,rst,clk);
output_Reg A8(BUS,carry_flag,OUT,CF,out_load,out_enable,rst,clk);
endmodule