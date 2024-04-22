`timescale 1ns/100ps


`define cycle_period 10
`define End_CYCLE  250
module test_tpu;

localparam DATA_WIDTH = 8;
localparam OUT_DATA_WIDTH = 16;
localparam SRAM_DATA_WIDTH = 32;
localparam WEIGHT_NUM = 25, WEIGHT_WIDTH = 4;
localparam ARRAY_SIZE = 8;

//====== module I/O =====
// reg clk;
// reg srstn;
// reg tpu_start;

// wire tpu_finish;

reg clock, reset;

reg input_valid, output_ready;
wire input_ready, output_valid;
reg input_finish;


wire sram_write_enable_a0;
wire sram_write_enable_a1;


wire sram_write_enable_b0;
wire sram_write_enable_b1;


wire sram_write_enable_c0;
wire sram_write_enable_c1;
wire sram_write_enable_c2;

reg [SRAM_DATA_WIDTH-1:0] sram_rdata_a0;
reg [SRAM_DATA_WIDTH-1:0] sram_rdata_a1;

reg [SRAM_DATA_WIDTH-1:0] sram_rdata_b0;
reg [SRAM_DATA_WIDTH-1:0] sram_rdata_b1;


reg [9:0] sram_raddr;
// reg [9:0] sram_raddr_a1;


// reg [9:0] sram_raddr_b0;
// reg [9:0] sram_raddr_b1;


wire [5:0] sram_raddr_c0;
wire [5:0] sram_raddr_c1;
wire [5:0] sram_raddr_c2;

wire [3:0] sram_bytemask_a;
wire [3:0] sram_bytemask_b;
wire [9:0] sram_waddr_a;
wire [9:0] sram_waddr_b;
wire [7:0] sram_wdata_a;
wire [7:0] sram_wdata_b;

wire [DATA_WIDTH*OUT_DATA_WIDTH/2-1:0] sram_wdata_c00;
wire [DATA_WIDTH*OUT_DATA_WIDTH/2-1:0] sram_wdata_c01;
wire [DATA_WIDTH*OUT_DATA_WIDTH/2-1:0] sram_wdata_c10;
wire [DATA_WIDTH*OUT_DATA_WIDTH/2-1:0] sram_wdata_c11;
wire [DATA_WIDTH*OUT_DATA_WIDTH/2-1:0] sram_wdata_c20;
wire [DATA_WIDTH*OUT_DATA_WIDTH/2-1:0] sram_wdata_c21;

wire [DATA_WIDTH*OUT_DATA_WIDTH-1:0] sram_rdata_c0;
wire [DATA_WIDTH*OUT_DATA_WIDTH-1:0] sram_rdata_c1;
wire [DATA_WIDTH*OUT_DATA_WIDTH-1:0] sram_rdata_c2;

wire [5:0] sram_waddr_c0;
wire [5:0] sram_waddr_c1;
wire [5:0] sram_waddr_c2;

wire [4*OUT_DATA_WIDTH-1:0] c00;
wire [4*OUT_DATA_WIDTH-1:0] c01;
wire [4*OUT_DATA_WIDTH-1:0] c10;
wire [4*OUT_DATA_WIDTH-1:0] c11;
wire [4*OUT_DATA_WIDTH-1:0] c20;
wire [4*OUT_DATA_WIDTH-1:0] c21;
wire [4*OUT_DATA_WIDTH-1:0] c30;
wire [4*OUT_DATA_WIDTH-1:0] c31;
wire [4*OUT_DATA_WIDTH-1:0] c40;
wire [4*OUT_DATA_WIDTH-1:0] c41;
wire [4*OUT_DATA_WIDTH-1:0] c50;
wire [4*OUT_DATA_WIDTH-1:0] c51;
wire [4*OUT_DATA_WIDTH-1:0] c60;
wire [4*OUT_DATA_WIDTH-1:0] c61;
wire [4*OUT_DATA_WIDTH-1:0] c70;
wire [4*OUT_DATA_WIDTH-1:0] c71;

wire signed [7:0] out;


//reg [7:0] mem[0:32*32-1];


//====== top connection =====



//sram connection

MMMMIOBlackBox my(
	.clock(clock),
	.reset(reset),
	.input_finish(input_finish),
    .input_ready(input_ready),
    .input_valid(input_valid),
    .output_ready(output_ready),
    .output_valid(output_valid),

	//input data
	.sram_rdata_a0(sram_rdata_a0),
	.sram_rdata_a1(sram_rdata_a1),

	.sram_rdata_b0(sram_rdata_b0),
	.sram_rdata_b1(sram_rdata_b1),

	//input addr
	.sram_raddr(sram_raddr),
	// .sram_raddr_a1(sram_raddr_a1),

	// .sram_raddr_b0(sram_raddr_b0),
	// .sram_raddr_b1(sram_raddr_b1),

	//write to the SRAM for comparision
	// .sram_write_enable_c0(sram_write_enable_c0),
	// .sram_wdata_c00(sram_wdata_c00),
	// .sram_wdata_c01(sram_wdata_c01),
	// .sram_waddr_c0(sram_waddr_c0),

	// .sram_write_enable_c1(sram_write_enable_c1),
	// .sram_wdata_c10(sram_wdata_c10),
	// .sram_wdata_c11(sram_wdata_c11),
	// .sram_waddr_c1(sram_waddr_c1),

	// .sram_write_enable_c2(sram_write_enable_c2),
	// .sram_wdata_c20(sram_wdata_c20),
	// .sram_wdata_c21(sram_wdata_c21),
	// .sram_waddr_c2(sram_waddr_c2)
	.c00(c00),
	.c01(c01),
	.c10(c10),
	.c11(c11),
	.c20(c20),
	.c21(c21),
	.c30(c30),
	.c31(c31),
	.c40(c40),
	.c41(c41),
	.c50(c50),
	.c51(c51),
	.c60(c60),
	.c61(c61),
	.c70(c70),
	.c71(c71)
);

// sram_128x32b sram_128x32b_a0(
// .clk(clock),
// .bytemask(sram_bytemask_a),
// .csb(1'b0),
// .wsb(sram_write_enable_a0),
// // .wdata(sram_wdata_a), 
// // .waddr(sram_waddr_a), 
// .raddr(sram_raddr_a0), 
// .rdata(sram_rdata_a0)
// );

// sram_128x32b sram_128x32b_a1(
// .clk(clock),
// .bytemask(sram_bytemask_a),
// .csb(1'b0),
// .wsb(sram_write_enable_a1),
// // .wdata(sram_wdata_a), 
// // .waddr(sram_waddr_a), 
// .raddr(sram_raddr_a1), 
// .rdata(sram_rdata_a1)
// );


// //SRAM 2 
// sram_128x32b sram_128x32b_b0(
// .clk(clock),
// .bytemask(sram_bytemask_b),
// .csb(1'b0),
// .wsb(sram_write_enable_b0),
// // .wdata(sram_wdata_b), 
// // .waddr(sram_waddr_b), 
// .raddr(sram_raddr_b0), 
// .rdata(sram_rdata_b0)
// );

// sram_128x32b sram_128x32b_b1(
// .clk(clock),
// .bytemask(sram_bytemask_b),
// .csb(1'b0),
// .wsb(sram_write_enable_b1),
// // .wdata(sram_wdata_b), 
// // .waddr(sram_waddr_b), 
// .raddr(sram_raddr_b1), 
// .rdata(sram_rdata_b1)
// );


//write sram
// sram_16x128b sram_16x128b_c0(
// .clk(clock),
// .csb(1'b0),
// .wsb(sram_write_enable_c0),
// .wdata({sram_wdata_c00, sram_wdata_c01}), 
// .waddr(sram_waddr_c0), 
// .raddr(sram_raddr_c0), 
// .rdata(sram_rdata_c0)
// );
// sram_16x128b sram_16x128b_c1(
// .clk(clock),
// .csb(1'b0),
// .wsb(sram_write_enable_c1),
// .wdata({sram_wdata_c10, sram_wdata_c11}), 
// .waddr(sram_waddr_c1), 
// .raddr(sram_raddr_c1), 
// .rdata(sram_rdata_c1)
// );
// sram_16x128b sram_16x128b_c2(
// .clk(clock),
// .csb(1'b0),
// .wsb(sram_write_enable_c2),
// .wdata({sram_wdata_c20, sram_wdata_c21}), 
// .waddr(sram_waddr_c2), 
// .raddr(sram_raddr_c2), 
// .rdata(sram_rdata_c2)
// );



//dump wave file
initial begin
  $dumpfile("tpu.vcd"); // "gray.fsdb" can be replaced into any name you want
  $dumpvars(0,test_tpu);              // but make sure in .fsdb format
end

//====== clock generation =====
initial begin
    reset = 1'b1;
    clock = 1'b1;
end

always begin #(`cycle_period/2) clock = ~clock; end
//====== main procedural block for simulation =====
integer cycle_cnt;


