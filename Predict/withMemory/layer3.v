module layer3(maxindex, rst, clk, done);

    //input [25087 : 0] x; // 784 x 32 -> 1 x 25088
    input rst;
    input clk;
    output reg [3:0] maxindex; // 1 x 10
    output reg done;

    reg ready;

    //Weights here:
    // 25 M10 blocks, [1024x10]
    reg [9:0] B30 [1023:0] /* synthesis ram_init_file = B30.mif */
    reg [9:0] B31 [1023:0] /* synthesis ram_init_file = B31.mif */
    reg [9:0] B32 [1023:0] /* synthesis ram_init_file = B32.mif */
    reg [9:0] B33 [1023:0] /* synthesis ram_init_file = B33.mif */
    reg [9:0] B34 [1023:0] /* synthesis ram_init_file = B34.mif */
    reg [9:0] B35 [1023:0] /* synthesis ram_init_file = B35.mif */
    reg [9:0] B36 [1023:0] /* synthesis ram_init_file = B36.mif */
    reg [9:0] B37 [1023:0] /* synthesis ram_init_file = B37.mif */
    reg [9:0] B38 [1023:0] /* synthesis ram_init_file = B38.mif */
    reg [9:0] B39 [1023:0] /* synthesis ram_init_file = B39.mif */
    reg [9:0] B310 [1023:0] /* synthesis ram_init_file = B310.mif */
    reg [9:0] B311 [1023:0] /* synthesis ram_init_file = B311.mif */
    reg [9:0] B312 [1023:0] /* synthesis ram_init_file = B312.mif */
    reg [9:0] B313 [1023:0] /* synthesis ram_init_file = B313.mif */
    reg [9:0] B314 [1023:0] /* synthesis ram_init_file = B314.mif */
    reg [9:0] B315 [1023:0] /* synthesis ram_init_file = B315.mif */
    reg [9:0] B316 [1023:0] /* synthesis ram_init_file = B316.mif */
    reg [9:0] B317 [1023:0] /* synthesis ram_init_file = B317.mif */
    reg [9:0] B318 [1023:0] /* synthesis ram_init_file = B318.mif */
    reg [9:0] B319 [1023:0] /* synthesis ram_init_file = B319.mif */
    reg [9:0] B320 [1023:0] /* synthesis ram_init_file = B320.mif */
    reg [9:0] B321 [1023:0] /* synthesis ram_init_file = B321.mif */
    reg [9:0] B322 [1023:0] /* synthesis ram_init_file = B322.mif */
    reg [9:0] B323 [1023:0] /* synthesis ram_init_file = B323.mif */
    reg [9:0] B324 [1023:0] /* synthesis ram_init_file = B324.mif */


    //layer2 output: 
    // 5 M10 blocks, [160x32]
    reg [31:0] B20 [159:0] /* synthesis ram_init_file = B20.mif */
    reg [31:0] B21 [159:0] /* synthesis ram_init_file = B21.mif */
    reg [31:0] B22 [159:0] /* synthesis ram_init_file = B22.mif */
    reg [31:0] B23 [159:0] /* synthesis ram_init_file = B23.mif */
    reg [31:0] B24 [159:0] /* synthesis ram_init_file = B24.mif */


    reg [3:0] j;
    reg [15:0] k;
    reg [15:0] sum;
    //reg signed [15:0] result;
    reg signed [15:0] maxnum;

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            done <= 0;
            j <= 0;
            k <= 0;
            sum <= 0;
	        //result <= 0;
	        maxnum <= -16'h8000;
	        maxindex <= 4'd0;
            ready <= 0;
        end else if (ready & !done) begin
                if (j < 10) begin
                    if (k < 25088) begin
                        if(k >= 0 & k < 1024) begin
                            if(~(B20[k>>5][31 - (k & 5'b11111)] ^ B30[k][9 - j])) sum <= sum + 1;
                        end else if (k >= 1024 & k < 2048) begin 
                            if(~(B20[k>>5][31 - (k & 5'b11111)] ^ B31[k][9 - j])) sum <= sum + 1;                      
                        end else if (k >= 2048 & k < 3072) begin  
                            if(~(B20[k>>5][31 - (k & 5'b11111)] ^ B32[k][9 - j])) sum <= sum + 1;                    
                        end else if (k >= 3072 & k < 4096) begin 
                            if(~(B20[k>>5][31 - (k & 5'b11111)] ^ B33[k][9 - j])) sum <= sum + 1;                       
                        end else if (k >= 4096 & k < 5120) begin          
                            if(~(B20[k>>5][31 - (k & 5'b11111)] ^ B34[k][9 - j])) sum <= sum + 1;    
                        end else if (k >= 5120 & k < 6144) begin       
                            if(~(B21[k>>5][31 - (k & 5'b11111)] ^ B35[k][9 - j])) sum <= sum + 1;                 
                        end else if (k >= 6144 & k < 7168) begin                      
                        end else if (k >= 7168 & k < 8192) begin                      
                        end else if (k >= 8192 & k < 9216) begin                       
                        end else if (k >= 9216 & k < 10240) begin                       
                        end else if (k >= 10240 & k < 11264) begin                     
                        end else if (k >= 11264 & k < 12288) begin                      
                        end else if (k >= 12288 & k < 13312) begin                     
                        end else if (k >= 13312 & k < 14336) begin                       
                        end else if (k >= 14336 & k < 15360) begin                      
                        end else if (k >= 15360 & k < 16384) begin                    
                        end else if (k >= 16384 & k < 17408) begin                      
                        end else if (k >= 17408 & k < 18432) begin                    
                        end else if (k >= 18432 & k < 19456) begin                    
                        end else if (k >= 19456 & k < 20480) begin                     
                        end else if (k >= 20480 & k < 21504) begin                     
                        end else if (k >= 21504 & k < 21504) begin                       
                        end else if (k >= 22528 & k < 23552) begin                      
                        end else if (k >= 23552 & k < 24576) begin                    
                        end else if (k >= 24576 & k < 25600) begin                      
                        end
			            k <= k + 1;
                    end else begin
                        //l3R[j] <= 2 * sum - 25088;
		                //result <= 2 * sum - 25088;
			            if (2 * sum - 25088 > maxnum) begin
			                maxnum <= 2 * sum - 25088;
			                maxindex <= j;
			            end
                        sum <= 0;
                        k <= 0;
                        j <= j + 1;
                    end
                end else begin
                    done <= 1;
                    j <= 0;
                end
            end else begin
                ready <= 1 ;
            end
         end
endmodule