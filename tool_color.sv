module tool_color (
	input Clk,
	input [9:0] vga_x, vga_y,
	input [3:0] health,
	output logic [3:0] tool_r, tool_g, tool_b, 
	output logic [1:0] tool_a
);

	logic [9:0] xs;
	logic [4:0] x;
	logic [5:0] y;
	logic [3:0] id;
	logic ax, ay;
	
	always_comb begin
		if (vga_x >= 10'd176 && vga_x < 10'd464) begin
			xs = vga_x - 10'd176;
			ax = 1'b1;
		end
		else begin
			xs = 10'd0;
			ax = 1'b0;
		end
		
		if (vga_y >= 10'd420 && vga_y < 10'd460) begin
			y = vga_y - 10'd420;
			ay = 1'b1;
		end
		else begin
			y = 6'd0;
			ay = 1'b0;
		end
			
		id = xs[8:5];
		x = xs[4:0];
	end
	
	logic [9:0] hp_xs, hp_ys;
	logic [2:0] hp_x;
	logic [3:0] hp_y;
	logic [3:0] hp_id;
	
	always_comb begin
		if (vga_x >= 10'd240 && vga_x < 10'd400)
			hp_xs = vga_x - 10'd240;
		else
			hp_xs = 10'd0;
		
		if (vga_y >= 10'd390 && vga_y < 10'd410)
			hp_ys = vga_y - 10'd390;
		else
			hp_ys = 10'd0;
			
		hp_id = hp_xs[7:4];
		hp_x = hp_xs[3:1];
		hp_y = hp_ys[4:1];
	end
	
	localparam [0:19][0:15][2:0] bow = {
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},	
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd4,3'd4,3'd4,3'd4,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd4,3'd4,3'd4,3'd3,3'd4,3'd4,3'd3,3'd2},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd4,3'd4,3'd3,3'd4,3'd3,3'd2,3'd2,3'd2,3'd2,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd4,3'd1,3'd3,3'd2,3'd2,3'd2,3'd0,3'd0,3'd1,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd4,3'd1,3'd5,3'd1,3'd0,3'd0,3'd0,3'd0,3'd1,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd4,3'd1,3'd5,3'd1,3'd0,3'd0,3'd0,3'd0,3'd1,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd4,3'd3,3'd1,3'd0,3'd0,3'd0,3'd0,3'd1,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd4,3'd3,3'd2,3'd0,3'd0,3'd0,3'd0,3'd1,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd4,3'd4,3'd2,3'd0,3'd0,3'd0,3'd1,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd4,3'd3,3'd2,3'd0,3'd0,3'd1,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd4,3'd3,3'd2,3'd0,3'd0,3'd1,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd4,3'd4,3'd2,3'd0,3'd1,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd4,3'd4,3'd2,3'd1,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd4,3'd3,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0}
	};
	
	localparam [0:19][0:15][2:0] arrow = {
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd1,3'd5,3'd2,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd1,3'd5,3'd5,3'd1,3'd2,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd2,3'd3,3'd5,3'd2,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd2,3'd1,3'd2,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd2,3'd0,3'd2,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd5,3'd5,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd5,3'd5,3'd5,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd2,3'd5,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0}
	};
	
	localparam [0:19][0:15][2:0] torch = {
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd7,3'd6,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd7,3'd5,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd4,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd4,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd4,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0}
	};
	
	localparam [0:7][12:0] palette = {
		{4'h0, 4'h0, 4'h0, 1'b0},
		{4'h5, 4'h5, 4'h5, 1'b1},
		{4'h3, 4'h1, 4'h0, 1'b1},
		{4'h7, 4'h5, 4'h2, 1'b1},
		{4'h5, 4'h3, 4'h1, 1'b1},
		{4'ha, 4'ha, 4'ha, 1'b1},
		{4'hd, 4'h7, 4'h1, 1'b1},
		{4'he, 4'he, 4'h3, 1'b1}
	};
	
	localparam [0:9][0:7][1:0] heart = {
		{2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0,2'd0},
		{2'd0,2'd0,2'd1,2'd1,2'd0,2'd1,2'd1,2'd0},
		{2'd0,2'd1,2'd3,2'd2,2'd1,2'd2,2'd3,2'd1},
		{2'd0,2'd1,2'd2,2'd2,2'd2,2'd2,2'd2,2'd1},
		{2'd0,2'd1,2'd2,2'd2,2'd2,2'd2,2'd2,2'd1},
		{2'd0,2'd1,2'd2,2'd2,2'd2,2'd2,2'd2,2'd1},
		{2'd0,2'd1,2'd3,2'd2,2'd2,2'd2,2'd3,2'd1},
		{2'd0,2'd0,2'd1,2'd3,2'd2,2'd3,2'd1,2'd0},
		{2'd0,2'd0,2'd0,2'd1,2'd3,2'd1,2'd0,2'd0},
		{2'd0,2'd0,2'd0,2'd0,2'd1,2'd0,2'd0,2'd0},
	};
	
	always_ff @ (posedge Clk) begin
		tool_a[1] <= ax & ay;
		tool_r <= 4'h0;
		tool_g <= 4'h0;
		tool_b <= 4'h0;
			
		if (id == 4'd4) begin
			if ((x >= 5'd0 && x < 5'd3) || x >= 5'd29 || (y >= 6'd0 && y < 6'd3) || (y >= 6'd37 && y < 6'd40)) begin
				tool_r <= 4'hf;
				tool_g <= 4'hf;
				tool_b <= 4'hf;
				tool_a[0] <= 1'b1;
			end
			else
				{tool_r, tool_g, tool_b, tool_a[0]} <= palette[bow[y[5:1]][x[4:1]]];
		end
		else if (x == 5'd0 || x == 5'd31 || y == 6'd0 || y== 6'd39) begin
			tool_r <= 4'h0;
			tool_g <= 4'h0;
			tool_b <= 4'h0;
			tool_a[0] <= 1'b1;
		end 
		else if (x == 5'd1 || x == 5'd30 || y == 6'd1 || y== 6'd38) begin
			tool_r <= 4'hf;
			tool_g <= 4'hf;
			tool_b <= 4'hf;
			tool_a[0] <= 1'b0;
		end
		else if (id == 4'd5)
			{tool_r, tool_g, tool_b, tool_a[0]} <= palette[arrow[y[5:1]][x[4:1]]];
		else if (id == 4'd0)
			{tool_r, tool_g, tool_b, tool_a[0]} <= palette[torch[y[5:1]][x[4:1]]];
		
		unique case (heart[hp_y][hp_x])
			2'd1: begin
				tool_a <= 2'b11;
				tool_r <= 4'h0;
				tool_g <= 4'h0;
				tool_b <= 4'h0;
			end
			2'd2: begin
				if (hp_id >= health) begin
					tool_a <= 2'b11;
					tool_r <= 4'h2;
					tool_g <= 4'h2;
					tool_b <= 4'h2;
				end
				else begin
					if (hp_x==10'd3 && hp_y==10'd3) begin
						tool_a <= 2'b11;
						tool_r <= 4'hf;
						tool_g <= 4'hc;
						tool_b <= 4'hc;
					end
					else begin
						tool_a <= 2'b11;
						tool_r <= 4'ha;
						tool_g <= 4'h0;
						tool_b <= 4'h0;
					end
				end
			end
			2'd3: begin
				if (hp_id >= health) begin
					tool_a <= 2'b11;
					tool_r <= 4'h2;
					tool_g <= 4'h2;
					tool_b <= 4'h2;
				end
				else begin
					tool_a <= 2'b11;
					tool_r <= 4'h6;
					tool_g <= 4'h0;
					tool_b <= 4'h0;
				end
			end
			default: ;
		endcase
	end
	
endmodule