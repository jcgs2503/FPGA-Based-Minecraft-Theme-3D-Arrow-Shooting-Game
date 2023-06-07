module mob_color(
	input Clk,
	input [9:0] vga_x, vga_y,
   input [31:0] ray_q,
   output [3:0] r, g, b,
	output a
);
	
	logic [3:0] pxl_x;
	int unsigned distance, pxl_y, h_body, h_head, h_all;
	
	logic [3:0] r0, g0, b0;	
	logic a0;
	
	mob_texture mob (Clk, pxl_x, pxl_y[4:0], ray_q[1:0], r0, g0, b0, a0);
	
	always_comb begin
		distance = {16'h0, ray_q[31:16]};
		h_body = 122880 / distance;
		h_head = 40960 / distance;
		h_all = 163840 / distance;
		
		if (ray_q[15:8] > 8'h0) begin
			pxl_x = ray_q[5:2] + 4'h8;
			pxl_y = {{17'h0, vga_y} + h_head[26:0] - 27'd240, 5'h0} / h_all;
		end
		else begin
			pxl_x = 4'h0;
			pxl_y = 0;
		end
		
		if (h_body > 159) begin
			r = r0;
			g = g0;
			b = b0;
		end
		else if (h_body > 32) begin
			r = {28'h0, r0} * (h_body - 32) >> 7;
			g = {28'h0, g0} * (h_body - 32) >> 7;
			b = {28'h0, b0} * (h_body - 32) >> 7;
		end
		else begin
			r = 4'h0;
			g = 4'h0;
			b = 4'h0;
		end
		
		if (vga_y > 240 + h_body)
			a = 1'b0;
		else if (h_head + vga_y > 239)
			a = a0;
		else
			a = 1'b0;
	end
	
endmodule
