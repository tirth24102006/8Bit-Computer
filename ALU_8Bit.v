module ALU_8Bit(out,c_flag,A,B,opcode,A_load,B_load,rst,clk);
input [7:0] A,B;
input [2:0] opcode;
input rst,clk,A_load,B_load;
output reg [7:0] out;
output reg c_flag;
reg [7:0] w1,w2;
initial begin
        w1 <= 8'b0;
        w2 <= 8'b0;
        out <= 8'b0;
        c_flag <= 1'b0;
end
always @(posedge clk) begin
        if (rst) begin
                out <= 8'b0;
                c_flag <= 1'b0;
                w1 <= 8'b0;
                w2 <= 8'b0;
        end
        else begin
                if(A_load && B_load) begin
                        w1 <= A;
                        w2 <= B;
                end
                else if(A_load) begin
                        w1 <= A;
                end
                else if(B_load) begin
                        w2 <= B;
                end
                else begin
                        case(opcode)
                                3'b000: {c_flag,out} <= {1'b0,w1} + {1'b0,w2};
                                3'b001: {c_flag,out} <= {1'b0,w1} - {1'b0,w2};
                                3'b010: {c_flag,out} <= {1'b0,w1 & w2};
                                3'b011: {c_flag,out} <= {1'b0,w1 | w2};
                                3'b100: {c_flag,out} <= {1'b0,w1 ^ w2};
                                3'b101: {c_flag,out} <= {1'b0,~w1};
                                3'b110: {c_flag,out} <= {w1,1'b0};
                                3'b111: {out,c_flag} <= {1'b0,w1};
                                default : {c_flag,out} <= 9'b0;
                        endcase
                end
        end
end
endmodule