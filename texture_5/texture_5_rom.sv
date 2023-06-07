module texture_5_rom (
	input logic clock,
	input logic [7:0] address,
	output logic [7:0] q
);

logic [7:0] memory [0:255] /* synthesis ram_init_file = "./texture_5/texture_5.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
