module multiplier_n_bit_signed#(parameter n = 4)(
    input signed [n-1:0] a,    
    input signed [n-1:0] b,     
    input clk,                  
    input rst,                  
    output reg signed [2*n-1:0] result 
);
    reg signed [n:0] b_temp;      
    reg signed [2*n-1:0] A;  
    reg signed [2*n-1:0] a_temp;    
    reg internal_done;            
    reg internal_done_next; 
    integer i;                     

    always @(posedge clk or posedge rst) begin
        if (rst) begin  
            a_temp <= 0;
            b_temp <= 0;
            A <= 0;
            result <= 0;
            i <= 0;
            internal_done <= 1;  
        end else begin
            internal_done <= internal_done_next; 

            if (!internal_done) begin
                if (i == 0) begin
                    a_temp <= a;
                    b_temp <= {b, 1'b0}; 
                    A <= 0;
                    i <= 1;  
                end else if (i < n) begin
                    case ({b_temp[i+1], b_temp[i], b_temp[i-1]})
                        3'b001, 3'b010: A <= A + a_temp;
                        3'b011: A <= A + (a_temp << 1);
                        3'b100: A <= A - (a_temp << 1);
                        3'b101, 3'b110: A <= A - a_temp;
                        default: ;  
                    endcase

                    a_temp <= a_temp << 2;
                    i <= i + 2;
                end else begin
                    result <= A;   
                    i <= 0;           
                end
            end
        end
    end

    always @(*) begin
        if (rst) begin
            internal_done_next = 1; 
        end else if (i >= n) begin
            internal_done_next = 1; 
        end else begin
            internal_done_next = 0; 
        end
    end
endmodule




