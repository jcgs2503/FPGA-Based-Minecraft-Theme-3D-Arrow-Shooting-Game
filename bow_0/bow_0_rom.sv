module bow_0_rom (
	input logic clock,
	input logic [15:0] address,
	output logic [3:0] q
);

logic [2:0] memory [0:40319] /* synthesis ram_init_file = "./bow_0/bow_0.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
