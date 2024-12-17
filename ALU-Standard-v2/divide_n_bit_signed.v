module divide_n_bit_signed #(parameter n = 4)(
    input signed [n - 1:0] f_num,   // Số bị chia
    input signed [n - 1:0] s_num,   // Số chia
    input clk,
    input rst,
    input enable,               // Tín hiệu điều khiển thực thi phép tính
    output reg valid,            // Báo hiệu kết quả đã sẵn sàng
    output reg signed [n : 0]  result,
    output reg signed [n - 1: 0] remainder
);
    reg [n  : 0] f_num1;
    reg [n  : 0] s_num1; 
    reg [n - 1 : 0] pre_result;
    reg [n  : 0] pre_remainder;
    reg [2:0] count;    

    always @(posedge clk or posedge rst) begin
        if (rst) begin 
            // Các giá trị ban đầu khi reset
            f_num1 <= 0;
            s_num1 <= 0;
            result <= 0;
            remainder <= 0;
            pre_result <= 0;
            pre_remainder <= 0;
            count <= 0;
            valid <= 1'b0;
        end
        else if (enable) begin
            // Chỉ thực hiện khi enable được kích hoạt
            if (count == 0) begin
                // Xử lý các số âm
                s_num1 <= (s_num[n-1] == 1) ? {1'b0, -s_num} : {1'b0, s_num};
                f_num1 <= (f_num[n-1] == 1) ? {1'b0, -f_num} : {1'b0, f_num};
                pre_result <= 0;
                pre_remainder <= 0;
                count <= 5;  // Số bit để thực hiện chia
                valid <= 1'b0;
            end
            else begin 
                // Kiểm tra chia cho 0
                if (s_num == 0) begin
                    count <= 1;
                    valid <= 1'b0;
                end 
                else begin
                    // Thuật toán chia
                    if ({pre_remainder[n - 2 : 0], f_num1[n-1]} >= s_num1) begin
                        pre_remainder <= {pre_remainder[n - 2 : 0], f_num1[n-1]} - s_num1;
                        pre_result <= {pre_result[n - 2 : 0], 1'b1}; 
                    end 
                    else begin
                        pre_remainder <= {pre_remainder[n - 2 : 0], f_num1[n-1]};
                        pre_result <= {pre_result[n - 2 : 0], 1'b0};
                    end 
                    
                    f_num1 <= f_num1 << 1;
                    count <= count - 1; 
                    
                    // Kết thúc phép chia
                    if (count == 1) begin
                        // Xác định dấu kết quả
                        result <= (f_num[n-1] ^ s_num[n-1]) ? -pre_result : pre_result;
                        remainder <= (f_num[n-1]) ? -pre_remainder[n-1:0] : pre_remainder[n-1:0];
                        valid <= 1'b1;
                    end
                end
            end
        end
        else begin
            // Trạng thái không active
            valid <= 1'b0;
        end
    end
endmodule
