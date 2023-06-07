module bow_2_rom (
	input logic clock,
	input logic [14:0] address,
	output logic [2:0] q
);

logic [2:0] memory [0:20195] /* synthesis ram_init_file = "./bow_2/bow_2.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
