 //-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input Reset, frame_clk, temppac,
					input [7:0] keycode, input logic leftwall, rightwall, upwall, downwall, playon,
               output [9:0]  BallX, BallY, BallS, output logic [1:0] whichside );
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ball_Size;
//	 logic [3:0] black;
//	 assign black[0] = 
	 
	 parameter [9:0] Ball_X_Center=310;  // 310 custom position on the X axis
    parameter [9:0] Ball_Y_Center=260;  // 260 custom position on the Y axis
    parameter [9:0] Ball_X_Min=30;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=590;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=30;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=430;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
	 
//    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
//    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
//    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
//    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
//    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
//    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
//    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
//    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis

    assign Ball_Size = 4;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
		
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)  // Asynchronous Reset
        begin 
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
				Ball_X_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
        end
        else if (~playon)  // Asynchronous Reset
        begin 
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
				Ball_X_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
        end
        else 
        begin 
				 if ( (Ball_Y_Pos + Ball_Size) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
					  Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);  // 2's complement.
					  
				 else if ( (Ball_Y_Pos - Ball_Size) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
					  Ball_Y_Motion <= Ball_Y_Step;
					  
				  else if ( (Ball_X_Pos + Ball_Size) >= Ball_X_Max )  // Ball is at the Right edge, BOUNCE!
					  Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);  // 2's complement.
					  
				 else if ( (Ball_X_Pos - Ball_Size) <= Ball_X_Min )  // Ball is at the Left edge, BOUNCE!
					  Ball_X_Motion <= Ball_X_Step;
					  
				 else begin
					  Ball_Y_Motion <= Ball_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
					  
				 //begin
				 //makes the ball not bounce
				 Ball_X_Motion <= 0;//A
				 Ball_Y_Motion<= 0;
				 case (keycode) 
				 
					8'h04 : begin
								whichside = 2'b00;
								if(leftwall) begin
									Ball_X_Motion <= -1;//A
									Ball_Y_Motion<= 0;
								end
//								if( (Ball_X_Pos < 10'd120 && Ball_X_Pos > 10'd60) && (Ball_Y_Pos < 10'd70 && Ball_Y_Pos < 10'd50) ) begin
//									Ball_X_Motion <= Ball_X_Step;//move one right
//									Ball_Y_Motion<= 0;
//								end
//								else begin
//									Ball_X_Motion <= -1;//A
//									Ball_Y_Motion<= 0;
//								end
							  end
					        
					8'h07 : begin
								whichside = 2'b01;
								if(rightwall) begin
									Ball_X_Motion <= 1;//D
									Ball_Y_Motion<= 0;
								end
//								if( (Ball_X_Pos < 10'd120 && Ball_X_Pos > 10'd60) && (Ball_Y_Pos < 10'd70 && Ball_Y_Pos < 10'd50) ) begin
//									Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);//dont move
//									Ball_Y_Motion<= 0;
//								end
//								else begin
//									Ball_X_Motion <= 1;//D
//									Ball_Y_Motion<= 0;
//								end
							  end

							  
					8'h16 : begin
								whichside = 2'b10;
								if(downwall) begin
									Ball_Y_Motion <= 1;//S
									Ball_X_Motion <= 0;
								end
//								if( (Ball_X_Pos < 10'd120 && Ball_X_Pos > 10'd60) && (Ball_Y_Pos < 10'd70 && Ball_Y_Pos < 10'd50) ) begin
//									Ball_X_Motion <= 0;//dont move
//									Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);
//								end
//								else begin
//									Ball_Y_Motion <= 1;//S
//									Ball_X_Motion <= 0;
//								end
							 end
							  
					8'h1A : begin
								whichside = 2'b11;
								if(upwall) begin
									Ball_Y_Motion <= -1;//W
									Ball_X_Motion <= 0;
								end
//								if( (Ball_X_Pos < 10'd120 && Ball_X_Pos > 10'd60) && (Ball_Y_Pos < 10'd70 && Ball_Y_Pos < 10'd50) ) begin
//									Ball_X_Motion <= 0;//dont move
//									Ball_Y_Motion <= Ball_Y_Step;
//								end
//								else begin
//									Ball_Y_Motion <= -1;//W
//									Ball_X_Motion <= 0;
//								end
							 end	  
					default: ;
				//endcase
			   endcase
				 end
				 Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
				 Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
			
			
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Ball_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Ball_Y_pos.  Will the new value of Ball_Y_Motion be used,
          or the old?  How will this impact behavior of the ball during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
		end  
    end
       
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallS = Ball_Size;
    

endmodule
