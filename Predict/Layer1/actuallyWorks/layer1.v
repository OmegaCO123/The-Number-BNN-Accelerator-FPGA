module layer1(img, l1R, rst, clk, done);

    input [783:0] img; // 784 x 1
    input rst;
    input clk;
    output reg [50175:0] l1R; // 784 x 64
    output reg done;

    reg [63:0] W1 = 64'b0100100010100110011010000010011011111101000101101110011111100011; // 1 x 64 0x48A66826FD16E7E3

    reg [9:0] i;
    reg [6:0] j;

    //reg currentIMG;
    //reg currentW;
    //reg [50175:0] currentPos;

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            done <= 1'b0;
            i <= 10'b0;
            j <= 7'b0;
	    l1R <= 50176'b0;
    	    //currentIMG <= 0;
    	    //currentW <= 0;
        end else if (!done) begin
            if (i < 10'd784) begin
                if (j < 7'd64) begin
                    l1R[64*i+j] <= ~(img[783 - i]^W1[63 - j]);
		    //currentIMG <= img[i];
		    //currentW <= W1[j];
		    //currentPos <= 64*i + j;
                    j <= j + 7'd1;
                end else begin
                    j <= 7'b0;
                    i <= i + 10'b0000000001;
                end
            end else begin
                i <= 0;
                done <= 1'b1;
            end
        end
    end
endmodule