integer i,j,k;
reg [ARRAY_SIZE*DATA_WIDTH-1:0] mat1[0:ARRAY_SIZE*3-1];
reg [ARRAY_SIZE*DATA_WIDTH-1:0] mat2[0:ARRAY_SIZE*3-1];
reg [ARRAY_SIZE*3*DATA_WIDTH-1:0] tmp_c_mat1[0:ARRAY_SIZE-1];
reg [ARRAY_SIZE*3*DATA_WIDTH-1:0] tmp_c_mat2[0:ARRAY_SIZE-1];
reg [(ARRAY_SIZE*3+3)*DATA_WIDTH-1:0] tmp_mat1[0:ARRAY_SIZE-1];
reg [(ARRAY_SIZE*3+3)*DATA_WIDTH-1:0] tmp_mat2[0:ARRAY_SIZE-1];
reg [ARRAY_SIZE*OUT_DATA_WIDTH-1:0] golden1[0:ARRAY_SIZE-1];
reg [ARRAY_SIZE*OUT_DATA_WIDTH-1:0] golden2[0:ARRAY_SIZE-1];
reg [ARRAY_SIZE*OUT_DATA_WIDTH-1:0] golden3[0:ARRAY_SIZE-1];

reg [ARRAY_SIZE*16-1:0] trans_golden1[0:(ARRAY_SIZE*2-1)-1];
reg [ARRAY_SIZE*16-1:0] trans_golden2[0:(ARRAY_SIZE*2-1)-1];
reg [ARRAY_SIZE*16-1:0] trans_golden3[0:(ARRAY_SIZE*2-1)-1];

