`timescale 1ns/1ps

module testbench();
    reg clk;
    reg rst;
    reg [783:0] img;
    //wire [50175:0] l1R;
    wire done;

    // Instantiate DUT
    layer1 dut (
        .img(img),
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

    integer f0, f1, f2, f3, f4;
    integer i;

    initial begin
        f0 = $fopen("B0.txt", "w");
        if (f0 == 0) $display("f0: ERROR: Could not open file.");
        f1 = $fopen("B1.txt", "w");
        if (f1 == 0) $display("f1: ERROR: Could not open file.");
        f2 = $fopen("B2.txt", "w");
        if (f2 == 0) $display("f2: ERROR: Could not open file.");
        f3 = $fopen("B3.txt", "w");
        if (f3 == 0) $display("f3: ERROR: Could not open file.");
        f4 = $fopen("B4.txt", "w");
        if (f4 == 0) $display("f4: ERROR: Could not open file.");
    end
    
    always @(posedge done) begin
        $display("Writing B0-B4 output matricies ...");

        for (i = 0; i < 160; i = i + 1) begin
                $fwrite(f0, "%b\n", dut.B0[i]);
                $fwrite(f1, "%b\n", dut.B1[i]);
                $fwrite(f2, "%b\n", dut.B2[i]);
                $fwrite(f3, "%b\n", dut.B3[i]);
                $fwrite(f4, "%b\n", dut.B4[i]);
        end 

        $fclose(f0);
        $display("f0: Finished writing file.");

        $fclose(f1);
        $display("f1: Finished writing file.");

        $fclose(f2);
        $display("f2: Finished writing file.");

        $fclose(f3);
        $display("f3: Finished writing file.");

        $fclose(f4);
        $display("f4: Finished writing file.");
    end
endmodule