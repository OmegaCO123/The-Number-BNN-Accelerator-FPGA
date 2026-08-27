`timescale 1ns/1ps

module testbench();
    reg clk;
    reg rst;
    reg [50175:0] x;
    wire [25087:0] l2R;
    wire done;

    reg  [63:0] val;

    // Instantiate DUT
    layer2 dut (
        .x(x),
        .l2R(l2R),
        .rst(rst),
        .clk(clk),
        .done(done)
    );

    // Clock
    initial clk = 0;
    always #5 clk = ~clk; // 10ns period
	
integer i,j;

    // Stimulus
    initial begin
	val = 64'b1011011101011001100101111101100100000010111010010001100000011100;
        rst = 0;
	for( i =0; i < 784; i = i+1) begin
		for( j=0; j < 64; j = j+ 1) begin
			x[i*64+j]= val[j];
		end
	end
        #150; rst = 1;
	#5000;
    end

    // Monitor
    initial begin
        $monitor("T=%0t | rst=%b | done=%b",
                 $time, rst, done);
    end

    integer f;
    integer row, col;

    initial begin
        f = $fopen("l2_matrix.txt", "w");
        if (f == 0) $display("ERROR: Could not open file.");
    end
    
    always @(posedge done) begin
        $display("Writing 784 x 32 output matrix to l2_matrix.txt ...");

        for (row = 0; row < 784; row = row + 1) begin
            for (col = 0; col < 32; col = col + 1) begin
                $fwrite(f, "%0d", l2R[row*32 + col]);
            end
            $fwrite(f, "\n");
        end

        $fclose(f);
        $display("Finished writing file.");
    end
endmodule
