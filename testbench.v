`timescale 1ns/1ps

module testbench();
    reg clk;
    reg [1:0] KEY;
    reg [8:0] X, Y;
    reg lclick;
    reg [3:0] index;


    // Instantiate DUT
    imdectest1 dut (
	.CLOCK_50(clk),
	.KEY(KEY),
	.lclick(lclick),
	.X(X),
	.Y(Y),
	.Nindex(index)
    );

    // Clock
    initial clk = 0;
    always #5 clk = ~clk; // 10ns period

    // Stimulus
    initial begin
        KEY[0] = 0;
	KEY[1] = 1;
	lclick <= 0;
	X <= 0;
	Y <= 0
        #150;
        KEY[0] = 1;
	#150;
	lclick <= 1;
	X <= 9'd;
	Y <= 9'd;
	#5;
	X <= 9'd;
	Y <= 9'd;
	#5;
	X <= 9'd;
	Y <= 9'd;
	#5;
	X <= 9'd;
	Y <= 9'd;
	#5;
	X <= 9'd;
	Y <= 9'd;
	#5;
	X <= 9'd;
	Y <= 9'd;
	#5;
	X <= 9'd;
	Y <= 9'd;
	#5;
	X <= 9'd;
	Y <= 9'd;
	#5;
	X <= 9'd;
	Y <= 9'd;
	#5;
	X <= 9'd;
	Y <= 9'd;
	#5;
	X <= 9'd;
	Y <= 9'd;
	#5;
	X <= 9'd;
	Y <= 9'd;
	#5;
	X <= 9'd;
	Y <= 9'd;
	#5;
	X <= 9'd;
	Y <= 9'd;
	#5;
	X <= 9'd;
	Y <= 9'd;
	#5;
	X <= 9'd;
	Y <= 9'd;
	#5;
	X <= 9'd;
	Y <= 9'd;
	#5;
	X <= 9'd;
	Y <= 9'd;
	#50;
	lclick <= 0;
	KEY[1] = 0;       
	#5000;
    end

    // Monitor

endmodule
