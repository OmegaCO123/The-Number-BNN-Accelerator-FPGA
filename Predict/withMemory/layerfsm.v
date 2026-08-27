module LayerTest1 (KEY, LEDR, clk, HEX0);
    //input  [2:0] SW;
    // input  CLOCK_50;
    input clk;
    input  [1:0] KEY;
    output [9:0] LEDR;
    output [6:0] HEX0;

    // active-high reset for your top-level logic
    wire Resetn = KEY[0];

    //reg  [3:0] index;
    reg signed [15:0] No, Ncurr;
    reg L1en, L2en, L3en, recogdone, Maxtime;

    //wire [50175:0] L2in;
    //wire [25087:0] L3in;
    //wire signed [159:0] Lout;
    wire L1done, L2done, NNdone;

    // just to see something on LEDs (lower 4 bits = Nindex)
    //assign LEDR = {6'b0, index};

    // constant test image (your 7-like pattern)
    wire [783:0] NNin = 784'b0;


    always @ (posedge clk or negedge Resetn) begin
        if (!Resetn) begin
            // global reset
            L1en      <= 1'b0;    // hold all layers in reset (active-low internal)
            L2en      <= 1'b0;
            L3en      <= 1'b0;
            recogdone <= 1'b0;
            Maxtime   <= 1'b0;

            //index     <= 4'd0;
          
            //No        <= 16'sh8000;  // min signed value
        end else begin
            // start pipeline when KEY[1] is pressed (active-low)
            if (!KEY[1]) begin
                L1en <= 1'b1;     // release layer1 reset
            end

            // when layer1 is done, release layer2
            if (L1done) begin
                L2en <= 1'b1;
            end

            // when layer2 is done, release layer3
            if (L2done) begin
                L3en <= 1'b1;
            end

            // NNdone: layer3 finished, start argmax sweep once
            end
        end


  
    // ----------------------------------------------------------
   wire [3:0] Nindex;
    layer1 l1 (
        .img (NNin),
        .rst (L1en),
        .clk (clk),
        .done(L1done)
    );

    layer2 l2 (
        .rst (L2en),
        .clk (clk),
        .done(L2done)
    );

    layer3 l3 (
        .maxindex (Nindex),
        .rst (L3en),
        .clk (clk),
        .done(NNdone)
    );
     
    
    hex_decoder hex0(
        .hex_digit (Nindex),
        .recogdone (NNdone),
        .segments  (HEX0)
    );

endmodule


// 7-seg decoder (unchanged except for style)
module hex_decoder(hex_digit, recogdone, segments);
    input  [3:0] hex_digit;
    input        recogdone;
    output reg [6:0] segments;
   
    always @(*) begin
        if (recogdone) begin
            case (hex_digit)
                4'd0: segments = 7'b100_0000;
                4'd1: segments = 7'b111_1001;
                4'd2: segments = 7'b010_0100;
                4'd3: segments = 7'b011_0000;
                4'd4: segments = 7'b001_1001;
                4'd5: segments = 7'b001_0010;
                4'd6: segments = 7'b000_0010;
                4'd7: segments = 7'b111_1000;
                4'd8: segments = 7'b000_0000;
                4'd9: segments = 7'b001_1000;
                4'hA: segments = 7'b000_1000;
                4'hB: segments = 7'b000_0011;
                4'hC: segments = 7'b100_0110;
                4'hD: segments = 7'b010_0001;
                4'hE: segments = 7'b000_0110;
                4'hF: segments = 7'b000_1110;   
                default: segments = 7'h7f;
            endcase
        end else begin 
            segments = 7'b111_1111; // blank when not ready
        end
    end
endmodule