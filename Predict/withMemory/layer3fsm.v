module layer3(
    input clk,
    input rst,
    output reg [3:0] maxindex, // 10 neurons max index
    output reg done
);

    // FSM states
    reg [2:0] state;
    parameter IDLE=0, READ_BRAM=1, XNOR_COUNT=2, NEXT_BIT=3, STORE_SUM=4, NEXT_NEURON=5, DONE=6;

    // Counters
    reg [3:0] j;          // neuron index 0..9
    reg [14:0] k;         // bit index 0..25087 (784*32)
    reg [15:0] sum;       // popcount accumulator for current neuron
    reg signed [15:0] maxnum;

    // BRAM bit registers
    reg b2bit, w3bit;

    // layer2 outputs stored in BRAM (B20..B24)
    reg [31:0] B20 [159:0] /* synthesis ram_init_file = B20.mif */;
    reg [31:0] B21 [159:0] /* synthesis ram_init_file = B21.mif */;
    reg [31:0] B22 [159:0] /* synthesis ram_init_file = B22.mif */;
    reg [31:0] B23 [159:0] /* synthesis ram_init_file = B23.mif */;
    reg [31:0] B24 [159:0] /* synthesis ram_init_file = B24.mif */;

    // layer3 weights stored in BRAM
    // 25 M10 blocks, [1024x10]
    reg [] W3 = {};


    // FSM
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            state <= IDLE;
            j <= 0; k <= 0; sum <= 0;
            maxnum <= -16'sh8000;
            maxindex <= 0;
            done <= 0;
        end else begin
            case(state)
                IDLE: begin
                    j <= 0; k <= 0; sum <= 0;
                    maxnum <= -16'sh8000;
                    maxindex <= 0;
                    done <= 0;
                    state <= READ_BRAM;
                end

                READ_BRAM: begin
                    // select layer2 bit
                    if(k < 1024) b2bit <= B20[k/32][31 - (k%32)];
                    else if(k < 2048) b2bit <= B21[(k-1024)/32][31 - ((k-1024)%32)];
                    else if(k < 3072) b2bit <= B22[(k-2048)/32][31 - ((k-2048)%32)];
                    else if(k < 4096) b2bit <= B23[(k-3072)/32][31 - ((k-3072)%32)];
                    else b2bit <= B24[(k-4096)/32][31 - ((k-4096)%32)];

                    // select layer3 weight bit
                        w3bit <= W3[];

                    state <= XNOR_COUNT;
                end

                XNOR_COUNT: begin
                    // XNOR + popcount
                    if(~(b2bit ^ w3bit)) sum <= sum + 1;
                    state <= NEXT_BIT;
                end

                NEXT_BIT: begin
                    if(k == 25087) state <= STORE_SUM;
                    else begin
                        k <= k + 1;
                        state <= READ_BRAM;
                    end
                end

                STORE_SUM: begin
                    // calculate signed result and update max
                    if((2*sum - 25088) > maxnum) begin
                        maxnum <= 2*sum - 25088;
                        maxindex <= j;
                    end
                    sum <= 0;
                    state <= NEXT_NEURON;
                end

                NEXT_NEURON: begin
                    if(j == 9) state <= DONE;
                    else begin
                        j <= j + 1;
                        k <= 0;
                        state <= READ_BRAM;
                    end
                end

                DONE: begin
                    done <= 1;
                end
            endcase
        end
    end
endmodule

                    if(k < 1024) w3bit <= B30[k/32][31 - (k%32)];
                    else if(k < 2048) w3bit <= B31[(k-1024)/32][31 - ((k-1024)%32)];
                    else if(k < 3072) w3bit <= B32[(k-2048)/32][31 - ((k-2048)%32)];
                    else if(k < 4096) w3bit <= B33[(k-3072)/32][31 - ((k-3072)%32)];
                    else w3bit <= B34[(k-4096)/32][31 - ((k-4096)%32)];