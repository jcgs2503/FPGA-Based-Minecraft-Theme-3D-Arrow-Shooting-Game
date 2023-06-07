module arrow_ram (
	input logic clock,
	input logic [3:0] AVL_ADDR,
	input logic AVL_READ, AVL_WRITE,
	input logic [31:0] AVL_WRITE_DATA,
	output logic [31:0] q
);

logic [31:0] memory [0: 7];

always_ff @ (posedge clock) begin
	if( AVL_READ )
		q <= memory[AVL_ADDR];
	else if ( AVL_WRITE )
		memory[AVL_ADDR] <= AVL_WRITE_DATA;
end

endmodule
