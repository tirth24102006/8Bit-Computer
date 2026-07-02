`timescale 1ns / 1ps
module tb_Ram;
reg clk,rst,address_sel,wr,load_number;
reg [7:0] address_mar,address_pc,number,address;
wire[7:0] bus;
reg drive_bus;
reg [7:0] bus_value;
RAM A1(address_mar,address_pc,address_sel,address,number,bus,load_number,wr,rst,clk);
assign bus = drive_bus ? bus_value : 8'bz;
initial begin
        clk = 1'b0;
        wr = 1'b1;
        address_sel = 1'b0;
        load_number = 1'b0;
        drive_bus = 1'b0;
        bus_value = 8'b0;
        address = 8'b0;
end
always #5 clk=~clk;
initial begin
$dumpfile("dump.vcd");
$dumpvars(0, tb_Ram);
$monitor("at time %t: clk=%b rst=%b address_sel=%b wr=%b load_number=%b address_mar=%b address_pc=%b address=%b number=%b | bus=%b",$time,clk,rst,address_sel,wr,load_number,address_mar,address_pc,address,number,bus);
                //rst = 1'b1; #10;//zzzzzzzz
                rst = 1'b0; address_mar = 8'b00000100 ;number = 8'b01010011; #10;//zzzzzzzz
                load_number = 1'b1; address_mar = 8'b00000101; drive_bus = 1'b1; bus_value = 8'b11010011 ; #10;//11010011
                address_sel = 1'b1; address_pc = 8'b00001000 ; bus_value = 8'b11110011; #10;//11110011
                load_number = 1'b0; drive_bus = 1'b0 ;address_pc = 8'b00001001; number = 8'b11111011 ; #10;//zzzzzzzz
                wr = 1'b0; address_sel = 1'b0 ; address = 8'b00000100 ; #10;//01010011
                wr = 1'b0; address = 8'b00001000 ; #10;//11110011
                wr = 1'b0; address = address_mar ; #10;//11010011
                wr = 1'b0; address = address_pc ; #10;//11111011
                wr = 1'b0; address = 10000000 ; #10;//xxxxxxxx
                rst = 1'b1; wr = 1'b1; #10;//zzzzzzzz
                wr = 1'b0; address = 8'b00000100 ;#10;//00000000
                #5;
        $finish;
end
endmodule