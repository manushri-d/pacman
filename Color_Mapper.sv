//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input [7:0] keycode, input [9:0] BallX, BallY, DrawX, DrawY, Ball_size, //input logic [2:0] movedir, 
							blueghostX, blueghostY, pinkghostX, pinkghostY, redghostX, redghostY, yellowghostX, yellowghostY,
								input vga_clk, Reset, input logic starton, playon, gameoveron, input logic [1:0] animationselect, whichside,//ogic halfopenon, fullopenon, closedon, 
                       output logic [7:0]  Red, Green, Blue,
							  output logic leftwall, rightwall, upwall, downwall, isGameOver); //, bleftwall, brightwall, bupwall, bdownwall
	logic [8:0] yellow_rom_address;
	logic [4:0] yellow_rom_q;
	logic [3:0] yellow_palette_red, yellow_palette_green, yellow_palette_blue;
	logic yellow_negedge_vga_clk;
	assign yellow_negedge_vga_clk = ~vga_clk;
	assign yellow_rom_address = (DrawX-yellowghostX) + (DrawY-yellowghostY)*20;
	
	logic [8:0] red_rom_address;
	logic [4:0] red_rom_q;
	logic [3:0] red_palette_red, red_palette_green, red_palette_blue;
	logic red_negedge_vga_clk;
	assign red_negedge_vga_clk = ~vga_clk;
	assign red_rom_address = (DrawX-redghostX) + (DrawY-redghostY)*20;
	
	logic [8:0] pink_rom_address;
	logic [4:0] pink_rom_q;
	logic [3:0] pink_palette_red, pink_palette_green, pink_palette_blue;
	logic pink_negedge_vga_clk;
	assign pink_negedge_vga_clk = ~vga_clk;
	assign pink_rom_address = (DrawX-pinkghostX) + (DrawY-pinkghostY)*20;

	logic [8:0] blue_rom_address;
	logic [4:0] blue_rom_q;
	logic [3:0] blue_palette_red, blue_palette_green, blue_palette_blue;
	logic blue_negedge_vga_clk;
	assign blue_negedge_vga_clk = ~vga_clk;
	assign blue_rom_address = (DrawX-blueghostX) + (DrawY-blueghostY)*20;

	logic [16:0] gameover_rom_address;
	logic [4:0] gameover_rom_q;
	logic [3:0] gameover_palette_red, gameover_palette_green, gameover_palette_blue;
	logic gameover_negedge_vga_clk;
	assign gameover_negedge_vga_clk = ~vga_clk;
	assign gameover_rom_address = ((DrawX * 320) / 640) + (((DrawY * 240) / 480) * 320);
	
	logic [16:0] startscreen_rom_address;
	logic [4:0] startscreen_rom_q;
	logic [3:0] startscreen_palette_red, startscreen_palette_green, startscreen_palette_blue;
	logic startscreen_negedge_vga_clk;
	assign startscreen_negedge_vga_clk = ~vga_clk;
	// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
	// this will stretch out the sprite across the entire screen
	assign startscreen_rom_address = ((DrawX * 320) / 640) + (((DrawY * 240) / 480) * 320);
	
	
	
	logic [16:0] bitrom_address;
	logic [3:0] bitrom_q;//, Leftwall, Rightwall, Upwall, Downwall;
	logic bitnegedge_vga_clk;
	// read from ROM on negedge, set pixel on posedge
	assign bitnegedge_vga_clk = ~vga_clk;
	
	
	logic [16:0] gbitrom_address;
	logic [3:0] gbitrom_q;//, Leftwall, Rightwall, Upwall, Downwall;
	logic gbitnegedge_vga_clk;
	// read from ROM on negedge, set pixel on posedge
	assign gbitnegedge_vga_clk = ~vga_clk;
	// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
	// this will stretch out the sprite across the entire screen
	//assign bitrom_address = ((DrawX * 320) / 640) + (((DrawY * 240) / 480) * 320);
	logic [16:0] background_rom_address;
	logic [4:0] brom_q;
	logic [3:0] bpalette_red, bpalette_green, bpalette_blue;
	logic bnegedge_vga_clk;
	// read from ROM on negedge, set pixel on posedge
	assign bnegedge_vga_clk = ~vga_clk;
	// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
	// this will stretch out the sprite across the entire screen
	assign background_rom_address = ((DrawX * 320) / 640) + (((DrawY * 240) / 480) * 320);
				 
   logic [123:0] doton, dotoff;
   logic ball_on, bghost_on, pghost_on, rghost_on, yghost_on;
	logic [10:0] rom_address;
	logic [9:0] rom_q;
	logic [3:0] palette_red, palette_green, palette_blue;
	logic negedge_vga_clk;
// read from ROM on negedge, set pixel on posedge
	assign negedge_vga_clk = ~vga_clk;
// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
// this will stretch out the sprite across the entire screen
//assign rom_address = ((DrawX * 35) / 640) + (((DrawY * 35) / 480) * 35);
// assign rom_address = ((DrawX * 35) / (640/4)) + (((DrawY * 35) / (480/4)) * 35);
	//assign rom_address = DrawY*35 + DrawX;
	//assign rom_address = (DrawY)*20 + (DrawX);
	always_comb begin//ff @ ( posedge Reset or posedge vga_clk) begin
				if(keycode == 8'h04) //A this works
				begin
					rom_address = (DrawX-BallX) + (DrawY-BallY)*20; //facing left
					fullyopen_rom_address = (DrawX-BallX) + (DrawY-BallY)*20; //facing left
					closed_rom_address = (DrawX-BallX) + (DrawY-BallY)*20; //facing left
				end
				else if(keycode == 8'h07) //D
				begin
					rom_address = (BallX-DrawX-12) + (BallY-DrawY-5)*20; //facing right
					fullyopen_rom_address = (BallX-DrawX-12) + (BallY-DrawY-7)*20; //facing right
					closed_rom_address = (BallX-DrawX-12) + (BallY-DrawY-7)*20; //facing right
				end	
				else if(keycode == 8'h16) //S 
				begin
					rom_address = (BallX-DrawX-5)*20 + (BallY-DrawY-12); //facing down
					fullyopen_rom_address = (BallX-DrawX-7)*20 + (BallY-DrawY-12); //facing down
					closed_rom_address = (BallX-DrawX-7)*20 + (BallY-DrawY-12); //facing down
				end
				else if(keycode == 8'h1A) //W 
				begin
					rom_address = (DrawX-BallX)*20 + (DrawY-BallY); //facing up
					fullyopen_rom_address = (DrawX-BallX)*20 + (DrawY-BallY); //facing up
					closed_rom_address = (DrawX-BallX)*20 + (DrawY-BallY); //facing up
				end
				else
				begin
					if(whichside == 2'b11) begin //W
						rom_address = (DrawX-BallX)*20 + (DrawY-BallY); //facing up
						fullyopen_rom_address = (DrawX-BallX)*20 + (DrawY-BallY); //facing up
						closed_rom_address = (DrawX-BallX)*20 + (DrawY-BallY); //facing up
					end
					if(whichside == 2'b01) begin //D
						rom_address = (BallX-DrawX-12) + (BallY-DrawY-5)*20; //facing right
						fullyopen_rom_address = (BallX-DrawX-12) + (BallY-DrawY-7)*20; //facing right
						closed_rom_address = (BallX-DrawX-12) + (BallY-DrawY-7)*20; //facing right
					end
					if(whichside == 2'b10) begin //S
						rom_address = (BallX-DrawX-5)*20 + (BallY-DrawY-12); //facing down
						fullyopen_rom_address = (BallX-DrawX-7)*20 + (BallY-DrawY-12); //facing down
						closed_rom_address = (BallX-DrawX-7)*20 + (BallY-DrawY-12); //facing down
					end
					else begin //A
						rom_address = (DrawX-BallX) + (DrawY-BallY)*20; //facing left
						fullyopen_rom_address = (DrawX-BallX) + (DrawY-BallY)*20; //facing left
						closed_rom_address = (DrawX-BallX) + (DrawY-BallY)*20; //facing left
					end
				end
//				if(Reset) begin
//					
//				end
//				else if(starton)begin
//					
//				end
//				else begin
//					
//				end	
			 end
	//assign rom_address = (DrawX-BallX) + (DrawY-BallY)*20; //facing left
	logic [8:0] fullyopen_rom_address;
	logic [4:0] fullyopen_rom_q;
	logic [3:0] fullyopen_palette_red, fullyopen_palette_green, fullyopen_palette_blue;
	logic fullyopen_negedge_vga_clk;
	assign fullyopen_negedge_vga_clk = ~vga_clk;
	//assign fullyopen_rom_address = (DrawX-BallX) + (DrawY-BallY)*20; //facing left
	
	logic [8:0] closed_rom_address;
	logic [4:0] closed_rom_q;
	logic [3:0] closed_palette_red, closed_palette_green, closed_palette_blue;
	logic closed_negedge_vga_clk;
	assign closed_negedge_vga_clk = ~vga_clk;
	//assign closed_rom_address = (DrawX-BallX) + (DrawY-BallY)*20; //facing left
//	 always_ff @ (posedge vga_clk) begin
//	Red <= 4'h0;
//	Green <= 4'h0;
//	Blue <= 4'h0;
//
//	if (temppac) begin
//		Red <= palette_red;
//		Green <= palette_green;
//		Blue <= palette_blue;
//	end
//end
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
//    int DistX, DistY, Size;
//	 assign DistX = DrawX - BallX;
//    assign DistY = DrawY - BallY;
//    assign Size = Ball_size;
	 
	 int DistX, DistY, Size;
	 assign DistX = DrawX - BallX;
    assign DistY = DrawY - BallY;
    assign Size = 20;
	 always_comb
    begin:Ball_on_proc
       if ((DrawX >= BallX) &&
       (DrawX <= BallX + Size) &&
       (DrawY >= BallY) &&
       (DrawY <= BallY + Size))
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
     end
	  
	  int ghostS;
	//assign ghostdistX = DrawX - blueghostX;
    //assign ghostdistY = DrawY - blueghostY;
    assign ghostS = 20;
	 always_comb
    begin:blueghost_on_proc
       if ((DrawX >= blueghostX) &&
       (DrawX <= blueghostX + ghostS) &&
       (DrawY >= blueghostY) &&
       (DrawY <= blueghostY + ghostS))
            bghost_on = 1'b1;
        else 
            bghost_on = 1'b0;
     end
	  
	  always_comb
    begin:pinkghost_on_proc
       if ((DrawX >= pinkghostX) &&
       (DrawX <= pinkghostX + ghostS) &&
       (DrawY >= pinkghostY) &&
       (DrawY <= pinkghostY + ghostS))
            pghost_on = 1'b1;
        else 
            pghost_on = 1'b0;
     end
	 
	 always_comb
    begin:redghost_on_proc
       if ((DrawX >= redghostX) &&
       (DrawX <= redghostX + ghostS) &&
       (DrawY >= redghostY) &&
       (DrawY <= redghostY + ghostS))
            rghost_on = 1'b1;
        else 
            rghost_on = 1'b0;
     end
	  
	  always_comb
    begin:yellowghost_on_proc
       if ((DrawX >= yellowghostX) &&
       (DrawX <= yellowghostX + ghostS) &&
       (DrawY >= yellowghostY) &&
       (DrawY <= yellowghostY + ghostS))
            yghost_on = 1'b1;
        else 
            yghost_on = 1'b0;
     end
	  
	 int DistXv [124];
	 int DistYv [124];
	 assign DistXv[0] = DrawX - 10'd40;
	 assign DistYv[0] = DrawY - 10'd227;
	 
	 assign DistXv[1] = DrawX - 10'd80;
	 assign DistYv[1]= DrawY - 10'd227;
	 
	 assign DistXv[2] = DrawX - 10'd120;
	 assign DistYv[2] = DrawY - 10'd227;

	 assign DistXv[3] = DrawX - 10'd160;
	 assign DistYv[3] = DrawY - 10'd227;

	 assign DistXv[4] = DrawX - 10'd200;
	 assign DistYv[4] = DrawY - 10'd227;

	 assign DistXv[5] = DrawX - 10'd500;
	 assign DistYv[5] = DrawY - 10'd227;

	 assign DistXv[6] = DrawX - 10'd460;
	 assign DistYv[6] = DrawY - 10'd227;

	 assign DistXv[7] = DrawX - 10'd420;
	 assign DistYv[7] = DrawY - 10'd227;

	 assign DistXv[8] = DrawX - 10'd540;
	 assign DistYv[8] = DrawY - 10'd227;
	 
	 assign DistXv[9] = DrawX - 10'd160;
	 assign DistYv[9] = DrawY - 10'd187;

	 assign DistXv[10] = DrawX - 10'd220;
	 assign DistYv[10] = DrawY - 10'd187;

	 assign DistXv[11] = DrawX - 10'd260;
	 assign DistYv[11] = DrawY - 10'd187;

	 assign DistXv[12] = DrawX - 10'd300;
	 assign DistYv[12] = DrawY - 10'd187;

	 assign DistXv[13] = DrawX - 10'd340;
	 assign DistYv[13] = DrawY - 10'd187;

	 assign DistXv[14] = DrawX - 10'd380;
	 assign DistYv[14] = DrawY - 10'd187;

	 assign DistXv[15] = DrawX - 10'd420;
	 assign DistYv[15] = DrawY - 10'd187;

	 assign DistXv[16] = DrawX - 10'd480;
	 assign DistYv[16] = DrawY - 10'd187;

	 assign DistXv[17] = DrawX - 10'd40;
	 assign DistYv[17] = DrawY - 10'd147;

	 assign DistXv[18] = DrawX - 10'd80;
	 assign DistYv[18] = DrawY - 10'd147;

	 assign DistXv[19] = DrawX - 10'd120;
	 assign DistYv[19] = DrawY - 10'd147;

	 assign DistXv[20] = DrawX - 10'd160;
	 assign DistYv[20] = DrawY - 10'd147;
	 
	 assign DistXv[21] = DrawX - 10'd220; 
	 assign DistYv[21] = DrawY - 10'd147;
	 
	 assign DistXv[22] = DrawX - 10'd260; 
	 assign DistYv[22] = DrawY - 10'd147;
	 
	 assign DistXv[23] = DrawX - 10'd300; 
	 assign DistYv[23] = DrawY - 10'd147;
	 
	 assign DistXv[24] = DrawX - 10'd340; 
	 assign DistYv[24] = DrawY - 10'd147;	 
	 
	 assign DistXv[25] = DrawX - 10'd380; 
	 assign DistYv[25] = DrawY - 10'd147;
	 
	 assign DistXv[26] = DrawX - 10'd420; 
	 assign DistYv[26] = DrawY - 10'd147;
	 
	 assign DistXv[27] = DrawX - 10'd180; 
	 assign DistYv[27] = DrawY - 10'd107;
	 
	 assign DistXv[28] = DrawX - 10'd500; 
	 assign DistYv[28] = DrawY - 10'd147;
	 
	 assign DistXv[29] = DrawX - 10'd540; 
	 assign DistYv[29] = DrawY - 10'd147;
	 
	 assign DistXv[30] = DrawX - 10'd580; 
	 assign DistYv[30] = DrawY - 10'd147;
	 
	 assign DistXv[31] = DrawX - 10'd100; 
	 assign DistYv[31] = DrawY - 10'd47;
	 
	 assign DistXv[32] = DrawX - 10'd140; 
	 assign DistYv[32] = DrawY - 10'd47;
	 
	 assign DistXv[33] = DrawX - 10'd580; 
	 assign DistYv[33] = DrawY - 10'd107;
	 
	 assign DistXv[34] = DrawX - 10'd540; 
	 assign DistYv[34] = DrawY - 10'd107;
	 
	 assign DistXv[35] = DrawX - 10'd500; 
	 assign DistYv[35] = DrawY - 10'd107;
	 
	 assign DistXv[36] = DrawX - 10'd460; 
	 assign DistYv[36] = DrawY - 10'd107;
	 
	 assign DistXv[37] = DrawX - 10'd420; 
	 assign DistYv[37] = DrawY - 10'd107;
	 
	 assign DistXv[38] = DrawX - 10'd380; 
	 assign DistYv[38] = DrawY - 10'd107;
	 
	 assign DistXv[39] = DrawX - 10'd340; 
	 assign DistYv[39] = DrawY - 10'd107;
	 
	 assign DistXv[40] = DrawX - 10'd300; 
	 assign DistYv[40] = DrawY - 10'd107;
	 
	 assign DistXv[41] = DrawX - 10'd260; 
	 assign DistYv[41] = DrawY - 10'd107;
	 
	 assign DistXv[42] = DrawX - 10'd220; 
	 assign DistYv[42] = DrawY - 10'd107;
	 
	 assign DistXv[43] = DrawX - 10'd140; 
	 assign DistYv[43] = DrawY - 10'd107;
	 
	 assign DistXv[44] = DrawX - 10'd100; 
	 assign DistYv[44] = DrawY - 10'd107;
	 
	 assign DistXv[45] = DrawX - 10'd60; 
	 assign DistYv[45] = DrawY - 10'd107;
	 
	 assign DistXv[46] = DrawX - 10'd60; 
	 assign DistYv[46] = DrawY - 10'd77;
	 
	 assign DistXv[47] = DrawX - 10'd160; 
	 assign DistYv[47] = DrawY - 10'd77;
	 
	 assign DistXv[48] = DrawX - 10'd290; 
	 assign DistYv[48] = DrawY - 10'd77;
	 
	 assign DistXv[49] = DrawX - 10'd350; 
	 assign DistYv[49] = DrawY - 10'd77;
	 
	 assign DistXv[50] = DrawX - 10'd480; 
	 assign DistYv[50] = DrawY - 10'd77;
	 
	 assign DistXv[51] = DrawX - 10'd580; 
	 assign DistYv[51] = DrawY - 10'd77;
	 
	 assign DistXv[52] = DrawX - 10'd60; 
	 assign DistYv[52] = DrawY - 10'd47;
	 
	 assign DistXv[53] = DrawX - 10'd580; 
	 assign DistYv[53] = DrawY - 10'd47;
	 
	 assign DistXv[54] = DrawX - 10'd540; 
	 assign DistYv[54] = DrawY - 10'd47;
	 
	 assign DistXv[55] = DrawX - 10'd500; 
	 assign DistYv[55] = DrawY - 10'd47;
	 
	 assign DistXv[56] = DrawX - 10'd460; 
	 assign DistYv[56] = DrawY - 10'd47;
	 
	 assign DistXv[57] = DrawX - 10'd420; 
	 assign DistYv[57] = DrawY - 10'd47;
	 
	 assign DistXv[58] = DrawX - 10'd380; 
	 assign DistYv[58] = DrawY - 10'd47;
	 
	 assign DistXv[59] = DrawX - 10'd350; 
	 assign DistYv[59] = DrawY - 10'd47;
	 
	 assign DistXv[60] = DrawX - 10'd290; 
	 assign DistYv[60] = DrawY - 10'd47;
	 
	 assign DistXv[61] = DrawX - 10'd260; 
	 assign DistYv[61] = DrawY - 10'd47;
	 
	 assign DistXv[62] = DrawX - 10'd220; 
	 assign DistYv[62] = DrawY - 10'd47;
	 //bottom half
	 assign DistXv[63] = DrawX - 10'd160;
	 assign DistYv[63] = DrawY - 10'd267;
	 
	 assign DistXv[64] = DrawX - 10'd220;
	 assign DistYv[64] = DrawY - 10'd267;

	 assign DistXv[65] = DrawX - 10'd260;
	 assign DistYv[65] = DrawY - 10'd267;

	 assign DistXv[66] = DrawX - 10'd300;
	 assign DistYv[66] = DrawY - 10'd267;

	 assign DistXv[67] = DrawX - 10'd340;
	 assign DistYv[67] = DrawY - 10'd267;

	 assign DistXv[68] = DrawX - 10'd380;
	 assign DistYv[68] = DrawY - 10'd267;

	 assign DistXv[69] = DrawX - 10'd420;
	 assign DistYv[69] = DrawY - 10'd267;

	 assign DistXv[70] = DrawX - 10'd480;
	 assign DistYv[70] = DrawY - 10'd267;
	 //top
	 assign DistXv[71] = DrawX - 10'd180;
	 assign DistYv[71] = DrawY - 10'd47;
	 
	 //bottom
	 assign DistXv[72] = DrawX - 10'd580; 
	 assign DistYv[72] = DrawY - 10'd307;
	 
	 assign DistXv[73] = DrawX - 10'd540; 
	 assign DistYv[73] = DrawY - 10'd307;
	 
	 assign DistXv[74] = DrawX - 10'd500; 
	 assign DistYv[74] = DrawY - 10'd307;
	 
	 assign DistXv[75] = DrawX - 10'd460; 
	 assign DistYv[75] = DrawY - 10'd307;
	 
	 assign DistXv[76] = DrawX - 10'd420; 
	 assign DistYv[76] = DrawY - 10'd307;
	 
	 assign DistXv[77] = DrawX - 10'd380; 
	 assign DistYv[77] = DrawY - 10'd307;
	 
	 assign DistXv[78] = DrawX - 10'd340; 
	 assign DistYv[78] = DrawY - 10'd307;
	 
	 assign DistXv[79] = DrawX - 10'd300; 
	 assign DistYv[79] = DrawY - 10'd307;
	 
	 assign DistXv[80] = DrawX - 10'd260; 
	 assign DistYv[80] = DrawY - 10'd307;
	 
	 assign DistXv[81] = DrawX - 10'd220; 
	 assign DistYv[81] = DrawY - 10'd307;
	 
	 assign DistXv[82] = DrawX - 10'd140; 
	 assign DistYv[82] = DrawY - 10'd307;
	 
	 assign DistXv[83] = DrawX - 10'd100; 
	 assign DistYv[83] = DrawY - 10'd307;
	 
	 assign DistXv[84] = DrawX - 10'd60; 
	 assign DistYv[84] = DrawY - 10'd307;
	 //next
	 assign DistXv[85] = DrawX - 10'd580; 
	 assign DistYv[85] = DrawY - 10'd347;
	 
	 assign DistXv[86] = DrawX - 10'd540; 
	 assign DistYv[86] = DrawY - 10'd347;
	 
	 assign DistXv[87] = DrawX - 10'd180; //chsngd
	 assign DistYv[87] = DrawY - 10'd307;
	 
	 assign DistXv[88] = DrawX - 10'd460; 
	 assign DistYv[88] = DrawY - 10'd347;
	 
	 assign DistXv[89] = DrawX - 10'd420; 
	 assign DistYv[89] = DrawY - 10'd347;
	 
	 assign DistXv[90] = DrawX - 10'd380; 
	 assign DistYv[90] = DrawY - 10'd347;
	 
	 assign DistXv[91] = DrawX - 10'd340; 
	 assign DistYv[91] = DrawY - 10'd347;
	 
	 assign DistXv[92] = DrawX - 10'd300; 
	 assign DistYv[92] = DrawY - 10'd347;
	 
	 assign DistXv[93] = DrawX - 10'd260; 
	 assign DistYv[93] = DrawY - 10'd347;
	 
	 assign DistXv[94] = DrawX - 10'd220; 
	 assign DistYv[94] = DrawY - 10'd347;
	 
	 assign DistXv[95] = DrawX - 10'd160; 
	 assign DistYv[95] = DrawY - 10'd347;
	 
	 assign DistXv[96] = DrawX - 10'd100; 
	 assign DistYv[96] = DrawY - 10'd347;
	 
	 assign DistXv[97] = DrawX - 10'd60; 
	 assign DistYv[97] = DrawY - 10'd347;
	 //next
	 assign DistXv[98] = DrawX - 10'd580; 
	 assign DistYv[98] = DrawY - 10'd387;
	 
	 assign DistXv[99] = DrawX - 10'd540; 
	 assign DistYv[99] = DrawY - 10'd387;
	 
	 assign DistXv[100] = DrawX - 10'd500; 
	 assign DistYv[100] = DrawY - 10'd387;
	 
	 assign DistXv[101] = DrawX - 10'd180; //chanfed 
	 assign DistYv[101] = DrawY - 10'd427;
	 
	 assign DistXv[102] = DrawX - 10'd420; 
	 assign DistYv[102] = DrawY - 10'd387;
	 
	 assign DistXv[103] = DrawX - 10'd380; 
	 assign DistYv[103] = DrawY - 10'd387;
	 
	 assign DistXv[104] = DrawX - 10'd340; 
	 assign DistYv[104] = DrawY - 10'd387;
	 
	 assign DistXv[105] = DrawX - 10'd300; 
	 assign DistYv[105] = DrawY - 10'd387;
	 
	 assign DistXv[106] = DrawX - 10'd260; 
	 assign DistYv[106] = DrawY - 10'd387;
	 
	 assign DistXv[107] = DrawX - 10'd220; 
	 assign DistYv[107] = DrawY - 10'd387;
	 
	 assign DistXv[108] = DrawX - 10'd140; 
	 assign DistYv[108] = DrawY - 10'd387;
	 
	 assign DistXv[109] = DrawX - 10'd100; 
	 assign DistYv[109] = DrawY - 10'd387;
	 
	 assign DistXv[110] = DrawX - 10'd60; 
	 assign DistYv[110] = DrawY - 10'd387;
	 //next row
	 assign DistXv[111] = DrawX - 10'd580; 
	 assign DistYv[111] = DrawY - 10'd427;
	 
	 assign DistXv[112] = DrawX - 10'd540; 
	 assign DistYv[112] = DrawY - 10'd427;
	 
	 assign DistXv[113] = DrawX - 10'd500; 
	 assign DistYv[113] = DrawY - 10'd427;
	 
	 assign DistXv[114] = DrawX - 10'd460; 
	 assign DistYv[114] = DrawY - 10'd427;
	 
	 assign DistXv[115] = DrawX - 10'd420; 
	 assign DistYv[115] = DrawY - 10'd427;
	 
	 assign DistXv[116] = DrawX - 10'd380; 
	 assign DistYv[116] = DrawY - 10'd427;
	 
	 assign DistXv[117] = DrawX - 10'd340; 
	 assign DistYv[117] = DrawY - 10'd427;
	 
	 assign DistXv[118] = DrawX - 10'd300; 
	 assign DistYv[118] = DrawY - 10'd427;
	 
	 assign DistXv[119] = DrawX - 10'd260; 
	 assign DistYv[119] = DrawY - 10'd427;
	 
	 assign DistXv[120] = DrawX - 10'd220; 
	 assign DistYv[120] = DrawY - 10'd427;
	 
	 assign DistXv[121] = DrawX - 10'd140; 
	 assign DistYv[121] = DrawY - 10'd427;
	 
	 assign DistXv[122] = DrawX - 10'd100; 
	 assign DistYv[122] = DrawY - 10'd427;
	 
	 assign DistXv[123] = DrawX - 10'd60; 
	 assign DistYv[123] = DrawY - 10'd427;
	 
	 
	 always_comb begin
		  for(int i=0; i<124; i++) begin
			 if((DistXv[i]*DistXv[i]) + (DistYv[i]*DistYv[i]) <= 10'd11)
					doton[i] = 1'b1;
				else
					doton[i] = 1'b0;
			end
			
		end
	//int gameover;
	//assign gameover = 0; 
	always_ff @ ( posedge Reset or posedge vga_clk) begin
				if(Reset) begin
					dotoff = 124'd0;
					isGameOver = 1'b0;
				end
				else if(starton)begin
					dotoff = 124'd0;
					isGameOver = 1'b0;
				end
				else begin
					if(ball_on && (bghost_on || pghost_on || rghost_on || yghost_on))
						isGameOver = 1'b1;
					for(int i=0; i<124; i++) begin
						if(ball_on && doton[i])
							dotoff[i] = 1'b1;
					end
					for(int i=0; i<124; i++) begin
						if(dotoff[i] == 1'b0)
							break;
						else if(i == 123)
							isGameOver = 1'b1;
					end
				end	
			 end
	
//	always_ff @ ( posedge Reset or posedge vga_clk) begin
//		for(int i=0; i<124; i++) begin
//			if(dotoff[i] == 1'b0)
//				break;
//			else if(i == 123)
//				isGameOver = 1'b1;
//		end
//	end	
//	assign isGameOver = 1'b0;

halfopen_rom halfopen_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

halfopen_palette halfopen_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

fullyopen_rom fullyopen_rom (
	.clock   (fullyopen_negedge_vga_clk),
	.address (fullyopen_rom_address),
	.q       (fullyopen_rom_q)
);

fullyopen_palette fullyopen_palette (
	.index (fullyopen_rom_q),
	.red   (fullyopen_palette_red),
	.green (fullyopen_palette_green),
	.blue  (fullyopen_palette_blue)
);

closed_rom closed_rom (
	.clock   (closed_negedge_vga_clk),
	.address (closed_rom_address),
	.q       (closed_rom_q)
);

closed_palette closed_palette (
	.index (closed_rom_q),
	.red   (closed_palette_red),
	.green (closed_palette_green),
	.blue  (closed_palette_blue)
);

ogbackground_rom background_rom (
	.clock   (bnegedge_vga_clk),
	.address (background_rom_address),
	.q       (brom_q)
);

ogbackground_palette background_palette (
	.index (brom_q),
	.red   (bpalette_red),
	.green (bpalette_green),
	.blue  (bpalette_blue)
);	

background_rom bitmaprom (
	.clock   (bitnegedge_vga_clk),
	.address (bitrom_address),
	.q       (bitrom_q)
);

//background_rom bitmaprom2 (
//	.clock   (gbitnegedge_vga_clk),
//	.address (gbitrom_address),
//	.q       (gbitrom_q)
//);

startscreen_rom startscreen_rom (
	.clock   (startscreen_negedge_vga_clk),
	.address (startscreen_rom_address),
	.q       (startscreen_rom_q)
);

startscreen_palette startscreen_palette (
	.index (startscreen_rom_q),
	.red   (startscreen_palette_red),
	.green (startscreen_palette_green),
	.blue  (startscreen_palette_blue)
);

gameoverscreen_rom gameoverscreen_rom (
	.clock   (gameover_negedge_vga_clk),
	.address (gameover_rom_address),
	.q       (gameover_rom_q)
);

gameoverscreen_palette gameoverscreen_palette (
	.index (gameover_rom_q),
	.red   (gameover_palette_red),
	.green (gameover_palette_green),
	.blue  (gameover_palette_blue)
);

blue_rom blue_rom (
	.clock   (blue_negedge_vga_clk),
	.address (blue_rom_address),
	.q       (blue_rom_q)
);

blue_palette blue_palette (
	.index (blue_rom_q),
	.red   (blue_palette_red),
	.green (blue_palette_green),
	.blue  (blue_palette_blue)
);

pink_rom pink_rom (
	.clock   (pink_negedge_vga_clk),
	.address (pink_rom_address),
	.q       (pink_rom_q)
);

pink_palette pink_palette (
	.index (pink_rom_q),
	.red   (pink_palette_red),
	.green (pink_palette_green),
	.blue  (pink_palette_blue)
);

red_rom red_rom (
	.clock   (red_negedge_vga_clk),
	.address (red_rom_address),
	.q       (red_rom_q)
);

red_palette red_palette (
	.index (red_rom_q),
	.red   (red_palette_red),
	.green (red_palette_green),
	.blue  (red_palette_blue)
);

yellow_rom yellow_rom (
	.clock   (yellow_negedge_vga_clk),
	.address (yellow_rom_address),
	.q       (yellow_rom_q)
);

yellow_palette yellow_palette (
	.index (yellow_rom_q),
	.red   (yellow_palette_red),
	.green (yellow_palette_green),
	.blue  (yellow_palette_blue)
);
	 always_comb
	 begin
		if(keycode == 8'h04) //A
			bitrom_address = ((BallX * 320) / 640) + ((((BallY+10) * 240) / 480) * 320);
		else if(keycode == 8'h07) //D
			bitrom_address = (((BallX+20) * 320) / 640) + ((((BallY+10) * 240) / 480) * 320);
		else if(keycode == 8'h16) //S
			bitrom_address = (((BallX+10) * 320) / 640) + ((((BallY+20) * 240) / 480) * 320);
		else if(keycode == 8'h1A) //W
			bitrom_address = (((BallX+10) * 320) / 640) + ((((BallY) * 240) / 480) * 320);
		else
			bitrom_address = (((BallX+10) * 320) / 640) + ((((BallY+20) * 240) / 480) * 320);
	 end
	 
	 always_ff @ (posedge vga_clk) begin
		unique case (keycode)
			8'h04 : leftwall <= bitrom_q;
			8'h07 : rightwall <= bitrom_q;
			8'h16 : downwall <= bitrom_q;
			8'h1A : upwall <= bitrom_q;
			default;
		endcase
	end
	
//	always_comb
//	 begin
//		if(movedir == 3'b011) //A 
//			gbitrom_address = ((ghostX * 320) / 640) + ((((ghostY+10) * 240) / 480) * 320);
//		else if(movedir == 3'b001) //D
//			gbitrom_address = (((ghostX+20) * 320) / 640) + ((((ghostY+10) * 240) / 480) * 320);
//		else if(movedir == 3'b010) //S
//			gbitrom_address = (((ghostX+10) * 320) / 640) + ((((ghostY+20) * 240) / 480) * 320);
//		else if(movedir == 3'b000) //W
//			gbitrom_address = (((ghostX+10) * 320) / 640) + ((((ghostY) * 240) / 480) * 320);
//		else
//			gbitrom_address = (((ghostX+10) * 320) / 640) + ((((ghostY+20) * 240) / 480) * 320);
//	 end
//	always_ff @ (posedge vga_clk) begin
//		unique case (movedir)
//			3'b011 : bleftwall <= gbitrom_q;
//			3'b001 : brightwall <= gbitrom_q;
//			3'b010 : bdownwall <= gbitrom_q;
//			3'b000 : bupwall <= gbitrom_q;
//			default;
//		endcase
//	end

    always_comb
    begin:RGB_Display
			Red <= 4'b0;
			Green <= 4'b0;
			Blue <= 4'b0;
			if(starton) begin
				Red <= {startscreen_palette_red, 4'b0};
				Green <= {startscreen_palette_green, 4'b0};
				Blue <= {startscreen_palette_blue, 4'b0};
			end
			else if(gameoveron) begin
				Red <= {gameover_palette_red, 4'b0} ;
				Green <= {gameover_palette_green, 4'b0};
				Blue <= {gameover_palette_blue,  4'b0};
			end
			else if(playon)begin
				//begin 
					Red <= {bpalette_red,  4'b0};
					Green <= {bpalette_green,  4'b0};
					Blue <= {bpalette_blue,  4'b0};
	//            Red = 8'h00; 
	//            Green = 8'h00;
	//            Blue = 8'h7f - DrawX[9:3];
				//end 
			  for(int i=0; i<124; i++) begin
					if(doton[i] && ~dotoff[i]) begin
						Red <= 8'hC0;
						Green <= 8'h90;
						Blue <= 8'hE0;
					end
			  end
			  if(bghost_on)begin
					if(!(blue_palette_red == 4'h0 && blue_palette_green == 4'h0 && blue_palette_blue == 4'h0)) begin
						Red <= {blue_palette_red,  4'b0};
						Green <= {blue_palette_green, 4'b0};
						Blue <= {blue_palette_blue, 4'b0};
					end
			  end
			  if(pghost_on)begin
					if(!(pink_palette_red == 4'h0 && pink_palette_green == 4'h0 && pink_palette_blue == 4'h0)) begin
						Red <= {pink_palette_red,  4'b0};
						Green <= {pink_palette_green, 4'b0};
						Blue <= {pink_palette_blue, 4'b0};
					end
			  end
			  if(rghost_on)begin
					if(!(red_palette_red == 4'h0 && red_palette_green == 4'h0 && red_palette_blue == 4'h0)) begin
						Red <= {red_palette_red,  4'b0};
						Green <= {red_palette_green, 4'b0};
						Blue <= {red_palette_blue, 4'b0};
					end
			  end
			  if(yghost_on)begin
					if(!(yellow_palette_red == 4'h0 && yellow_palette_green == 4'h0 && yellow_palette_blue == 4'h0)) begin
						Red <= {yellow_palette_red,  4'b0};
						Green <= {yellow_palette_green, 4'b0};
						Blue <= {yellow_palette_blue, 4'b0};
					end
			  end
			  if(ball_on) begin
					case (animationselect)
						2'b01 : begin
							if(!(palette_red == 4'h0 && palette_green == 4'h0 && palette_blue == 4'h0)) begin
								Red <= {palette_red,  4'b0};
								Green <= {palette_green, 4'b0};
								Blue <= {palette_blue, 4'b0};
							end
						end
						2'b10 : begin
							if(!(fullyopen_palette_red == 4'h0 && fullyopen_palette_green == 4'h0 && fullyopen_palette_blue == 4'h0)) begin
								Red <= {fullyopen_palette_red,  4'b0};
								Green <= {fullyopen_palette_green, 4'b0};
								Blue <= {fullyopen_palette_blue, 4'b0};
							end
						end
						2'b11 : begin
							if(!(closed_palette_red == 4'h0 && closed_palette_green == 4'h0 && closed_palette_blue == 4'h0)) begin
								Red <= {closed_palette_red,  4'b0};
								Green <= {closed_palette_green, 4'b0};
								Blue <= {closed_palette_blue, 4'b0};
							end
						end
						default: ;
					endcase
				end
			end 
    end
    
endmodule


//if(halfopenon) begin
//						if(!(palette_red == 4'h0 && palette_green == 4'h0 && palette_blue == 4'h0)) begin
//							Red <= {palette_red,  4'b0};
//							Green <= {palette_green, 4'b0};
//							Blue <= {palette_blue, 4'b0};
//						end
//					end
//					else if(fullopenon) begin
//						if(!(fullyopen_palette_red == 4'h0 && fullyopen_palette_green == 4'h0 && fullyopen_palette_blue == 4'h0)) begin
//							Red <= {fullyopen_palette_red,  4'b0};
//							Green <= {fullyopen_palette_green, 4'b0};
//							Blue <= {fullyopen_palette_blue, 4'b0};
//						end
//					end
//					else if(closedon) begin
//						if(!(closed_palette_red == 4'h0 && closed_palette_green == 4'h0 && closed_palette_blue == 4'h0)) begin
//							Red <= {closed_palette_red,  4'b0};
//							Green <= {closed_palette_green, 4'b0};
//							Blue <= {closed_palette_blue, 4'b0};
//						end
//					end