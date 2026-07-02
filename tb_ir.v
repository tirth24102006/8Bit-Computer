`timescale 1ns / 1ps
module tb_ir;
reg rst,clk,it_load;
reg [7:0] BUS;
wire [7:0] instruction;
IR A1(instruction,BUS,it_load,rst,clk);
initial begin
        clk = 1'b0;
        it_load = 1'b0;
end
always #5 clk=~clk;
initial begin
$dumpfile("dump.vcd");
$dumpvars(0, tb_ir);
$monitor("at time %t: clk=%b rst=%b it_load=%b BUS=%b instruction=%b",$time,clk,rst,it_load,BUS,instruction);
                rst = 1'b1; #10;
                rst = 1'b0; it_load = 1'b1; BUS = 8'b01010011; #10;
                it_load = 1'b0; #10;
                rst = 1'b1; #10;
                #5;
        $finish;
end
endmodule