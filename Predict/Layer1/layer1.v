module layer1(img, l1R, rst, clk, done);

    input [783:0] img; // 784 x 1
    input clk;
    output reg [50175:0] l1R; // 784 x 64
    output reg done;

    reg [63:0] W1 = {}; // 1 x 64

    reg [9:0] i;
    reg [5:0] j;

    always(posedge clk or negedge rst) begin
        if(!rst) begin
            done <= 0;
            i <= 0;
            j <= 0;
        end else if (!done) begin
            if (i <= 783) begin
                if (j <= 63) begin
                    l1R[64*i+j] <= ~(img[i]^W1[j]);
                    j <= j + 1;
                end else begin
                    j <= 0;
                    i <= i + 1;
                end
            end else begin
                i <= 0;
                done <= 1;
            end
        end
    end
endmodule
