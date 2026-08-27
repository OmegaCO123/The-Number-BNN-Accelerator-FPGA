module layer3(x, l3R, rst, clk, done);

    input [25087 : 0] x; // 784 x 32 -> 1 x 25088
    input rst;
    input clk;
    output reg signed [159:0] l3R; // 1 x 10
    output reg done;

  reg [250879 : 0] W3 = 250880'b{}; // github could not take it.

  reg [3:0] j;
    reg [15:0] k;
    reg [15:0] sum;
    reg [16:0] results;

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            done <= 0;
            j <= 0;
            k <= 0;
            sum <= 0;
	    l3R <= 0;
	    results <= 0;
        end else if (!done) begin
                if (j < 10) begin
                    if (k < 25088) begin
			if(~( x[ 25087 - k ] ^ W3[ 250879 - (10*k+j) ] )) begin 
				sum <= sum + 1 ;
			end                 
			k <= k + 1;
                    end else begin
                        //l3R[j] <= 2 * sum - 25088;
			results <= 2 * sum - 25088;
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
