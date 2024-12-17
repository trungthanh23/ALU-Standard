module ALU_standard_calculator_n_bit #(parameter n = 4)(
    input clk,
    input rst,
    input [2:0] op,
    input signed [n-1:0] a,
    input signed [n-1:0] b,
    output reg signed [2*n-1:0] result,
    output reg valid_result
);

    // Các tín hiệu enable và valid cho từng module con
    reg enable_add, enable_sub, enable_mul, enable_div;
    wire valid_add, valid_sub, valid_mul, valid_div;

    wire signed [n:0] result_add;
    wire signed [n:0] result_sub;
    wire signed [2*n-1:0] result_mul;
    wire signed [n:0] result_div;
    wire signed [n-1:0] remainder;


    // Logic điều khiển enable cho các module con
    always @(*) begin
        // Khởi tạo tất cả các enable về 0
        enable_add = 1'b0;
        enable_sub = 1'b0;
        enable_mul = 1'b0;
        enable_div = 1'b0;
        valid_result = 1'b0;

        // Kích hoạt module tương ứng dựa trên op
        case (op)
            3'b000: enable_add = 1'b1;
            3'b001: enable_sub = 1'b1;
            3'b010: enable_mul = 1'b1;
            3'b011: enable_div = 1'b1;
            3'b100: begin result = a & b; valid_result = 1'b1; end
            3'b101: begin result = a | b; valid_result = 1'b1; end
            3'b110: begin result = a ^ b; valid_result = 1'b1; end
            3'b111: begin result = ~a; valid_result = 1'b1; end
            default: begin result = 0; valid_result = 1'b1; end
        endcase
    end

    // Module cộng
    add_n_bit_signed #(n) add(
        .a(a),
        .b(b),
        .enable(enable_add),
        .valid(valid_add),
        .result(result_add)
    );

    // Module trừ
    sub_n_bit_signed #(n) sub(
        .a(a),
        .b(b),
        .enable(enable_sub),
        .valid(valid_sub),
        .result(result_sub)
    );

    // Module nhân
    multiplier_n_bit_signed #(n) mul(
        .a(a),
        .b(b),
        .clk(clk),
        .rst(rst),
        .enable(enable_mul),
        .valid(valid_mul),
        .result(result_mul)
    );

    // Module chia
    divide_n_bit_signed #(n) div(
        .f_num(a),
        .s_num(b),
        .clk(clk),
        .rst(rst),
        .enable(enable_div),
        .valid(valid_div),
        .result(result_div),
        .remainder(remainder)
    );

    // Logic xử lý kết quả từ các module con
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 0;
            valid_result <= 1'b0;
        end else begin
            case (op)
                3'b000: if (valid_add) begin result <= result_add; valid_result <= 1'b1; end
                3'b001: if (valid_sub) begin result <= result_sub; valid_result <= 1'b1; end
                3'b010: if (valid_mul) begin result <= result_mul; valid_result <= 1'b1; end
                3'b011: if (valid_div) begin result <= result_div; valid_result <= 1'b1; end
                3'b100: begin result <= a & b; valid_result <= 1'b1; end
                3'b101: begin result <= a | b; valid_result <= 1'b1; end
                3'b110: begin result <= a ^ b; valid_result <= 1'b1; end
                3'b111: begin result <= ~a; valid_result <= 1'b1; end
                default: begin result <= 0; valid_result <= 1'b1; end
            endcase
        end
    end

endmodule