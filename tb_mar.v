`timescale 1ns / 1ps
module tb_mar;
reg clk,rst,MAR_enable;
reg [7:0] address;
wire[7:0] address_MAR;
MAR A1(address_MAR,address,MAR_enable,rst,clk);
initial begin
        clk = 1'b0;
        MAR_enable = 1'b0;
end
always #5 clk=~clk;
initial begin
$dumpfile("dump.vcd");
$dumpvars(0, tb_mar);
$monitor("at time %t: clk=%b rst=%b MAR_enable=%b address=%b | address_MAR=%b",$time,clk,rst,MAR_enable,address,address_MAR);
                rst = 1'b1; #10;
                rst = 1'b0; MAR_enable = 1'b1; address = 8'b01010011; #10;
                MAR_enable = 1'b0; #10;
                rst = 1'b1; #10;
                #5;
        $finish;
end
endmodule