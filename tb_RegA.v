`timescale 1ns / 1ps
module tb_RegA;
reg clk,rst,BUS_enable_A,RegA_load;
wire [7:0] BUS;
wire [7:0] out_A;
reg drive_bus;
reg [7:0] bus_value;
Reg_A A1 (out_A,BUS,RegA_load,BUS_enable_A,rst,clk);
assign BUS = drive_bus ? bus_value : 8'bz;
initial begin
        clk = 1'b0;
        BUS_enable_A = 1'b0;
        RegA_load = 1'b0;
        drive_bus = 1'b0;
        bus_value = 8'b0;
end
always #5 clk=~clk;
initial begin
$dumpfile("dump.vcd");
$dumpvars(0, tb_RegA);
$monitor("at time %t: clk=%b rst=%b RegA_load=%b BUS_enable_A=%b out_A=%b BUS=%b",$time,clk,rst,RegA_load,BUS_enable_A,out_A,BUS);
                rst = 1'b1; #10;
                rst = 1'b0; RegA_load = 1'b1; drive_bus = 1'b1; bus_value= 8'b01010011; #10;
                RegA_load = 1'b0; drive_bus = 1'b0; #10;
                BUS_enable_A = 1'b1; #10;
                #5;
        $finish;
        end
endmodule