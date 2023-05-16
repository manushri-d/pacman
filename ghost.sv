module ghost ( input Reset, frame_clk, Clk,
					input logic playon, //bleftwall, brightwall, bupwall, bdownwall, onwall,
               output [9:0]  ghostX, ghostY, input logic [2:0] movedir);
    
    logic [9:0]ghost_X_Pos, ghost_X_Motion, ghost_Y_Pos, ghost_Y_Motion, ghost_Size;
	 
//	 parameter [9:0] Ball_X_Center=310;  // 310 custom position on the X axis
//    parameter [9:0] Ball_Y_Center=260;  // 260 custom position on the Y axis
//    parameter [9:0] Ball_X_Min=30;       // Leftmost point on the X axis
//    parameter [9:0] Ball_X_Max=590;     // Rightmost point on the X axis
//    parameter [9:0] Ball_Y_Min=30;       // Topmost point on the Y axis
//    parameter [9:0] Ball_Y_Max=430;     // Bottommost point on the Y axis
//    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
//    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
	 
    parameter [9:0] ghost_X_Center=300;//290;  // Center position on the X axis
    parameter [9:0] ghost_Y_Center=180;//220;  // Center position on the Y axis
    parameter [9:0] ghost_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] ghost_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] ghost_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] ghost_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] ghost_X_Step=2;      // Step size on the X axis
    parameter [9:0] ghost_Y_Step=2;      // Step size on the Y axis
		
    assign ghost_Size = 20;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
//		logic nclock, newclock, extremelynewclock;
//		always_ff @ (posedge frame_clk or posedge Reset )
//    begin 
//        if (Reset) 
//            nclock <= 1'b0;
//        else 
//            nclock <= ~ (nclock);
//    end
//	 
//	 always_ff @ (posedge nclock or posedge Reset )
//    begin 
//        if (Reset) 
//            newclock <= 1'b0;
//        else 
//            newclock <= ~ (nclock);
//    end
	 
//	 always_ff @ (posedge newclock or posedge Reset )
//    begin 
//        if (Reset) 
//            extremelynewclock <= 1'b0;
//        else 
//            extremelynewclock <= ~ (nclock);
//    end
		//logic [1:0] movedir;
