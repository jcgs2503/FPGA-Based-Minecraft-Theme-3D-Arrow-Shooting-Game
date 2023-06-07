module bow_1_rom (
	input logic clock,
	input logic [12:0] address,
	output logic [2:0] q
);

logic [2:0] memory [0:5774] /* synthesis ram_init_file = "./bow_1/bow_1.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
