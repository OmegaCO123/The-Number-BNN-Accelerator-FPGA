module layer2(x, l2R, rst, clk, done);

    input [50175 : 0]x; // 784 x 64 -> 1 x 50176
    input rst;
    input clk;
    output reg [25087 : 0] l2R; // 784 x 32 -> 1 x 25088
    output reg done;

    reg [2047 : 0] W2 = {}; // 64 x 32 -> 1 x 2048

    reg [9:0] i;
    reg [4:0] j;
    reg [5:0] k;
    reg signed [6:0] sum;

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            done <= 0;
            i <= 0;
            j <= 0;
            k <= 0;
            sum <= 0;
        end else if (!done) begin
            if(i <= 783) begin
                if (j <= 31) begin
                    if (k <= 63) begin
                        sum <= sum + ~(x[64*i+k]^W2[32*k+j]);
                    end else begin
                        l2R[32*i + j] <= ((2 * sum - 64) >= 0) ? 1 : 0;
                        sum <= 0;
                        k <= 0;
                        j <= j + 1;
                    end
                end else begin
                    i <= i + 1;
                    j <= 0;
                end
            end else begin
                done <= 1;
                i <= 0;
            end
        end
    end
endmodule
