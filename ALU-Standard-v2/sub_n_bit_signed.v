module sub_n_bit_signed #(parameter n = 4)(
    input signed [n-1:0] a,
    input signed [n-1:0] b,
    input enable,
    output reg valid,
    output signed [n:0] result
);
    wire [n-1:0] b1;
    assign b1 = ~b + 1'b1;
    wire [n:0] pre_result;
    wire add_valid;

    add_n_bit_signed u1 (
        .a(a),
        .b(b1),
        .enable(enable),
        .valid(add_valid),
        .result(pre_result)
    );

    // Thêm logic enable và valid
    always @(*) begin
        if (enable && add_valid) begin
            valid = 1'b1;
        end else begin
            valid = 1'b0;
        end
    end

    assign result = (b1 == {1'b1, {(n-1){1'b0}}}) ? {~pre_result[n], pre_result[n-1:0]} : pre_result;
endmodule