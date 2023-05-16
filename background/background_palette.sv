module background_palette (
	input logic [3:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:15][11:0] palette = {
	{4'hC, 4'h9, 4'hE}, //0
	{4'h0, 4'h0, 4'h0}, //1 black
	{4'h2, 4'h0, 4'h2}, //2 black
	{4'hC, 4'h9, 4'hD}, //3
	{4'h0, 4'h0, 4'h1}, //4 black
	{4'hC, 4'h8, 4'hF}, //5
	{4'h0, 4'h0, 4'h0}, //6 black
	{4'h5, 4'h3, 4'h6}, //7
	{4'h0, 4'h0, 4'h0}, //8 black
	{4'h0, 4'h0, 4'h0}, //9 black
	{4'h4, 4'h2, 4'h4}, //10
	{4'hA, 4'h8, 4'hB}, //11
	{4'hC, 4'hA, 4'hE}, //12
	{4'hC, 4'h9, 4'hD}, //13
	{4'hD, 4'h8, 4'hF}, //14
	{4'h7, 4'h5, 4'h8}  //15
};

assign {red, green, blue} = palette[index];

endmodule