reg [31:0] a0 [0:26];
reg [31:0] a1 [0:26];
reg [31:0] b0 [0:26];
reg [31:0] b1 [0:26];

initial begin
a0[0]=32'b10101111000000000000000000000000;
a0[1]=32'b10011110111111110000000000000000;
a0[2]=32'b01101110010100011111101000000000;
a0[3]=32'b10011111101101001100101111010010;
a0[4]=32'b00001110111000000100000010101011;
a0[5]=32'b11111001010010000001011111111101;
a0[6]=32'b10111111110100010010101111110000;
a0[7]=32'b10111001110000100001101111100111;
a0[8]=32'b10001001000000011001100111001111;
a0[9]=32'b10110101111001100111001010101111;
a0[10]=32'b10110011101110011001011111111101;
a0[11]=32'b01101100101111010000011011010001;
a0[12]=32'b10001001001110001100000101110100;
a0[13]=32'b00011100111110011010110111111111;
a0[14]=32'b10100010110001111000000101100101;
a0[15]=32'b11100110011100000100011010110100;
a0[16]=32'b00101100011110101011100000010011;
a0[17]=32'b00100010010100110010111000100010;
a0[18]=32'b10011010100010010110100111111110;
a0[19]=32'b00011011101100101101100000010011;
a0[20]=32'b11000010000101100111001111101100;
a0[21]=32'b00011011001000010010001001111110;
a0[22]=32'b00100110011010000010100110010001;
a0[23]=32'b11110001100100010110001101100101;
a0[24]=32'b00000000111101011001110000000001;
a0[25]=32'b00000000000000000000000000110111;
a0[26]=32'b00000000000000000000000011010101;

a1[0]=32'b10001011000000000000000000000000;
a1[1]=32'b11100111001101110000000000000000;
a1[2]=32'b00110011011110001111001000000000;
a1[3]=32'b01111011011100111001001100000110;
a1[4]=32'b00111010101011101010010011111011;
a1[5]=32'b01100111000011011110010100000000;
a1[6]=32'b01000110110000101100100010110001;
a1[7]=32'b10100101000001111010111111011110;
a1[8]=32'b01111010001001000110001111110001;
a1[9]=32'b11010001100000000000010100010100;
a1[10]=32'b11011010111110000111011011110010;
a1[11]=32'b11011111010000000100010101000100;
a1[12]=32'b00010101010110000110000110010110;
a1[13]=32'b11101001010111111011001101100100;
a1[14]=32'b10110100000000011001011000100010;
a1[15]=32'b10010111011110110100100001011100;
a1[16]=32'b00111100011101001010001001100011;
a1[17]=32'b01011100001111011000100111110001;
a1[18]=32'b10110011101010110011101110010110;
a1[19]=32'b10101011011101010100010001110100;
a1[20]=32'b00110000111011000001111101010111;
a1[21]=32'b11101111011100000100100000011011;
a1[22]=32'b11100101000000110011111010000000;
a1[23]=32'b00010100110010100011111000010100;
a1[24]=32'b00000000111010101111011111111111;
a1[25]=32'b00000000000000001110000101101011;
a1[26]=32'b00000000000000000000000001101100;

