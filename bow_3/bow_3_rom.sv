module bow_3_rom (
	input logic clock,
	input logic [14:0] address,
	output logic [2:0] q
);

logic [2:0] memory [0:23071] /* synthesis ram_init_file = "./bow_3/bow_3.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
