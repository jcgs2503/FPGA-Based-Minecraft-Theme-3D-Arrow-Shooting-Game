module clk_divider(
	input Clk,
	input [31:0] count,
	output logic slow_clk = 1'b0
);

	logic [31:0] cnt = 0;
	
	always_ff @ (posedge Clk) begin
		if (cnt == count) begin
			cnt <= 1;
			slow_clk <= ~slow_clk;
		end
		else
			cnt <= cnt + 1;
	end
		
endmodule