b0[0]=32'b01100011000000000000000000000000;
b0[1]=32'b11010000101000110000000000000000;
b0[2]=32'b01001101011110110111010100000000;
b0[3]=32'b11000100101001110010000100001000;
b0[4]=32'b01101101000011110001110001011111;
b0[5]=32'b10011011000101101000100010001111;
b0[6]=32'b00100101000011011010111010110001;
b0[7]=32'b01100110101111110100001001100100;
b0[8]=32'b11000110101101010011010100110000;
b0[9]=32'b10101111001001001100001110001111;
b0[10]=32'b10101110001101010000011110010000;
b0[11]=32'b11111011010101000100100111001011;
b0[12]=32'b10001101101111100001100101111011;
b0[13]=32'b11111100010111011001011001001100;
b0[14]=32'b00100011010011011101010111010101;
b0[15]=32'b10111001111110001011111111000110;
b0[16]=32'b00011100111011101100000111100000;
b0[17]=32'b11111111000010100011101101001001;
b0[18]=32'b00100101011000001010010011110010;
b0[19]=32'b10111111100110101101011100101100;
b0[20]=32'b10101100010111000001001001110101;
b0[21]=32'b10001001100000000011010011111110;
b0[22]=32'b00011000100010101001000000110100;
b0[23]=32'b00111001010111000100010001011001;
b0[24]=32'b00000000101111101101000100100101;
b0[25]=32'b00000000000000000110011101001001;
b0[26]=32'b00000000000000000000000011001001;

b1[0]=32'b01101000000000000000000000000000;
b1[1]=32'b01111101001011100000000000000000;
b1[2]=32'b10000110100100011101011100000000;
b1[3]=32'b01011001000101110101111001101010;
b1[4]=32'b10111110100100110001001111111101;
b1[5]=32'b00001100011010000001010001101101;
b1[6]=32'b01110110011000010001000100111101;
b1[7]=32'b10010101111011010101110100000101;
b1[8]=32'b11110001000011110110101111000101;
b1[9]=32'b01100110110111000111011001110111;
b1[10]=32'b11101111011001001001101101000100;
b1[11]=32'b00001110100010011110000010000100;
b1[12]=32'b10011100101000100110011110011000;
b1[13]=32'b10110101101100111011000110101001;
b1[14]=32'b01101111110111001111101100001010;
b1[15]=32'b11110010111011110110101100011111;
b1[16]=32'b10110000011000101010011000101010;
b1[17]=32'b11100101101101110001010110001100;
b1[18]=32'b11010001011101110100010000110011;
b1[19]=32'b11110001110000010101101010111010;
b1[20]=32'b11011111110110101011110001010110;
b1[21]=32'b11010011010000101010100000001110;
b1[22]=32'b11011011011101010101101000010110;
b1[23]=32'b00000100110110100011101000000001;
b1[24]=32'b00000000111010111100101010000000;
b1[25]=32'b00000000000000000111000011000100;
b1[26]=32'b00000000000000000000000001111100;
end

initial begin
	#(`End_CYCLE*`cycle_period);
	$display("-----------------------------------------------------\n");
	$display("Error!!! There is something wrong with your code ...!\n");
 	$display("------The test result is .....FAIL ------------------\n");
 	$display("-----------------------------------------------------\n");
 	$finish;
end

