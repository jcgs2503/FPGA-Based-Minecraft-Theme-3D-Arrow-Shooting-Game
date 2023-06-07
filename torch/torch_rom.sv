module torch_rom (
	input logic clock,
	input logic [14:0] address,
	output logic [2:0] q
);

logic [2:0] memory [0:21999] /* synthesis ram_init_file = "./torch/torch.mif" */;

always_ff @ (posedge clock) begin
	q <= memory[address];
end

endmodule
