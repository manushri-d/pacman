module yellow_rom (
	input logic clock,
	input logic [8:0] address,
	output logic [4:0] q
);

logic [4:0] memory [0:399] /* synthesis ram_init_file = "./yellow/yellow.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