initial begin
    $readmemb("mat1.txt", mat1);
    $readmemb("mat2.txt", mat2);
    $readmemb("golden1.txt",golden1);
    $readmemb("golden2.txt",golden2);
    $readmemb("golden3.txt",golden3);

    #(`cycle_period);
    
	// data2sram;
	golden_transform;

	$write("|\n");
	$write("Three input groups of matrix\n");
	$write("|\n");
	display_data;  

	/////////////////////////////////////////////////////////
	
	// tpu_start = 1'b0;

	/////////////////////////////////////////////////////////

	
	//start to do CONV2 and POOL2, and write your result into sram a0 

	cycle_cnt = 0;
	#(`cycle_period/2) 
	reset = 0;
	input_valid = 1;
	output_ready = 1;
	#(`cycle_period)
	k=0;
	while(k<=26)begin  
		@(negedge clock);     begin
			sram_raddr = k;
			sram_rdata_a0 = a0[k];
			sram_rdata_a1 = a1[k];
			sram_rdata_b0 = b0[k];
			sram_rdata_b1 = b1[k];
			k++;
		end
		
	end
	input_finish = 1;
	// @(negedge clk);
	// srstn = 1'b0;
	// @(negedge clk);
	// srstn = 1'b1;
	// tpu_start = 1'b1;  //one-cycle pulse signal  
	// @(negedge clk);
	// tpu_start = 1'b0;
	while(my.state!=2'b10)begin    //it's mean that your sram c0, c1, c2 can be tested
		@(negedge clock);     begin
			cycle_cnt = cycle_cnt + 1;
		end
	end

	wout;//task
		$write("\n\n");
		wout2;//task


	// test our three sets of answer!!!
	// for(i = 0; i<(ARRAY_SIZE*2-1); i = i+1)begin
	// 	if(trans_golden1[i] == sram_16x128b_c0.mem[i]) $write("sram #c0 address: %d PASS!!\n", i[5:0]);
	// 	else begin
    //                 $write("You have wrong answer in the sram #c0 !!!\n\n");
    //                 $write("Your answer at address %d is \n%d %d %d %d %d %d %d %d \n",i[5:0],$signed(sram_16x128b_c0.mem[i][(ARRAY_SIZE*16-1)-:OUT_DATA_WIDTH]),$signed(sram_16x128b_c0.mem[i][((ARRAY_SIZE-1)*16-1)-:OUT_DATA_WIDTH]),$signed(sram_16x128b_c0.mem[i][((ARRAY_SIZE-2)*16-1)-:OUT_DATA_WIDTH]),$signed(sram_16x128b_c0.mem[i][((ARRAY_SIZE-3)*16-1)-:OUT_DATA_WIDTH]),$signed(sram_16x128b_c0.mem[i][((ARRAY_SIZE-4)*16-1)-:OUT_DATA_WIDTH]),$signed(sram_16x128b_c0.mem[i][((ARRAY_SIZE-5)*16-1)-:OUT_DATA_WIDTH]),$signed(sram_16x128b_c0.mem[i][((ARRAY_SIZE-6)*16-1)-:OUT_DATA_WIDTH]),$signed(sram_16x128b_c0.mem[i][((ARRAY_SIZE-7)*16-1)-:OUT_DATA_WIDTH]));
    //                 $write("But the golden answer is  \n%d %d %d %d %d %d %d %d \n",$signed(trans_golden1[i][((ARRAY_SIZE)*16-1)-:OUT_DATA_WIDTH]),$signed(trans_golden1[i][((ARRAY_SIZE-1)*16-1)-:OUT_DATA_WIDTH]),$signed(trans_golden1[i][((ARRAY_SIZE-2)*16-1)-:OUT_DATA_WIDTH]),$signed(trans_golden1[i][((ARRAY_SIZE-3)*16-1)-:OUT_DATA_WIDTH]),$signed(trans_golden1[i][((ARRAY_SIZE-4)*16-1)-:OUT_DATA_WIDTH]),$signed(trans_golden1[i][((ARRAY_SIZE-5)*16-1)-:OUT_DATA_WIDTH]),$signed(trans_golden1[i][((ARRAY_SIZE-6)*16-1)-:OUT_DATA_WIDTH]),$signed(trans_golden1[i][((ARRAY_SIZE-7)*16-1)-:OUT_DATA_WIDTH]));
    //                 $finish;
    //             end

	// end
	// for(i = 0; i<(ARRAY_SIZE*2-1); i = i+1)begin
	// 	if(trans_golden2[i] == sram_16x128b_c1.mem[i]) $write("sram #c1 address: %d PASS!!\n", i[5:0]);
	// 	else begin
    //                 $write("You have wrong answer in the sram #c1 !!!\n\n");
    //                 $write("Your answer at address %d is \n%d %d %d %d  \n",i[5:0],$signed(sram_16x128b_c1.mem[i][(ARRAY_SIZE*16-1)-:OUT_DATA_WIDTH]),$signed(sram_16x128b_c1.mem[i][((ARRAY_SIZE-1)*16-1)-:OUT_DATA_WIDTH]),$signed(sram_16x128b_c1.mem[i][((ARRAY_SIZE-2)*16-1)-:OUT_DATA_WIDTH]),$signed(sram_16x128b_c1.mem[i][((ARRAY_SIZE-3)*16-1)-:OUT_DATA_WIDTH]));
    //                 $write("But the golden answer is  \n%d %d %d %d \n",$signed(trans_golden2[i][(ARRAY_SIZE*16-1)-:OUT_DATA_WIDTH]),$signed(trans_golden2[i][((ARRAY_SIZE-1)*16-1)-:OUT_DATA_WIDTH]),$signed(trans_golden2[i][((ARRAY_SIZE-2)*16-1)-:OUT_DATA_WIDTH]),$signed(trans_golden2[i][((ARRAY_SIZE-3)*16-1)-:OUT_DATA_WIDTH]));
    //                 $finish;
    //             end

	// end
	// for(i = 0; i<(ARRAY_SIZE*2-1); i = i+1)begin
	// 	if(trans_golden3[i] == sram_16x128b_c2.mem[i]) $write("sram #c1 address: %d PASS!!\n", i[5:0]);
	// 	else begin
    //                 $write("You have wrong answer in the sram #c2 !!!\n\n");
    //                 $write("Your answer at address %d is \n%d %d %d %d  \n",i[5:0],$signed(sram_16x128b_c2.mem[i][(ARRAY_SIZE*16-1)-:OUT_DATA_WIDTH]),$signed(sram_16x128b_c2.mem[i][((ARRAY_SIZE-1)*16-1)-:OUT_DATA_WIDTH]),$signed(sram_16x128b_c2.mem[i][((ARRAY_SIZE-2)*16-1)-:OUT_DATA_WIDTH]),$signed(sram_16x128b_c2.mem[i][((ARRAY_SIZE-3)*16-1)-:OUT_DATA_WIDTH]));
    //                 $write("But the golden answer is  \n%d %d %d %d \n",$signed(trans_golden3[i][(ARRAY_SIZE*16-1)-:OUT_DATA_WIDTH]),$signed(trans_golden3[i][((ARRAY_SIZE-1)*16-1)-:OUT_DATA_WIDTH]),$signed(trans_golden3[i][((ARRAY_SIZE-2)*16-1)-:OUT_DATA_WIDTH]),$signed(trans_golden3[i][((ARRAY_SIZE-3)*16-1)-:OUT_DATA_WIDTH]));
    //                 $finish;
    //             end

	// end
      
    $display("Total cycle count C after three matrix evaluation = %d.", cycle_cnt);
    #5 $finish;
end

task wout;
integer this_i, this_j, this_k;
	for(this_k=0; this_k<15;this_k = this_k +1)begin	  
		for(this_i=ARRAY_SIZE;this_i>0;this_i=this_i-1) begin
            		$write("%d ", $signed(my.mem_c0[this_k][(this_i*OUT_DATA_WIDTH-1) -: OUT_DATA_WIDTH]));
        	end
		$write("\n\n");
	end

endtask
task wout2;
integer this_i, this_j, this_k;
	for(this_k=0; this_k<8;this_k = this_k +1)begin	  
		for(this_i=ARRAY_SIZE;this_i>0;this_i=this_i-1) begin
            		$write("%h ", $signed(golden1[this_k][(this_i*OUT_DATA_WIDTH-1) -: OUT_DATA_WIDTH]));
        	end
		$write("\n\n");
	end
endtask

// task data2sram;
//   begin
// 	// reset tmp_mat1, tmp_mat2, tmp_c_mat1, tmp_c_mat2
// 	for(i = 0; i< ARRAY_SIZE ; i = i + 1) begin
// 		tmp_c_mat1[i] = 0;
// 		tmp_c_mat2[i] = 0;
// 		tmp_mat1[i] = 0;
// 		tmp_mat2[i] = 0;
// 	end	
// 	// combine three batch together into tmp_mat1, tmp_mat2
// 	for(i = 0; i< 3 ; i = i + 1) begin
// 		for(j = 0; j< ARRAY_SIZE; j = j+1)begin
// 			tmp_c_mat1[j] = {mat1[ARRAY_SIZE*i+j], tmp_c_mat1[j][(ARRAY_SIZE*3*DATA_WIDTH-1) -: 2*DATA_WIDTH*ARRAY_SIZE]};
// 			tmp_c_mat2[j] = {mat2[ARRAY_SIZE*i+j], tmp_c_mat2[j][(ARRAY_SIZE*3*DATA_WIDTH-1) -: 2*DATA_WIDTH*ARRAY_SIZE]};
// 		end
// 		$write("%b\n%b\n", tmp_c_mat1[0], mat1[ARRAY_SIZE*i]);
// 	end
// 	$write("\n\n");
// 	for(i = 0; i< ARRAY_SIZE ; i = i + 1) begin
// 		case (i % 4)
// 			0 : begin
// 				tmp_mat1[i] = {24'b0, tmp_c_mat1[i]};
// 				tmp_mat2[i] = {24'b0, tmp_c_mat2[i]};
// 			    end
// 			1 : begin
// 				tmp_mat1[i] = {16'b0, tmp_c_mat1[i], 8'b0};
// 				tmp_mat2[i] = {16'b0, tmp_c_mat2[i], 8'b0};
// 			    end
// 			2 : begin
// 				tmp_mat1[i] = {8'b0, tmp_c_mat1[i], 16'b0};
// 				tmp_mat2[i] = {8'b0, tmp_c_mat2[i], 16'b0};
// 			    end
// 			3 : begin
// 				tmp_mat1[i] = {tmp_c_mat1[i], 24'b0};
// 				tmp_mat2[i] = {tmp_c_mat2[i], 24'b0};
// 			    end
// 			default : begin
// 					tmp_mat1[i] = 0;
// 					tmp_mat2[i] = 0;
// 				  end
// 		endcase
// 	end
// 	$write("%b\n", tmp_mat1[0]);
	
// 	for(i = 0; i < 128; i=i+1)begin
// 		if(i < (ARRAY_SIZE*3+3))begin
// 		sram_128x32b_a0.char2sram(i,{tmp_mat1[0][(DATA_WIDTH*(i+1)-1) -: DATA_WIDTH], tmp_mat1[1][(DATA_WIDTH*(i+1)-1) -: DATA_WIDTH], tmp_mat1[2][(DATA_WIDTH*(i+1)-1) -: DATA_WIDTH], tmp_mat1[3][(DATA_WIDTH*(i+1)-1) -: DATA_WIDTH]});
// 		sram_128x32b_a1.char2sram(i,{tmp_mat1[4][(DATA_WIDTH*(i+1)-1) -: DATA_WIDTH], tmp_mat1[5][(DATA_WIDTH*(i+1)-1) -: DATA_WIDTH], tmp_mat1[6][(DATA_WIDTH*(i+1)-1) -: DATA_WIDTH], tmp_mat1[7][(DATA_WIDTH*(i+1)-1) -: DATA_WIDTH]});
		
// 		sram_128x32b_b0.char2sram(i,{tmp_mat2[0][(DATA_WIDTH*(i+1)-1) -: DATA_WIDTH], tmp_mat2[1][(DATA_WIDTH*(i+1)-1) -: DATA_WIDTH], tmp_mat2[2][(DATA_WIDTH*(i+1)-1) -: DATA_WIDTH], tmp_mat2[3][(DATA_WIDTH*(i+1)-1) -: DATA_WIDTH]});
// 		sram_128x32b_b1.char2sram(i,{tmp_mat2[4][(DATA_WIDTH*(i+1)-1) -: DATA_WIDTH], tmp_mat2[5][(DATA_WIDTH*(i+1)-1) -: DATA_WIDTH], tmp_mat2[6][(DATA_WIDTH*(i+1)-1) -: DATA_WIDTH], tmp_mat2[7][(DATA_WIDTH*(i+1)-1) -: DATA_WIDTH]});
// 		end
// 		else begin
// 			sram_128x32b_a0.char2sram(i, 32'b0);
// 			sram_128x32b_a1.char2sram(i, 32'b0);

// 			sram_128x32b_b0.char2sram(i, 32'b0);
// 			sram_128x32b_b1.char2sram(i, 32'b0);
// 		end

// 	end
// 	// $write("SRAM a0!!!!\n");
// 	// for(i = 0; i< 30 ; i = i + 1) begin
//     //                 $write("SRAM at address %d is \n%d %d %d %d",i[7:0],$signed(sram_128x32b_a0.mem[i][31:24]),$signed(sram_128x32b_a0.mem[i][23:16]),$signed(sram_128x32b_a0.mem[i][15:8]),$signed(sram_128x32b_a0.mem[i][7:0]));
// 	// 				$write(" %d %d %d %d  \n",$signed(sram_128x32b_a1.mem[i][31:24]),$signed(sram_128x32b_a1.mem[i][23:16]),$signed(sram_128x32b_a1.mem[i][15:8]),$signed(sram_128x32b_a1.mem[i][7:0]));
// 	// end
// 	// $write("SRAM b0!!!!\n");
// 	// for(i = 0; i< 30 ; i = i + 1) begin
//     //                 $write("SRAM at address %d is \n%d %d %d %d",i[7:0],$signed(sram_128x32b_b0.mem[i][31:24]),$signed(sram_128x32b_b0.mem[i][23:16]),$signed(sram_128x32b_b0.mem[i][15:8]),$signed(sram_128x32b_b0.mem[i][7:0]));
// 	// 				$write(" %d %d %d %d  \n",$signed(sram_128x32b_b1.mem[i][31:24]),$signed(sram_128x32b_b1.mem[i][23:16]),$signed(sram_128x32b_b1.mem[i][15:8]),$signed(sram_128x32b_b1.mem[i][7:0]));
// 	// end
// 	$write("uint32_t a0[128] = {\n");
// 	for(i = 0; i< 26 ; i = i + 1) $write("0b%b,\n",sram_128x32b_a0.mem[i]);
// 	$write("0b%b};\n\n",sram_128x32b_a0.mem[26]);

// 	$write("uint32_t a1[128] = {\n");
// 	for(i = 0; i< 26 ; i = i + 1) $write("0b%b,\n",sram_128x32b_a1.mem[i]);
// 	$write("0b%b};\n\n",sram_128x32b_a1.mem[26]);

// 	$write("uint32_t b0[128] = {\n");
// 	for(i = 0; i< 26 ; i = i + 1) $write("0b%b,\n",sram_128x32b_b0.mem[i]);
// 	$write("0b%b};\n\n",sram_128x32b_b0.mem[26]);

// 	$write("uint32_t b1[128] = {\n");
// 	for(i = 0; i< 26 ; i = i + 1) $write("0b%b,\n",sram_128x32b_b1.mem[i]);
// 	$write("0b%b};\n\n",sram_128x32b_b1.mem[26]);
//   end
// endtask	


//display the mnist image in 28x28 SRAM
task display_data;
integer this_i, this_j, this_k;
    begin
	for(this_k=0; this_k<3;this_k = this_k +1)begin
		$write("------------------------\n");
        	for(this_i=0;this_i<ARRAY_SIZE;this_i=this_i+1) begin
            		for(this_j=0;this_j<ARRAY_SIZE;this_j=this_j+1) begin
               			$write("%d",mat1[this_i][this_j]);
				$write(" ");
            		end
            		$write("\n");
        	end
		$write("\n");
        	for(this_i=0;this_i<ARRAY_SIZE;this_i=this_i+1) begin
            		for(this_j=0;this_j<ARRAY_SIZE;this_j=this_j+1) begin
               			$write("%d",mat2[this_i][this_j]);
				$write(" ");
            		end
            		$write("\n");
        	end
		$write("------------------------\n");
            	$write("\n");
	end
    end
endtask

task golden_transform;
integer this_i, this_j, this_k;
  begin
	for(this_k=0; this_k<(ARRAY_SIZE*2-1);this_k = this_k +1)begin	  
		trans_golden1[this_k] = 0;
		trans_golden2[this_k] = 0;
		trans_golden3[this_k] = 0;
	end
	for(this_k=0; this_k<(ARRAY_SIZE*2-1);this_k = this_k +1)begin	  
		for(this_i=0;this_i<ARRAY_SIZE;this_i=this_i+1) begin
            		for(this_j=0;this_j<ARRAY_SIZE;this_j=this_j+1) begin
				if((this_i+this_j)==this_k)begin
					trans_golden1[this_k] = {golden1[this_i][((this_j+1)*OUT_DATA_WIDTH-1) -: OUT_DATA_WIDTH], trans_golden1[this_k][(8*16-1)-:(7*OUT_DATA_WIDTH)]};
					trans_golden2[this_k] = {golden2[this_i][((this_j+1)*OUT_DATA_WIDTH-1) -: OUT_DATA_WIDTH], trans_golden2[this_k][(8*16-1)-:(7*OUT_DATA_WIDTH)]};
					trans_golden3[this_k] = {golden3[this_i][((this_j+1)*OUT_DATA_WIDTH-1) -: OUT_DATA_WIDTH], trans_golden3[this_k][(8*16-1)-:(7*OUT_DATA_WIDTH)]};
				end 
            		end
        	end
	end

	$write("Here shows the trans_golden1!!!\n");
	for(this_k=0; this_k<(ARRAY_SIZE*2-1);this_k = this_k +1)begin	  
		for(this_i=ARRAY_SIZE;this_i>0;this_i=this_i-1) begin
            		$write("%d ", $signed(trans_golden1[this_k][(this_i*OUT_DATA_WIDTH-1) -: OUT_DATA_WIDTH]));
        	end
		$write("\n\n");
	end

	

	$write("uint64_t trans_golden1[14] = {\n");
	for(i = 0; i< 14 ; i = i + 1) $write("0b%b,\n",trans_golden1[i]);
	$write("0b%b};\n\n",trans_golden1[14]);

	$write("uint64_t trans_golden2[14] = {\n");
	for(i = 0; i< 14 ; i = i + 1) $write("0b%b,\n",trans_golden2[i]);
	$write("0b%b};\n\n",trans_golden2[14]);

	$write("uint64_t trans_golden3[14] = {\n");
	for(i = 0; i< 14 ; i = i + 1) $write("0b%b,\n",trans_golden3[i]);
	$write("0b%b};\n\n",trans_golden3[14]);

  end
endtask 





endmodule
