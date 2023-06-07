module bow_4_rom (
	input logic clock,
	input logic [14:0] address,
	output logic [2:0] q
);

logic [2:0] memory [0:25751] /* synthesis ram_init_file = "./bow_4/bow_4.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
