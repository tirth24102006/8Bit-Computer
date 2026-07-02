module IR(instruction,BUS,ir_load,rst,clk);
input ir_load,rst,clk;
input [7:0] BUS;
output reg [7:0] instruction;
always @ (posedge clk) begin
        if(rst)begin
                instruction <= 8'b0;
        end else begin
                if(ir_load) begin
                        instruction <= BUS;
                end else begin
                        instruction <= instruction;
                end
        end
end
endmodule