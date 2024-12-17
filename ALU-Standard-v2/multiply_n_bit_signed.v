module multiplier_n_bit_signed #(parameter n = 4)(
    input signed [n-1:0] a,    
    input signed [n-1:0] b,     
    input clk,                  
    input rst,
    input enable,               // Tín hiệu điều khiển thực thi phép tính   
    output reg valid,            // Báo hiệu kết quả đã sẵn sàng
    output reg signed [2*n-1:0] result 
);
    reg signed [n:0] b_temp;      
    reg signed [2*n-1:0] A;  
    reg signed [2*n-1:0] a_temp;    
    reg internal_done;            
    integer i;                     

    always @(posedge clk or posedge rst) begin
        if (rst) begin  
            // Các giá trị ban đầu khi reset
            a_temp <= 0;
            b_temp <= 0;
            A <= 0;
            result <= 0;
            i <= 0;
            internal_done <= 1'b0;
            valid <= 1'b0;
        end 
        else if (enable) begin  // Chỉ thực hiện khi enable được kích hoạt
            if (i == 0) begin
                // Khởi tạo các giá trị ban đầu cho phép nhân
                a_temp <= {{n{a[n-1]}}, a};  // Mở rộng bit dấu
                b_temp <= {b, 1'b0}; 
                A <= 0;
                i <= 1;
                valid <= 1'b0;
                internal_done <= 1'b0;
            end 
            else if (i < n) begin
                // Thực hiện phép nhân Booth
                case ({b_temp[i+1], b_temp[i], b_temp[i-1]})
                    3'b001, 3'b010: A <= A + a_temp;
                    3'b011: A <= A + (a_temp << 1);
                    3'b100: A <= A - (a_temp << 1);
                    3'b101, 3'b110: A <= A - a_temp;
                    default: ;  
                endcase
                a_temp <= a_temp << 2;
                i <= i + 2;
            end 
            else begin
                // Kết thúc phép nhân
                result <= A;   
                i <= 0;
                valid <= 1'b1;
                internal_done <= 1'b1;
            end
        end
        else begin
            // Trạng thái không active
            valid <= 1'b0;
            internal_done <= 1'b0;
        end
    end
endmodule









