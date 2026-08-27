module layer2(x, l3R);

    input [25087 : 0] x; // 784 x 32 -> 1 x 25088
    output reg signed [15:0] l3R [9:0]; // 1 x 10

    reg [250879 : 0] W3 = {}; // 25088 x 10 -> 1 x 250880

    integer j,k;
    integer sum;

    always @(*) begin
            for(j=0; j <= 9; j = j +1) begin
                sum = 0;
                for(k=0; k <= 25087; k = k +1) begin
                    sum = sum + ~(x[k]^W3[10*k+j]);
                end
                l3R[j] =2 * sum - 25088;
            end
        end
endmodule

module layer3(x, l3R, rst, clk, done);

    input [25087 : 0] x; // 784 x 32 -> 1 x 25088
    input rst;
    input clk;
    output reg signed [149:0] l3R; // 1 x 10
    output reg done;

    reg [250879 : 0] W3 = {}; // 25088 x 10 -> 1 x 250880

    reg [3:0] j;
    reg [14:0] k;
    reg signed [15:0] sum;

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            done <= 0;
            j <= 0;
            k <= 0;
            sum <= 0;
        end else if (!done) begin
                if (j <= 9) begin
                    if (k <= 25087) begin
                        sum <= sum + ~(x[k]^W3[10*k+j]);
                    end else begin
                        l3R[j] <= 2 * sum - 25088;
                        sum <= 0;
                        k <= 0;
                        j <= j + 1;
                    end
                end else begin
                    done <= 1;
                    j <= 0;
                end
            end
         end
endmodule
