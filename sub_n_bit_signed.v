module sub_n_bit_signed#(parameter n = 4)(
    input signed   [n-1:0] a,
    input signed [n-1:0] b,
    output signed [n:0] result
);
wire [n-1:0] b1;
assign b1 = ~b + 1'b1;
wire [n:0] pre_result;

add_n_bit_signed u1 (
    .a(a),
    .b(b1),
    .result(pre_result)
);
assign result = (b1 == 4'b1000) ? {~pre_result[4], pre_result[3:0]} : pre_result;

endmodule