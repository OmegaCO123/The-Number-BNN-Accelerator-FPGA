module layer1(img, rst, clk, done);

    input [783:0] img; // 784 x 1
    input rst;
    input clk;
    //output reg [50175:0] l1R; // 784 x 64
    output reg done;

    // Weight
    reg [63:0] W1 = 64'b0100100010100110011010000010011011111101000101101110011111100011; // 1 x 64 Hex-> 0x48A66826FD16E7E3 -> reversed: 3E7E61Df62866A84

    // 5 M10 blocks, [160x64]
    reg [63:0] B0 [159:0] /* synthesis ram_init_file = B0.mif */
    reg [63:0] B1 [159:0] /* synthesis ram_init_file = B1.mif */
    reg [63:0] B2 [159:0] /* synthesis ram_init_file = B2.mif */
    reg [63:0] B3 [159:0] /* synthesis ram_init_file = B3.mif */
    reg [63:0] B4 [159:0] /* synthesis ram_init_file = B4.mif */

    reg ready;
    //reg [9:0] i;
    //reg [6:0] j;

    wire write_en = 1'b1;
    reg [7:0] addr; //8 bits

    //reg currentIMG;
    //reg currentW;
    //reg [50175:0] currentPos;

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            ready <= 1'b0;
            done <= 1'b0;
            //i <= 10'b0;
            //j <= 7'b0;
	        //l1R <= 50176'b0;
    	    //currentIMG <= 0;
    	    //currentW <= 0;
            addr <= 0;
        end else if (ready & !done) begin
            if(addr < 8'd160) begin
                if(write_en) begin
                    B0[addr] <= ~(((img[783 - addr])? 64'hFFFFFFFFFFFFFFFF:64'b0) ^ W1);
                    B1[addr] <= ~(((img[783 - 160 + addr])? 64'hFFFFFFFFFFFFFFFF:64'b0) ^ W1);
                    B2[addr] <= ~(((img[783 - 320 + addr])? 64'hFFFFFFFFFFFFFFFF:64'b0) ^ W1);
                    B3[addr] <= ~(((img[783 - 480 + addr])? 64'hFFFFFFFFFFFFFFFF:64'b0) ^ W1);
                    if(640 + addr < 784) begin
                        B4[addr] <= ~(((img[783 - 640 + addr])? 64'hFFFFFFFFFFFFFFFF:64'b0) ^ W1);
                    end 
                    addr <= addr + 1;
                end
            end else begin
                done <= 1'b1;
                addr <= 0;
            end
        end else begin
            ready <= 1;
        end 
    end
endmodule