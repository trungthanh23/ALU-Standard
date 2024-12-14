module ALU_standard_caculator_n_bit#(parameter n = 4)(
    input clk,
    input rst,
    input [2:0] op,
    input signed [n-1:0] a,
    input signed [n-1:0] b,
    output reg signed [2*n-1:0] result
);

    wire signed [n:0] result_add;
    wire signed [n:0] result_sub;
    wire signed [2*n-1:0] result_mul;
    wire signed [n:0] result_div;
    wire signed [n-1:0] remainder;

    add_n_bit_signed #(n) add(
        .a(a),
        .b(b),
        .result(result_add)
    );

    sub_n_bit_signed #(n) sub(
        .a(a),
        .b(b),
        .result(result_sub)
    );

    multiplier_n_bit_signed#(n) mul(
        .a(a),
        .b(b),
        .clk(clk),
        .rst(rst),
        .result(result_mul)
    );

    divide_n_bit_signed#(n) div(
        .f_num(a),
        .s_num(b),
        .clk(clk),
        .rst(rst),
        .result(result_div),
        .remainder(remainder)
    );

    always @(*) begin
        case (op)
            3'b000: result = result_add;
            3'b001: result = result_sub;
            3'b010: result = result_mul;
            3'b011: result = result_div;
            3'b100: result = a & b;
            3'b101: result = a | b;
            3'b110: result = a ^ b;
            3'b111: result = ~a;
            default: result = 0;
        endcase
    end

endmodule