`timescale 1ns / 1ps
module tb_RegB;
reg clk,rst,BUS_enable_B,RegB_load;
wire [7:0] BUS;
wire [7:0] out_B;
reg drive_bus;
reg [7:0] bus_value;
Reg_B A1 (out_B,BUS,RegB_load,BUS_enable_B,rst,clk);
assign BUS = drive_bus ? bus_value : 8'bz;
initial begin
        clk = 1'b0;
        BUS_enable_B = 1'b0;
        RegB_load = 1'b0;
        drive_bus = 1'b0;
        bus_value = 8'b0;
end
always #5 clk=~clk;
initial begin
$dumpfile("dump.vcd");
$dumpvars(0, tb_RegB);
$monitor("at time %t: clk=%b rst=%b RegB_load=%b BUS_enable_B=%b out_B=%b BUS=%b",$time,clk,rst,RegB_load,BUS_enable_B,out_B,BUS);
                rst = 1'b1; #10;
                rst = 1'b0; RegB_load = 1'b1; drive_bus = 1'b1; bus_value= 8'b01010011; #10;
                RegB_load = 1'b0; drive_bus = 1'b0; #10;
                BUS_enable_B = 1'b1; #10;
                #5;
        $finish;
        end
endmodule