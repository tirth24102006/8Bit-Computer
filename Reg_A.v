module Reg_A(out_A,BUS,RegA_load,BUS_enable_A,rst,clk);
input clk,rst,RegA_load,BUS_enable_A;
inout [7:0] BUS;
output reg [7:0] out_A;
always @(posedge clk) begin
        if(rst)begin
                out_A <= 8'b0;
        end else begin
                if(RegA_load) begin
                        out_A <= BUS;
                end else begin
                        out_A <= out_A;
                end
        end
end
assign BUS = BUS_enable_A ? out_A : 8'bz;
endmodule