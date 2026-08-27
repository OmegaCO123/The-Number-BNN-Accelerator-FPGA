`timescale 1ns/1ps

module testbench();
    reg clk;
    reg rst;
    reg [25087 : 0] x;
    wire [159:0] l3R;
    wire done;

    reg  [31:0] val;

    // Instantiate DUT
    layer3 dut (
        .x(x),
        .l3R(l3R),
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
	val = 32'b00000010110111000010001010101010;
        rst = 0;
	for( i =0; i < 784; i = i+1) begin
		for( j=0; j < 32; j = j+ 1) begin
			x[i*32+j]= val[j];
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
        f = $fopen("l3_matrix.txt", "w");
        if (f == 0) $display("ERROR: Could not open file.");
    end
    
    always @(posedge done) begin
        $display("Writing 10x16 output matrix to l3_matrix.txt ...");

        for (row = 0; row < 10; row = row + 1) begin
            for (col = 0; col < 16; col = col + 1) begin
                $fwrite(f, "%0d", l3R[row*16 + col]);
            end
            $fwrite(f, "\n");
        end

        $fclose(f);
        $display("Finished writing file.");
    end
endmodule
