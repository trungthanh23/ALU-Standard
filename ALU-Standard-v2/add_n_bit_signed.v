module full_adder_1bit(
    input a,
    input b,
    input carry_in,
    output sum,
    output carry_out
);
assign sum = a ^ b ^ carry_in;
assign carry_out = ((a ^ b) & carry_in) | (a & b);
endmodule

module add_n_bit_signed #(parameter n = 4)(
    input signed [n - 1:0] a,
    input signed [n - 1:0] b,
    input enable,
    output reg valid,
    output signed [n:0] result
);
    wire [n - 1:0] carry_out;
    wire [n:0] pre_result;
    genvar i;
    generate
        for (i = 0; i <= n - 1; i = i +1) begin : FA_T1
            if (i == 0) begin
                full_adder_1bit u1(
                .a(a[i]),
                .b(b[i]),
                .carry_in(1'b0),
                .sum(pre_result[i]),
                .carry_out(carry_out[i])
            );
            end
            else begin
            full_adder_1bit u2(
                .a(a[i]),
                .b(b[i]),
                .carry_in(carry_out[i - 1]),
                .sum(pre_result[i]),
                .carry_out(carry_out[i])
            );
            end
        end
    endgenerate
    
    assign pre_result[n] = ((a[n-1] ^ b[n-1]) ? ~carry_out[n-1] : carry_out[n-1]);

    // Thêm logic enable và valid
    always @(*) begin
        if (enable) begin
            valid = 1'b1;
        end else begin
            valid = 1'b0;
        end
    end

    assign result = pre_result;
endmodule