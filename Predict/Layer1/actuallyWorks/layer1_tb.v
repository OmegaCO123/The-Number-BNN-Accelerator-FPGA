`timescale 1ns/1ps

module testbench();
    reg clk;
    reg rst;
    reg [783:0] img;
    wire [50175:0] l1R;
    wire done;

    // Instantiate DUT
    layer1 dut (
        .img(img),
        .l1R(l1R),
        .rst(rst),
        .clk(clk),
        .done(done)
    );

    // Clock
    initial clk = 0;
    always #5 clk = ~clk; // 10ns period

    // Stimulus
    initial begin
        rst = 0;

        img = 784'b0;

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
        f = $fopen("l1_matrix.txt", "w");
        if (f == 0) $display("ERROR: Could not open file.");
    end
    
    always @(posedge done) begin
        $display("Writing 784x64 output matrix to l1_matrix.txt ...");

        for (row = 0; row < 784; row = row + 1) begin
            for (col = 0; col < 64; col = col + 1) begin
                $fwrite(f, "%0d", l1R[row*64 + col]);
            end
            $fwrite(f, "\n");
        end

        $fclose(f);
        $display("Finished writing file.");
    end
endmodule
