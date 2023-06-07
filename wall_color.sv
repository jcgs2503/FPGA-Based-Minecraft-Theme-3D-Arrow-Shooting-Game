module wall_color (
	input Clk,
   input [9:0] vga_x, vga_y,
   input [31:0] ray_wall_q, ray_mob_q,
   output [3:0] r, g, b
);

	int unsigned dist_wall, h_wall;
	int unsigned pxl_wall_y, pxl_mob_y;
	int unsigned dist_mob, h_head, h_body;
	logic [1:0] txr_sel_wall;
	logic [3:0] pxl_mob_x;
	logic [3:0] r0, g0, b0, r1, g1, b1;
	logic a0, a1;
	
	int unsigned rw, gw, bw, rm, gm , bm;
	logic [9:0] rc, gc, bc, rf, gf, bf;
	
	always_comb begin
		dist_wall = {16'h0, ray_wall_q[31:16]};
		h_wall = 122880 / dist_wall;
		
		if (vga_y > 239) begin
			pxl_wall_y = {18'h0, vga_y - 10'd240, 4'h0} / h_wall;
			txr_sel_wall = ray_wall_q[3:2];
		end
		else begin
			pxl_wall_y = 15 - {18'h0, 10'd239 - vga_y, 4'h0} / h_wall;
			txr_sel_wall = ray_wall_q[1:0];
		end
		
		dist_mob = {16'h0, ray_mob_q[31:16]};
		h_head = 40960 / dist_mob;
		h_body = 122880 / dist_mob;
		
		if (ray_mob_q[15:12] > 4'h0) begin
			pxl_mob_x = ~ray_mob_q[5:2] + 4'h8;
			pxl_mob_y = (vga_y + h_head - 240 << 3) / h_head;
		end
		else begin
			pxl_mob_x = 4'h0;
			pxl_mob_y = 0;
		end
	end
	
	always_comb begin
		if (h_wall > 159) begin
			rw = {28'h0, r0};
			gw = {28'h0, g0};
			bw = {28'h0, b0};
		end
		else if (h_wall > 32) begin
			rw = {28'h0, r0} * (h_wall - 32) >> 7;
			gw = {28'h0, g0} * (h_wall - 32) >> 7;
			bw = {28'h0, b0} * (h_wall - 32) >> 7;
		end
		else begin
			rw = 0;
			gw = 0;
			bw = 0;
		end
		
		if (vga_y < 80) begin
			rc = 10'h4;
			gc = 10'h4;
			bc = 10'h4;
		end
		else if (vga_y < 208) begin
			rc = (10'd207 - vga_y) >> 5;
			gc = (10'd207 - vga_y) >> 5;
			bc = (10'd207 - vga_y) >> 5;
		end
		else begin
			rc = 0;
			gc = 0;
			bc = 0;
		end
		
		if (vga_y > 399) begin
			rf = 10'h4;
			gf = 10'h4;
			bf = 10'h4;
		end
		else if (vga_y > 10'd271) begin
			rf = (vga_y - 10'd272) >> 5;
			gf = (vga_y - 10'd272) >> 5;
			bf = (vga_y - 10'd272) >> 5;
		end
		else begin
			rf = 0;
			gf = 0;
			bf = 0;
		end
		
		if (h_body > 159) begin
			rm = {28'h0, r1};
			gm = {28'h0, g1};
			bm = {28'h0, b1};
		end
		else if (h_body > 32) begin
			rm = {28'h0, r1} * (h_body - 32) >> 7;
			gm = {28'h0, g1} * (h_body - 32) >> 7;
			bm = {28'h0, b1} * (h_body - 32) >> 7;
		end
		else begin
			rm = 0;
			gm = 0;
			bm = 0;
		end
		
		if (vga_y + h_head > 239 && vga_y < 240 + h_body)
			a0 = 1'b1;
		else
			a0 = 1'b0;
	end

	texture_pack texture (Clk, {6'b0, ray_wall_q[7:4]}, {6'b0, pxl_wall_y[3:0]}, 1'b1, txr_sel_wall, r0, g0, b0);
	mob_texture mob (~Clk, pxl_mob_x, pxl_mob_y, ray_mob_q[1:0], r1, g1, b1, a1);
	
	always_comb begin
		if (a0 & a1) begin
			r = rm[3:0];
			g = gm[3:0];
			b = bm[3:0];
		end
		else if (vga_y > 240 + h_wall) begin
			r = rf[3:0];
			g = gf[3:0];
			b = bf[3:0];
		end
		else if (h_wall + vga_y > 239) begin
			r = rw[3:0];
			g = gw[3:0];
			b = bw[3:0];
		end
		else begin
			r = rc[3:0];
			g = gc[3:0];
			b = bc[3:0];
		end
	end
	
endmodule
