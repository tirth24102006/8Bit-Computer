module output_Reg(BUS,carry_flag,OUT,CF,OUT_load,OUT_enable,rst,clk);
input [7:0] OUT;
input CF,rst,clk,OUT_load,OUT_enable;
output [7:0] BUS;
output carry_flag;
reg carry;
reg [7:0] answer;
always @(posedge clk) begin
        if(rst) begin
                answer <= 8'b0;
                carry <= 1'b0;
        end
        else begin
                if(OUT_load) begin
                        answer <= OUT;  
                        carry <= CF;
                end else begin
                        answer <= answer;
                        carry <= carry;
                end
        end
end
assign BUS = OUT_enable ? answer : 8'bz;
assign carry_flag = OUT_enable ? carry : 1'bz;
endmodule