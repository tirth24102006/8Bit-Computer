`timescale 1ns / 1ps
module tb_outputReg;
reg cf,out_load,out_enable,rst,clk;
reg [7:0] out;
wire [7:0] bus;
wire Cf;
output_Reg A1(bus,Cf,out,cf,out_load,out_enable,rst,clk);
initial begin
        clk = 1'b0;
        out_load = 1'b0;
        out_enable = 1'b0;
end
always #5 clk=~clk;
initial begin
$dumpfile("dump.vcd");
$dumpvars(0, tb_outputReg);
$monitor("at time %t: clk=%b rst=%b out_load=%b out_enable=%b out=%b cf=%b bus=%b Cf=%b",$time,clk,rst,out_load,out_enable,out,cf,bus,Cf);
                rst = 1'b1; out_load = 1'b0; out_enable = 1'b0; out = 8'b00000000; cf = 1'b0; #10;
                rst = 1'b0; out_load = 1'b1; out_enable = 1'b0; out = 8'b00000001; cf = 1'b0; #10;
                rst = 1'b0; out_load = 1'b0; out_enable = 1'b1; out = 8'b00000001; cf = 1'b0; #10;
                rst = 1'b0; out_load = 1'b0; out_enable = 1'b0; out = 8'b00000001; cf = 1'b0; #10;
                rst = 1'b0; out_load = 1'b1; out_enable = 1'b0; out = 8'b11111111; cf = 1'b1; #10;
                rst = 1'b0; out_load = 1'b0; out_enable = 1'b1; out = 8'b11111111; cf = 1'b1; #10;
                rst = 1'b0; out_load = 1'b0; out_enable = 1'b0; out = 8'b11111111; cf = 1'b1; #10;
                #5;
        $finish;
        end
endmodule