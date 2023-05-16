module background_rom (
	input logic clock,
	input logic [16:0] address,
	output logic q
);

logic memory [0:76799] /* synthesis ram_init_file = "./background/background.mif" */;
//[3:0]
always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
