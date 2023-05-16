module red_rom (
	input logic clock,
	input logic [8:0] address,
	output logic [4:0] q
);

logic [4:0] memory [0:399] /* synthesis ram_init_file = "./red/red.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
