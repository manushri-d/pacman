module cat_rom (
	input logic clock,
	input logic [6:0] address,
	output logic [4:0] q
);

logic [4:0] memory [0:99] /* synthesis ram_init_file = "./cat/cat.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