//		always_ff @ (posedge newclock) begin //change to frame_clk ????
//			if(movedir == 5)
//				movedir <= 2'b00;
//			else
//				movedir <= (movedir+1);
//		end
//		
		
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_ghost
        if (Reset)  // Asynchronous Reset
        begin 
            ghost_Y_Motion <= 10'd0; //Ball_Y_Step;
				ghost_X_Motion <= 10'd0; //Ball_X_Step;
				ghost_Y_Pos <= ghost_Y_Center;
				ghost_X_Pos <= ghost_X_Center;
        end
        else if(~playon) begin
				ghost_Y_Motion <= 10'd0; //Ball_Y_Step;
				ghost_X_Motion <= 10'd0; //Ball_X_Step;
				ghost_Y_Pos <= ghost_Y_Center;
				ghost_X_Pos <= ghost_X_Center;
			end  
        else 
        begin 
				 if ( (ghost_Y_Pos + ghost_Size) >= ghost_Y_Max )  // Ball is at the bottom edge, BOUNCE!
					  ghost_Y_Motion <= (~ (ghost_Y_Step) + 1'b1);  // 2's complement.
					  
				 else if ( (ghost_Y_Pos - ghost_Size) <= ghost_Y_Min )  // Ball is at the top edge, BOUNCE!
					  ghost_Y_Motion <= ghost_Y_Step;
					  
				 else if ( (ghost_X_Pos + ghost_Size) >= ghost_X_Max )  // Ball is at the Right edge, BOUNCE!
					  ghost_X_Motion <= (~ (ghost_X_Step) + 1'b1);  // 2's complement.
					  
				 else if ( (ghost_X_Pos - ghost_Size) <= ghost_X_Min )  // Ball is at the Left edge, BOUNCE!
					  ghost_X_Motion <= ghost_X_Step;
					  
				 else begin
					  ghost_Y_Motion <= ghost_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
					  
//					for(int i = 0; i < 33; i++) begin //inital up ghost_Y_Pos != 10'd187
//						movedir = 2'b00;
//					end
//					if(ghost_X_Motion == 8'b00000001)
//						moveDir <= 2'b10;

//					for(int i=0; i< 130; i++) begin //while(ghost_X_Pos != 10'd420) begin //right
//						movedir = 4'b01;
//					end
//
//					for(int i=0; i< 120; i++) begin //while(ghost_Y_Pos != 10'd307) begin //down
//						movedir = 4'b10;
//					end				
				 //begin
				 //makes the ball not bounce
				 ghost_X_Motion <= 0;//A
				 ghost_Y_Motion<= 0;
				 
				 case (movedir) 
				 
					3'b011 : begin
								//if(bleftwall) begin
								//if(~onwall) begin
									//updatedir <= movedir;
									ghost_X_Motion <= -1;//A
									ghost_Y_Motion<= 0;
								//end
//								else
//									updatedir <= 2'b10;
//								else begin
//									ghost_X_Motion <= 1;//D
//									ghost_Y_Motion<= 0;
//								end
							  end
					        
					3'b001 : begin
								//if(brightwall) begin
									//updatedir <= movedir;
								//if(~onwall) begin
									ghost_X_Motion <= 1;//D
									ghost_Y_Motion<= 0;
								//end
//								else
//									updatedir <= 2'b00;
//								else begin
//									ghost_X_Motion <= -1;//A
//									ghost_Y_Motion<= 0;
//								end
							  end

							  
					3'b010 : begin
								//if(bdownwall) begin
								//if(~onwall) begin
									//updatedir <= movedir;
									ghost_Y_Motion <= 1;//S
									ghost_X_Motion <= 0;
								//end
//								else
//									updatedir <= 2'b01;
//								else begin
//									ghost_Y_Motion <= -1;//W
//									ghost_X_Motion <= 0;
//								end
							 end
							  
					3'b000 : begin
								//if(bupwall) begin
									//updatedir <= movedir;
								//if(~onwall) begin
									ghost_Y_Motion <= -1;//W
									ghost_X_Motion <= 0;
								//end
//								else 
//									updatedir <= 2'b11;
//								else begin
//									ghost_Y_Motion <= 1;//S
//									ghost_X_Motion <= 0;
//								end
							 end	  
					default: ;
			   endcase
				
				 end
				 ghost_Y_Pos <= (ghost_Y_Pos + ghost_Y_Motion);  // Update ghost position
				 ghost_X_Pos <= (ghost_X_Pos + ghost_X_Motion);	
		end  
    end
       
    assign ghostX = ghost_X_Pos;
   
    assign ghostY = ghost_Y_Pos;
   
    
    

endmodule

module ghostFSM(input logic Clk, Reset, input logic playon, bleftwall, brightwall, bupwall, bdownwall,
							output logic [2:0] movedir, output logic onwall); //updir, rightdir, leftdir, downdir
	enum logic [2:0] { starting, uplogic, leftlogic, downlogic, rightlogic } State, Next_State;
	always_ff @ (posedge Clk) begin
		if(Reset)
			State <= starting;
		else if (~playon)
			State <= starting;
		else
			State <= Next_State;
	end
	always_comb begin
		Next_State = State;
		movedir = 3'b111;
		onwall = 1'b0;
//		updir = 1'b0;
//		downdir = 1'b0;
//		leftdir = 1'b0;
//		rightdir = 1'b0;
		unique case (State)
			starting : begin
				if(playon)
					Next_State = rightlogic;
			end
			uplogic : begin
				if(~bupwall) begin
					Next_State = rightlogic;//leftlogic;
					onwall = 1'b1;
				end
			end
			leftlogic : begin
				if(~bleftwall) begin
					Next_State = uplogic;//downlogic;
					onwall = 1'b1;
				end
			end
			downlogic : begin
				if(~bdownwall) begin
					Next_State = leftlogic;//rightlogic;
					onwall = 1'b1;
				end
			end
			rightlogic : begin
				if(~brightwall) begin
					Next_State = downlogic;//uplogic;
					onwall = 1'b1;
				end
			end
//			rrightlogic : begin
//				if(~brightwall) begin
//					Next_State = downlogic;//uplogic;
//					onwall = 1'b1;
//				end
//			end
			default : ;
		endcase
		case(State)
			starting:
				movedir = 3'b111;
			uplogic: 
				movedir = 3'b000;//updir = 1'b1;
			leftlogic:
				movedir = 3'b011;//leftdir = 1'b1;
			downlogic:
				movedir = 3'b010;//downdir = 1'b1;
			rightlogic:
				movedir = 3'b001;//rightdir = 1'b1;
//			rrightlogic:
//				movedir = 3'b001;//rightdir = 1'b1;
			default : ;
		endcase
	end
endmodule

module ghosthcFSM(input logic Clk, Reset, input logic playon, 
							output logic [2:0] movedir, input [9:0]  ghostX, ghostY); //updir, rightdir, leftdir, downdir //output logic onwall, 
	enum logic [4:0] { starting, first, second, third, fourth, fifth, sixth, seventh, eighth, ninth } State, Next_State;
	always_ff @ (posedge Clk) begin
		if(Reset)
			State <= starting;
		else if (~playon)
			State <= starting;
		else
			State <= Next_State;
	end
	always_comb begin
		Next_State = State;
		movedir = 3'b111;
		//onwall = 1'b0;
//		updir = 1'b0;
//		downdir = 1'b0;
//		leftdir = 1'b0;
//		rightdir = 1'b0;
		unique case (State)
			starting : begin
				if(playon)
					Next_State = first;
			end
			first : begin //going right
				if(ghostX == 10'd410) begin
					Next_State = second;
					//onwall = 1'b1;
				end
			end
			second : begin //going down
				if(ghostY == 10'd300) begin
					Next_State = third;
					//onwall = 1'b1;
				end
			end
			third : begin //go left
				if(ghostX == 10'd330) begin
					Next_State = fourth;
					//onwall = 1'b1;
				end
			end
			fourth : begin //go down
				if(ghostY == 10'd340) begin
					Next_State = fifth;
					//onwall = 1'b1;
				end
			end
			fifth : begin //go left
				if(ghostX == 10'd160) begin
					Next_State = sixth;
					//onwall = 1'b1;
				end
			end
			sixth : begin //go up
				if(ghostY == 10'd220) begin
					Next_State = seventh;
					//onwall = 1'b1;
				end
			end
			seventh : begin // go right
				if(ghostX == 10'd220) begin
					Next_State = eighth;
					//onwall = 1'b1;
				end
			end
			eighth : begin // go up
				if(ghostY == 10'd180) begin
					Next_State = ninth;
					//onwall = 1'b1;
				end
			end
			ninth : begin //go right
				if(ghostX == 10'd300) begin
					Next_State = first;
					//onwall = 1'b1;
				end
			end
			default : ;
		endcase
		case(State)
			starting:
				movedir = 3'b111;
			first :  //going right
				movedir = 3'b001;
			second :  //going down
				movedir = 3'b010;
			third :  //go left
				movedir = 3'b011;
			fourth :  //go down
				movedir = 3'b010;
			fifth :  //go left
				movedir = 3'b011;
			sixth :  //go up
				movedir = 3'b000;
			seventh :  //go right
				movedir = 3'b001;
			eighth :  //go up
				movedir = 3'b000;
			ninth :  //go right
				movedir = 3'b001;
			default : ;
		endcase
	end
endmodule

module pinkghosthcFSM(input logic Clk, Reset, input logic playon, // bleftwall, brightwall, bupwall, bdownwall,
							output logic [2:0] movedir, input [9:0]  ghostX, ghostY); //updir, rightdir, leftdir, downdir //output logic onwall, 
	enum logic [8:0] { starting, first, second, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth,
							eleventh, twelfth, thirteenth, fourteenth, fifteenth, sixteenth} State, Next_State;
	always_ff @ (posedge Clk) begin
		if(Reset)
			State <= starting;
		else if (~playon)
			State <= starting;
		else
			State <= Next_State;
	end
	always_comb begin
		Next_State = State;
		movedir = 3'b111;
		unique case (State)
			starting : begin
				if(playon)
					Next_State = first;
			end
			first : begin //going right
				if(ghostX == 10'd340) begin
					Next_State = second;
				end
			end
			second : begin //going up
				if(ghostY == 10'd140) begin
					Next_State = third;
				end
			end
			third : begin //go right
				if(ghostX == 10'd410) begin
					Next_State = fourth;
				end
			end
			fourth : begin //go up
				if(ghostY == 10'd100) begin
					Next_State = fifth;
				end
			end
			fifth : begin //go right
				if(ghostX == 10'd560) begin
					Next_State = sixth;
				end
			end
			sixth : begin //go up
				if(ghostY == 10'd50) begin
					Next_State = seventh;
				end
			end
			seventh : begin // go left
				if(ghostX == 10'd345) begin
					Next_State = eighth;
				end
			end
			eighth : begin // go down
				if(ghostY == 10'd100) begin
					Next_State = ninth;
				end
			end
			ninth : begin //go left
				if(ghostX == 10'd50) begin
					Next_State = tenth;
				end
			end
			tenth : begin //go down
				if(ghostY == 10'd130) begin
					Next_State = eleventh;
				end
			end
			eleventh : begin //go right
				if(ghostX == 10'd160) begin
					Next_State = twelfth;
				end
			end
			twelfth : begin //go down
				if(ghostY == 10'd380) begin
					Next_State = thirteenth;
				end
			end
			thirteenth : begin //go up
				if(ghostY == 10'd220) begin
					Next_State = fourteenth;
				end
			end
			fourteenth : begin // go right
				if(ghostX == 10'd220) begin
					Next_State = fifteenth;
				end
			end
			fifteenth : begin // go up
				if(ghostY == 10'd180) begin
					Next_State = sixteenth;
				end
			end
			sixteenth : begin //go right
				if(ghostX == 10'd300) begin
					Next_State = first;
				end
			end
			default : ;
		endcase
		case(State)
			starting:
				movedir = 3'b111;
			first :  //going right
				movedir = 3'b001;
			second :  //going up
				movedir = 3'b000;
			third :  //go right
				movedir = 3'b001;
			fourth :  //go up
				movedir = 3'b000;
			fifth :  //go right
				movedir = 3'b001;
			sixth :  //go up
				movedir = 3'b000;
			seventh :  //go left
				movedir = 3'b011;
			eighth :  //go down
				movedir = 3'b010;
			ninth :  //go left
				movedir = 3'b011;
			tenth :  //go down
				movedir = 3'b010;
			eleventh :  //go right
				movedir = 3'b001;
			twelfth :  //go down
				movedir = 3'b010;
			thirteenth :  //go up
				movedir = 3'b000;
			fourteenth :  // go right
				movedir = 3'b001;
			fifteenth :  // go up
				movedir = 3'b000;
			sixteenth :  //go right
				movedir = 3'b001;
			default : ;
		endcase
	end
endmodule

module redghosthcFSM(input logic Clk, Reset, input logic playon, // bleftwall, brightwall, bupwall, bdownwall,
							output logic [2:0] movedir, input [9:0]  ghostX, ghostY); //updir, rightdir, leftdir, downdir //output logic onwall, 
	enum logic [7:0] { starting, first, second, third, fourth, fifth, sixth, seventh, eighth, ninth, tenth,
							eleventh, twelfth, thirteenth, fourteenth, fifteenth} State, Next_State;
	always_ff @ (posedge Clk) begin
		if(Reset)
			State <= starting;
		else if (~playon)
			State <= starting;
		else
			State <= Next_State;
	end
	always_comb begin
		Next_State = State;
		movedir = 3'b111;
		unique case (State)
			starting : begin
				if(playon)
					Next_State = first;
			end
			first : begin //going left
				if(ghostX == 10'd210) begin
					Next_State = second;
				end
			end
			second : begin //going down
				if(ghostY == 10'd300) begin
					Next_State = third;
				end
			end
			third : begin //go left
				if(ghostX == 10'd60) begin
					Next_State = fourth;
				end
			end
			fourth : begin //go down
				if(ghostY == 10'd340) begin
					Next_State = fifth;
				end
			end
			fifth : begin //go right
				if(ghostX == 10'd100) begin
					Next_State = sixth;
				end
			end
			sixth : begin //go down
				if(ghostY == 10'd380) begin
					Next_State = seventh;
				end
			end
			seventh : begin // go left
				if(ghostX == 10'd60) begin
					Next_State = eighth;
				end
			end
			eighth : begin // go down
				if(ghostY == 10'd420) begin
					Next_State = ninth;
				end
			end
			ninth : begin //go right
				if(ghostX == 10'd560) begin
					Next_State = tenth;
				end
			end
			tenth : begin //go up
				if(ghostY == 10'd380) begin
					Next_State = eleventh;
				end
			end
			eleventh : begin //go left
				if(ghostX == 10'd480) begin
					Next_State = twelfth;
				end
			end
			twelfth : begin //go up
				if(ghostY == 10'd300) begin
					Next_State = thirteenth;
				end
			end
			thirteenth : begin //go left
				if(ghostX == 10'd400) begin
					Next_State = fourteenth;
				end
			end
			fourteenth : begin // go up
				if(ghostY == 10'd180) begin
					Next_State = fifteenth;
				end
			end
			fifteenth : begin // go left
				if(ghostX == 10'd300) begin
					Next_State = first;
				end
			end
			default : ;
		endcase
		case(State)
			starting:
				movedir = 3'b111;
			first :  //going left
				movedir = 3'b011;
			second :  //going down
				movedir = 3'b010;
			third :  //go left
				movedir = 3'b011;
			fourth :  //go down
				movedir = 3'b010;
			fifth :  //go right
				movedir = 3'b001;
			sixth :  //go down
				movedir = 3'b010;
			seventh :  //go left
				movedir = 3'b011;
			eighth :  //go down
				movedir = 3'b010;
			ninth :  //go right
				movedir = 3'b001;
			tenth :  //go up
				movedir = 3'b000;
			eleventh :  //go left
				movedir = 3'b011;
			twelfth :  //go up
				movedir = 3'b000;
			thirteenth :  //go left
				movedir = 3'b011;
			fourteenth :  // go up
				movedir = 3'b000;
			fifteenth :  // go left
				movedir = 3'b011;
			default : ;
		endcase
	end
endmodule

module yellowghosthcFSM(input logic Clk, Reset, input logic playon, // bleftwall, brightwall, bupwall, bdownwall,
							output logic [2:0] movedir, input [9:0]  ghostX, ghostY); //updir, rightdir, leftdir, downdir //output logic onwall, 
	enum logic [12:0] { starting, first, second, third, fourth, fifth, sixth, seventh, eighth, 
							eleventh, twelfth, thirteenth, fourteenth, fifteenth, sixteenth, seventeenth, nineteenth, twenty, twentyone, twentytwo, twentythree, twentyfour} State, Next_State;
	always_ff @ (posedge Clk) begin
		if(Reset)
			State <= starting;
		else if (~playon)
			State <= starting;
		else
			State <= Next_State;
	end
	always_comb begin
		Next_State = State;
		movedir = 3'b111;
		unique case (State)
			starting : begin
				if(playon)
					Next_State = first;
			end
			first : begin //going left
				if(ghostX == 10'd210) begin
					Next_State = second;
				end
			end
			second : begin //going down
				if(ghostY == 10'd260) begin
					Next_State = third;
				end
			end
			third : begin //go right
				if(ghostX == 10'd400) begin
					Next_State = fourth;
				end
			end
			fourth : begin //go up
				if(ghostY == 10'd225) begin
					Next_State = fifth;
				end
			end
			fifth : begin //go right
				if(ghostX == 10'd540) begin
					Next_State = sixth;
				end
			end
			sixth : begin //go left
				if(ghostX == 10'd480) begin
					Next_State = seventh;
				end
			end
			seventh : begin // go down
				if(ghostY == 10'd345) begin
					Next_State = eighth;
				end
			end
			//
			eighth : begin // go left
				if(ghostX == 10'd410) begin
					Next_State = eleventh;
				end
			end
//			ninth : begin //go down
//				if(ghostY == 10'd350) begin
//					Next_State = tenth;
//				end
//			end
//			tenth : begin //go right
//				if(ghostX == 10'd410) begin
//					Next_State = eleventh;
//				end
//			end
			eleventh : begin //go down
				if(ghostY == 10'd390) begin
					Next_State = twelfth;
				end
			end
			twelfth : begin //go left
				if(ghostX == 10'd330) begin
					Next_State = thirteenth;
				end
			end
			thirteenth : begin //go down 
				if(ghostY == 10'd410) begin
					Next_State = fourteenth;
				end
			end
			fourteenth : begin // go left
				if(ghostX == 10'd290) begin
					Next_State = fifteenth;
				end
			end
			fifteenth : begin // go up
				if(ghostY == 10'd380) begin
					Next_State = sixteenth;
				end
			end
			sixteenth : begin // go left
				if(ghostX == 10'd220) begin
					Next_State = seventeenth;
				end
			end
			seventeenth : begin // go up
				if(ghostY == 10'd350) begin
					Next_State = nineteenth;
				end
			end
			nineteenth : begin // go left
				if(ghostX == 10'd160) begin
					Next_State = twenty;
				end
			end
			twenty : begin // go up
				if(ghostY == 10'd210) begin
					Next_State = twentyone;
				end
			end
			twentyone : begin // go left
				if(ghostX == 10'd40) begin
					Next_State = twentytwo;
				end
			end
			twentytwo : begin // go right
				if(ghostX == 10'd220) begin
					Next_State = twentythree;
				end
			end
			twentythree : begin // go up
				if(ghostY == 10'd180) begin
					Next_State = twentyfour;
				end
			end
			twentyfour : begin //go right
				if(ghostX == 10'd300) begin
					Next_State = first;
				end
			end
			default : ;
		endcase
		case(State)
			starting:
				movedir = 3'b111;
//			//left 
//			movedir = 3'b011;
//			 //going down
//			 movedir = 3'b010;
//			 //go right
//				movedir = 3'b001;
//				//go up
//				movedir = 3'b000;
			first :  //going left
				movedir = 3'b011;
			second :  //going down
				 movedir = 3'b010;
			third :  //go right
				movedir = 3'b001;
			fourth :  //go up
				movedir = 3'b000;
			fifth :  //go right
				movedir = 3'b001;
			sixth :  //go left
				movedir = 3'b011;
			seventh :  // go down
				 movedir = 3'b010;
			eighth :  // go left
				movedir = 3'b011;
			eleventh :  //go down
				 movedir = 3'b010;
			twelfth :  //go left
				movedir = 3'b011;
			thirteenth :  //go down 
				 movedir = 3'b010;
			fourteenth :  // go left
				movedir = 3'b011;
			fifteenth :  // go up
				movedir = 3'b000;
			sixteenth :  // go left
				movedir = 3'b011;
			seventeenth :  // go up
				movedir = 3'b000;
			nineteenth :  // go left
				movedir = 3'b011;
			twenty :  // go up
				movedir = 3'b000;
			twentyone :  // go left
				movedir = 3'b011;
			twentytwo :  // go right
				movedir = 3'b001;
			twentythree :  // go up
				movedir = 3'b000;
			twentyfour :  //go right
				movedir = 3'b001;
			default : ;
		endcase
	end
endmodule
//module lfsr4bit(input Clk, input Reset, output logic [1:0] data);// begin
//	logic [1:0] nextd;
//	
//	always @* begin
//		nextd[1] = 1'b1; //data[1] ^ data[0];
//		nextd[0] = 1'b0; //data[0] ^ nextd[1];
////		nextd[3] = data[3] ^ data[1];
////		nextd[2] = data[2] ^ data[0];
////		nextd[1] = data[1] ^ nextd[3];
////		nextd[0] = data[0] ^ nextd[2];
//	end
//	
//	always @(posedge Clk or negedge Reset) begin
//		if(!Reset)
//			data <= 2'b11;
//		else
//			data <= nextd;
//	end
//endmodule

//module lfsr(input wire Clk, input wire Reset, input wire enable, output reg [7:0] out);
//	wire linear_feedback;
//	assign linear_feedback = !(out[7] ^ out[3]);
//	always_ff@(posedge Clk)
//		if(Reset) begin
//			out <= 8'd0;
//		end
//		else if(enable) begin
//			out <= {out[6],out[5],out[4],out[3],out[2],out[1],out[0],linear_feedback};
//		end
//endmodule

//module randcounter(input Clk, input Reset, input [2:0] 