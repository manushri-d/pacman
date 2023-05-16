module startscreen_rom (
	input logic clock,
	input logic [16:0] address,
	output logic [4:0] q
);

logic [4:0] memory [0:76799] /* synthesis ram_init_file = "./startscreen/startscreen.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
