`timescale 1ns / 1ps
module tb_pc;
reg rst,prt,clk,jump;
reg [7:0] jump_Number;
wire [7:0] address_PC;
PC A1(address_PC,jump_Number,jump,prt,rst,clk);
initial begin
        clk = 1'b0;
        prt = 1'b0;
        jump = 1'b0;
        jump_Number = 8'b0;
end
always #5 clk=~clk;
initial begin
$dumpfile("dump.vcd");
$dumpvars(0, tb_pc);
$monitor("at time %t: clk=%b rst=%b prt=%b jump=%b jump_Number=%b | address_PC=%b",$time,clk,rst,prt,jump,jump_Number,address_PC);
                rst = 1'b1; #10;
                rst = 1'b0; prt = 1'b1; #10;
                prt = 1'b0; jump = 1'b1; jump_Number = 8'b00000101; #10;
                jump = 1'b0; #10;
                rst = 1'b1; #10;
                rst = 1'b0; #2560;
                #5;
        $finish;
end
endmodule