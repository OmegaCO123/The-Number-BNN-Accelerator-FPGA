module layer2(clk,rst,done);

    input clk,rst;
    output reg done;

    reg [2:0] state;
    parameter IDLE=0, READ_BRAM=1, XNOR_COUNT=2, STORE_ACT=3, WRITE_BRAM=4, NEXT_ADDR=5, DONE=6;

    reg [7:0] addr;   // row index 0..159
    reg [5:0] j;      // column index 0..31
    reg [6:0] k;      // bit index 0..63

    reg [6:0] sum0, sum1, sum2, sum3, sum4; // popcount accumulators
    reg [31:0] act0, act1, act2, act3, act4; // thresholded columns

    // represent the Weight in another BRAM, affect in XNOR: w2[0][2047 - (32*k + j)]
    reg [2047:0] W2 [0:0] /* synthesis ram_init_file = W2.mif */;

    // 5 M10 blocks, [160x64]
    reg [63:0] B0 [159:0] /* synthesis ram_init_file = B0.mif */;
    reg [63:0] B1 [159:0] /* synthesis ram_init_file = B1.mif */;
    reg [63:0] B2 [159:0] /* synthesis ram_init_file = B2.mif */;
    reg [63:0] B3 [159:0] /* synthesis ram_init_file = B3.mif */;
    reg [63:0] B4 [159:0] /* synthesis ram_init_file = B4.mif */;
    
    // 5 M10 blocks, [160x32]
    reg [31:0] B20 [159:0] /* synthesis ram_init_file = B20.mif */;
    reg [31:0] B21 [159:0] /* synthesis ram_init_file = B21.mif */;
    reg [31:0] B22 [159:0] /* synthesis ram_init_file = B22.mif */;
    reg [31:0] B23 [159:0] /* synthesis ram_init_file = B23.mif */;
    reg [31:0] B24 [159:0] /* synthesis ram_init_file = B24.mif */;
    
    reg wbit_q, b_q0, b_q1, b_q2, b_q3, b_q4;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            state <= IDLE;
            addr <= 0; j <= 0; k <= 0;
            sum0 <= 0; sum1 <= 0; sum2 <= 0; sum3 <= 0; sum4 <= 0;
            act0 <= 0; act1 <= 0; act2 <= 0; act3 <= 0; act4 <= 0;
            done <= 0;
        end else begin
            case(state)

                IDLE: begin
                    // wait until ready
                    addr <= 0; j <= 0; k <= 0;
                    done <= 0;
                    state <= READ_BRAM;
                end

                READ_BRAM: begin
                    // nothing special, data is already in BRAM
                    // could add prefetch if needed
                    wbit_q <= W2[2047 - (32*k + j)];
                    b_q0 <= B0[addr][63-k];
                    b_q1 <= B1[addr][63-k];
                    b_q2 <= B2[addr][63-k];
                    b_q3 <= B3[addr][63-k];
                    b_q4 <= B4[addr][63-k];
                    state <= XNOR_COUNT;
                end

                XNOR_COUNT: begin
                    // compute one bit of XNOR-popcount per cycle
                    if (~(b_q0 ^ wbit_q)) sum0 <= sum0 + 1;
                    if (~(b_q1 ^ wbit_q)) sum1 <= sum1 + 1;
                    if (~(b_q2 ^ wbit_q)) sum2 <= sum2 + 1;
                    if (~(b_q3 ^ wbit_q)) sum3 <= sum3 + 1;
                    if(addr < 8'd144) begin
                        if (~(b_q4 ^ wbit_q)) sum4 <= sum4 + 1;
                    end
                    // move to next bit or next state
                    if(k == 63) begin
                        k <= 0;
                        state <= STORE_ACT;
                    end else begin
                        k <= k + 1;
                    end
                end

                STORE_ACT: begin
                    // threshold the column and store into act registers
                    act0[j] <= (sum0 >= 7'd32) ? 1'b1 : 1'b0;
                    act1[j] <= (sum1 >= 7'd32) ? 1'b1 : 1'b0;
                    act2[j] <= (sum2 >= 7'd32) ? 1'b1 : 1'b0;
                    act3[j] <= (sum3 >= 7'd32) ? 1'b1 : 1'b0;
                    if(addr < 8'd144) begin
                        act4[j] <= (sum4 >= 7'd32) ? 1'b1 : 1'b0;
                    end

                    // reset sums for next column
                    sum0 <= 0; sum1 <= 0; sum2 <= 0; sum3 <= 0; sum4 <= 0;

                    // move to next column or write
                    if(j == 31) begin
                        j <= 0;
                        state <= WRITE_BRAM;
                    end else begin
                        j <= j + 1;
                        state <= XNOR_COUNT; // next column
                    end
                end

                WRITE_BRAM: begin
                    // write 32-bit act vectors to BRAM
                    B20[addr] <= act0;
                    B21[addr] <= act1;
                    B22[addr] <= act2;
                    B23[addr] <= act3;
                    if(addr < 8'd144) B24[addr] <= act4;

                    // reset act registers
                    act0 <= 0; act1 <= 0; act2 <= 0; act3 <= 0; act4 <= 0;

                    state <= NEXT_ADDR;
                end

                NEXT_ADDR: begin
                    // move to next row
                    if(addr == 159) state <= DONE;
                    else begin
                        addr <= addr + 1;
                        state <= READ_BRAM;
                    end
                end

                DONE: begin
                    done <= 1'b1;
                    // stay in DONE until reset
                end
            endcase
        end
    end
endmodule