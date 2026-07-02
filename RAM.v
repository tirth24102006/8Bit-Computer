module RAM(address_MAR,address_pc,address_sel,address,Number,BUS,Load_Number,WR,rst,clk);
input [7:0] address_MAR,address_pc,Number,address;
input address_sel,Load_Number,WR,rst,clk;
inout [7:0] BUS;
reg [7:0] RAM [0:255];
integer i;
always @(posedge clk) begin
        if(rst) begin
                for(i=0;i<256;i=i+1) begin
                        RAM[i] <= 8'b0;
                end
        end else begin
                if(WR) begin
                        if(address_sel) begin
                                if(Load_Number) begin
                                        RAM[address_pc] <= BUS;
                                end else begin
                                        RAM[address_pc] <= Number;
                                end
                        end else begin
                                if(Load_Number) begin
                                        RAM[address_MAR] <= BUS;
                                end else begin
                                        RAM[address_MAR] <= Number;
                                end
                        end
                end
        end
end
assign BUS = WR ? 8'bz : RAM[address];
endmodule