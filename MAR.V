module MAR(address_MAR,address_dip8,MAR_enable,rst,clk);
input [7:0] address_dip8;
input MAR_enable,rst,clk;
output reg [7:0] address_MAR;
always @(posedge clk) begin
        if(rst) begin
                address_MAR <= 8'b0;
        end else begin
                if(MAR_enable) begin
                        address_MAR <= address_dip8;
                end else begin
                        address_MAR <= address_MAR;
                end
        end
end
endmodule