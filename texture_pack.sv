module texture_pack (
	input logic vga_clk,
	input logic [9:0] DrawX, DrawY,
	input logic blank,
	input logic [1:0] texture,
	output logic [3:0] red, green, blue
);

	logic [3:0] ri [4];
	logic [3:0] gi [4]; 
	logic [3:0] bi [4];
	
	texture_2_example txr_0 (vga_clk, DrawX, DrawY, blank, ri[0], gi[0], bi[0]);

	texture_3_example txr_1 (vga_clk, DrawX, DrawY, blank, ri[1], gi[1], bi[1]);

	texture_4_example txr_2 (vga_clk, DrawX, DrawY, blank, ri[2], gi[2], bi[2]);

	texture_5_example txr_3 (vga_clk, DrawX, DrawY, blank, ri[3], gi[3], bi[3]);

	always_comb begin
		red = ri[texture];
		green = gi[texture];
		blue = bi[texture];
	end

endmodule

