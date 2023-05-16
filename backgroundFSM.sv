module backgroundFSM(input logic Clk, Reset, isGameOver, input [7:0] keycode,
							output logic starton, playon, gameoveron);
	enum logic [4:0] { waitstate, waitstate1, waitstate2, waitstate3, 
							waitstate4, waitstate5, waitstate6, gameStart, playgame, gameOver } State, Next_State;
	
	always_ff @ (posedge Clk) begin
		if(Reset)
			State <= gameStart;
		else
			State <= Next_State;
	end
	always_comb begin
		Next_State = State;
		starton = 1'b0;
		playon = 1'b0;
		gameoveron = 1'b0;
		unique case (State)
			waitstate : begin
				Next_State = waitstate1;
			end
			waitstate1 : begin
				Next_State = waitstate2;
			end
			waitstate2 : begin
				Next_State = waitstate3;
			end
			waitstate3 : begin
				Next_State = waitstate4;
			end
			waitstate4 : begin
				Next_State = waitstate5;
			end
			waitstate5 : begin
				Next_State = waitstate6;
			end
			waitstate6 : begin
				Next_State = gameStart;
			end
			gameStart : begin
				if(keycode == 8'h2c)
					Next_State = playgame;
			end
			playgame : begin
				if(isGameOver)
					Next_State = gameOver;
			end
			gameOver : begin
				if(keycode == 8'h2c)
					Next_State = waitstate;
			end
			default : ;
		endcase
		case(State)
			waitstate:
				starton = 1'b1;
			waitstate1:
				starton = 1'b1;
			waitstate2:
				starton = 1'b1;
			waitstate3:
				starton = 1'b1;
			waitstate4:
				starton = 1'b1;
			waitstate5:
				starton = 1'b1;
			waitstate6:
				starton = 1'b1;
			gameStart: begin
				starton = 1'b1;
				//gameoveron = 1'b0;
			end
			playgame: begin
			//gameoveron = 1'b0;
				playon = 1'b1;
			end
			gameOver:
				gameoveron = 1'b1;
			default : ;
		endcase
	end
endmodule