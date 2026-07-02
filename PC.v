module PC(address_PC,jump_Number,jump,prt,rst,clk);
input [7:0] jump_Number;
input jump,prt,rst,clk;
output reg [7:0] address_PC;
always @(posedge clk) begin
        if(rst) begin
                address_PC <= 8'b0;
        end else begin
                if(prt) begin
                        address_PC <= 8'b11111111;
                end else begin
                        if(jump) begin
                                address_PC <= jump_Number;
                        end else begin
                                address_PC <= address_PC + 1'b1;
                        end
                end
        end
end
endmodule