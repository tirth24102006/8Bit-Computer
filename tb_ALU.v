`timescale 1ns / 1ps
module tb_ALU;
reg [7:0]a,b;
reg [2:0] opc;
reg rst,clk,A_load,B_load;
wire [7:0]out;
wire c_flag;
ALU_8Bit A1(out,c_flag,a,b,opc,A_load,B_load,rst,clk);
initial begin
        clk = 1'b0;
        A_load = 1'b0;
        B_load = 1'b0;
        opc = 3'b000;
        a = 8'b00000000;
        b = 8'b00000000;
end
always #5 clk=~clk;
initial begin
$dumpfile("dump.vcd");
$dumpvars(0, tb_ALU);
$monitor("at time %t: clk=%b rst=%b A_load=%b B_load=%b a=%b b=%b opc=%b | out=%b c_flag=%b",$time,clk,rst,A_load,B_load,a,b,opc,out,c_flag);
                rst = 0; A_load = 1'b1; a = 8'b11111111; #10;
                rst = 0; A_load = 1'b0; B_load = 1'b1; b = 8'b00000001; #10;
                rst = 0; A_load = 1'b1; B_load = 1'b1; a = 8'b10000001; b = 8'b10000001; #10;
                rst = 0; A_load = 1'b0; B_load = 1'b0; opc = 3'b000; #10;
                rst = 1; #10;
                #5;
        $finish;
        end
endmodule