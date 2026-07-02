module Reg_B(out_B,BUS,RegB_load,BUS_enable_B,rst,clk);
input clk,rst,RegB_load,BUS_enable_B;
inout [7:0] BUS;
output reg [7:0] out_B;
always @(posedge clk) begin
        if(rst)begin
                out_B <= 8'b0;
        end else begin
                if(RegB_load) begin
                        out_B <= BUS;
                end else begin
                        out_B <= out_B;
                end
        end
end
assign BUS = BUS_enable_B ? out_B : 8'bz;
endmodule