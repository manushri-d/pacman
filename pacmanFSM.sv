module pacmanFSM(input logic Clk, frame_clk, Reset, playon, input [7:0] keycode,
							output logic [1:0] animationselect); // halfopenon, fullopenon, closedon
	enum logic [3:0] { starting, halfopen, fullopen, closed, waitstate, waitstate1, waitstate2} State, Next_State;
	logic nclock, newclock, extremelynewclock;
	always_ff @ (posedge frame_clk or posedge Reset )
    begin 
        if (Reset) 
            nclock <= 1'b0;
        else 
            nclock <= ~ (nclock);
    end
	 
	always_ff @ (posedge nclock or posedge Reset )
    begin 
        if (Reset) 
            newclock <= 1'b0;
        else 
            newclock <= ~ (newclock);
    end
	 
	 always_ff @ (posedge newclock or posedge Reset )
    begin 
        if (Reset) 
            extremelynewclock <= 1'b0;
        else 
            extremelynewclock <= ~ (extremelynewclock);
    end
	 
//	 logic [1:0] counter;
//	 always_ff @ (posedge newclock) begin //change to frame_clk ????
//			if(counter == 4)
//				counter <= 2'b00;
//			else
//				counter <= (counter+1);
//		end
//		
	always_ff @ (posedge extremelynewclock) begin
		if(Reset)
			State <= starting;
		else if (~playon)
			State <= starting;
		else
			State <= Next_State;
	end
	always_comb begin
		Next_State = State;
		animationselect = 2'b00;
//		halfopenon = 1'b0;
//		fullopenon = 1'b0;
//		closedon = 1'b0;
		unique case (State)
			starting : begin
				if(playon)
					Next_State = waitstate;
			end
			waitstate : begin
				Next_State = halfopen;
			end
			halfopen : begin
				if(keycode == 8'h04 || keycode == 8'h07 || keycode == 8'h16 || keycode == 8'h1A)
					Next_State = waitstate1;
			end
			waitstate1 : begin
				if(keycode == 8'h04 || keycode == 8'h07 || keycode == 8'h16 || keycode == 8'h1A)
					Next_State = fullopen;
			end
			fullopen : begin
				if(keycode == 8'h04 || keycode == 8'h07 || keycode == 8'h16 || keycode == 8'h1A)
					Next_State = waitstate2;
			end
			waitstate2 : begin
				if(keycode == 8'h04 || keycode == 8'h07 || keycode == 8'h16 || keycode == 8'h1A)
					Next_State = closed;
			end
			closed : begin
				//if(counter == 2'b10)
					Next_State = halfopen;
			end
			default : ;
		endcase
		case(State)
			starting : begin
				animationselect = 2'b00;
//				halfopenon = 1'b0;
//				fullopenon = 1'b0;
//				closedon = 1'b0;
			end
			halfopen : begin
				animationselect = 2'b01;
//				halfopenon = 1'b1;
//				fullopenon = 1'b0;
//				closedon = 1'b0;				
			end
			fullopen : begin
				animationselect = 2'b10;
//				halfopenon = 1'b0;
//				fullopenon = 1'b1;
//				closedon = 1'b0;
			end
			closed : begin
				animationselect = 2'b11;
//				halfopenon = 1'b0;
//				fullopenon = 1'b0;
//				closedon = 1'b1;
			end
			waitstate : begin
				animationselect = 2'b01;
//				halfopenon = 1'b1;
//				fullopenon = 1'b0;
//				closedon = 1'b0;
			end
			waitstate1 : begin
				animationselect = 2'b10;
//				halfopenon = 1'b0;
//				fullopenon = 1'b1;
//				closedon = 1'b0;
			end
			waitstate2 : begin
				animationselect = 2'b11;
//				halfopenon = 1'b0;
//				fullopenon = 1'b0;
//				closedon = 1'b1;
			end
			default : ;
		endcase
	end
endmodule
