`define STATE_NUM 8

module bow_color (
	input Clk,
	input [9:0] vga_x, vga_y, 
	input [3:0] bow_state,
	output [3:0] bow_r, bow_g, bow_b, 
	output bow_a
);

	logic [3:0] ri [`STATE_NUM];
	logic [3:0] gi [`STATE_NUM]; 
	logic [3:0] bi [`STATE_NUM];
	logic ai [`STATE_NUM];


	bow_0_example bow0 (Clk, vga_x, vga_y, 1'b1, ri[0], gi[0], bi[0], ai[0]);
	bow_1_example bow1 (Clk, vga_x, vga_y, 1'b1, ri[1], gi[1], bi[1], ai[1]);
	bow_2_example bow2 (Clk, vga_x, vga_y, 1'b1, ri[2], gi[2], bi[2], ai[2]);
	bow_3_example bow3 (Clk, vga_x, vga_y, 1'b1, ri[3], gi[3], bi[3], ai[3]);
	bow_4_example bow4 (Clk, vga_x, vga_y, 1'b1, ri[4], gi[4], bi[4], ai[4]);
	bow_5_example bow5 (Clk, vga_x, vga_y, 1'b1, ri[5], gi[5], bi[5], ai[5]);
	
	localparam [0:6][0:6][1:0] cross_color = {
		{2'd1,2'd0,2'd0,2'd0,2'd0,2'd0,2'd1},
		{2'd0,2'd1,2'd2,2'd0,2'd2,2'd1,2'd0},
		{2'd0,2'd2,2'd1,2'd2,2'd1,2'd2,2'd0},
		{2'd0,2'd0,2'd2,2'd1,2'd2,2'd0,2'd0},
		{2'd0,2'd2,2'd1,2'd2,2'd1,2'd2,2'd0},
		{2'd0,2'd1,2'd2,2'd0,2'd2,2'd1,2'd0},
		{2'd1,2'd0,2'd0,2'd0,2'd0,2'd0,2'd1},
	};
	
	localparam [0:2][11:0] cross_palette = {
		{4'h0, 4'h0, 4'h0},
		{4'hc, 4'ha, 4'h6},
		{4'ha, 4'h8, 4'h6},
	};
	
	logic[1:0] cross_0, cross_1;
	
	always_comb begin
		if (vga_x >= 215 && vga_y >= 109 && vga_x < 439 && vga_y < 333)
			cross_0 = cross_color[(vga_x-215)>>5][(vga_y-109)>>5];
		else
			cross_0 = 2'd0;
			
		if (vga_x >= 309 && vga_y >= 226 && vga_x < 337 && vga_y < 254)
			cross_1 = cross_color[(vga_x-309)>>2][(vga_y-226)>>2];
		else	
			cross_1 = 2'd0;
	end
	
	always_comb begin
		if( bow_state == 4'b0110 && cross_0 > 0) begin
			{ bow_r, bow_g, bow_b, bow_a } = { cross_palette[cross_0] , 1'b1};
		end else if ( bow_state == 4'b0111 && cross_1 > 0) begin
			{ bow_r, bow_g, bow_b, bow_a } = { cross_palette[cross_1] , 1'b1};
		end else if ( bow_state >= 4'b0110 ) begin
			bow_r = ri[0];
			bow_g = gi[0];
			bow_b = bi[0];
			bow_a = ai[0];
		end else begin
			bow_r = ri[bow_state];
			bow_g = gi[bow_state];
			bow_b = bi[bow_state];
			bow_a = ai[bow_state];
		end
	end

endmodule