module divide_n_bit_signed#(parameter n = 4)(
    input signed [n - 1:0] f_num,
    input signed [n - 1:0] s_num,
    input clk,
    input rst,
    output reg signed [n : 0]  result,
    output reg signed [n - 1: 0] remainder
);
    reg [n  : 0] f_num1;
    reg [n  : 0] s_num1; 
    reg [n - 1 : 0] pre_result;
    reg [n  : 0] pre_remainder;
    reg [2:0] count;    
    always@(posedge clk or posedge rst)begin
        if (rst) begin 
            f_num1 <= 0;
            s_num1 <= 0;
            result <= 0;
            remainder <= 0;
            pre_result <= 0;
            pre_remainder <= 0;
            count <= 0;
        end
        else if ( count == 0 ) begin
            s_num1 <= (s_num[n-1] == 1) ? {1'b0, -s_num} : {1'b0, s_num};
            f_num1 <= (f_num[n-1] == 1) ? {1'b0, -f_num} : {1'b0, f_num};
            pre_result <= 0;
            pre_remainder <= 0;
            count <= 5;
        end
        else begin 
           // pre_result <= pre_result << 1;
           if (s_num == 0) begin
                count <= 1;
           end 
           else if ({pre_remainder[n - 2 : 0]  , f_num1 [n-1]} >= s_num1) begin
                pre_remainder  <= {pre_remainder[n - 2 : 0]  , f_num1 [n-1]} - s_num1;
                pre_result <= {pre_result [n - 2 : 0], 1'b1}; 
                f_num1 <= f_num1 << 1;
            end 
            else begin
                pre_remainder <= {pre_remainder[n - 2 : 0]  , f_num1 [n-1]};
                f_num1 <= f_num1 << 1;
                pre_result <= {pre_result [n - 2 : 0], 1'b0};
            end 
            count <= count - 1; 
            if (count == 1) begin
                result <= (f_num[n-1] ^ s_num[n-1]) ? -pre_result   : pre_result;
                remainder <=   (f_num[n-1]) ? -pre_remainder[n-1:0] : pre_remainder[n - 1: 0];
            end
            else begin end
        end
end
endmodule
