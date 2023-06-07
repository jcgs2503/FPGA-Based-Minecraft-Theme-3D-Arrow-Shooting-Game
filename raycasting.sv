module raycasting (
	input Clk, Reset,
	input [255:0][4:0] map,
	input [255:0][3:0] mob,
	input [15:0] steve_x, steve_y,
	input [31:0] tri_center,
	input [31:0] tri_ray,
	output logic [9:0] ray_id = 10'h0,
	output logic [31:0] ray_wall_data,
	output logic ray_wall_wren,
	output logic [31:0] ray_mob_data,
	output logic ray_mob_wren,
	output logic [7:0] mob_seen,
	output logic [7:0] mob_aimed
);
	
	logic refresh_clk;
	clk_divider clk1 (Clk, 2, refresh_clk);
	
	int sin, cos, rx, ry;
	int sum_dx, sum_dy, sum_sx, sum_sy;
	logic [3:0] row_id, col_id;
	
	int dx, dy, sx, sy;
	int refsin, refcos, shadow, distx, disty;
	int mob_distx, mob_disty, mob_sx, mob_sy, deltax, deltay;
	
	logic who, hit_wall, hit_mob;
	logic [5:0] state = 6'h0;
	
	always_comb begin
		if (sin == 0) begin
			dx = 2147483647;
			dy = (tri_ray[15])? -rx: rx;
		end
		else if (cos == 0) begin
			dx = (tri_ray[31])? -ry: ry;
			dy = 2147483647;
		end
		else begin
			dx = (ry << 8) / sin;
			dy = (rx << 8) / cos;
		end
		
		sx = (dx * cos) >>> 8;
		sy = (dy * sin) >>> 8;
	
		refsin = {{16{tri_center[31]}}, tri_center[31:16]};
		refcos = {{16{tri_center[15]}}, tri_center[15:0]};
		shadow = (refcos*cos + refsin*sin) >> 8;
		distx = sum_dx * shadow;
		disty = sum_dy * shadow;
				
		if (tri_ray[31]) begin
			mob_sx = (sin + cos << 15) - {16'h0, sum_sx[15:0]} * sin;
			deltax = (sum_dx << 8) + (cos - sin << 15) - {16'h0, sum_sx[15:0]} * cos;
			mob_distx = (deltax >> 8) * shadow;
		end
		else begin
			mob_sx = (sin - cos << 15) - {16'h0, sum_sx[15:0]} * sin;
			deltax = (sum_dx << 8) + (sin + cos << 15) - {16'h0, sum_sx[15:0]} * cos;
			mob_distx = (deltax >> 8) * shadow;
		end
		
		if (tri_ray[15]) begin
			mob_sy = - (sin + cos << 15) + {16'h0, ~sum_sy[15:0]+16'h1} * cos;
			deltay = (sum_dy << 8) + (sin - cos << 15) - {16'h0, ~sum_sy[15:0]+16'h1} * sin;
			mob_disty = (deltay >> 8) * shadow;
		end
		else begin
			mob_sy = (sin - cos << 15) + {16'h0, ~sum_sy[15:0]+16'h1} * cos;
			deltay = (sum_dy << 8) + (sin + cos << 15) - {16'h0, ~sum_sy[15:0]+16'h1} * sin;
			mob_disty = (deltay >> 8) * shadow;
		end
	end
	
	always_ff @ (posedge refresh_clk) begin
		if (Reset) begin
			state <= 6'h0;
			ray_id <= 10'b0;
		end
		else begin
			state <= state + 6'b1;
			if (state == 6'd63) begin
				if (ray_mob_data[31:24] < 8'h4)
					mob_seen <= ray_mob_data[15:8];
				else
					mob_seen <= 8'h0;

				if (ray_id == 10'd639)
					ray_id <= 10'b0;
				else
					ray_id <= ray_id + 10'b1;
					
				if (ray_id == 10'd319)
					mob_aimed <= ray_mob_data[15:8];
			end
		end
	end
	
	int lx, ly;
	assign lx = {16'h0, steve_x[7:0], 8'h0};
	assign ly = {{16'h0, ~steve_y[7:0]}+8'h1, 8'h0};
	
	always_ff @ (posedge refresh_clk) begin
		ray_wall_wren <= 1'b0;
		ray_mob_wren <= 1'b0;
		
		if (state == 6'd0) begin
			sin <= {{16{tri_ray[31]}}, tri_ray[31:16]};
			cos <= {{16{tri_ray[15]}}, tri_ray[15:0]};
			row_id <= steve_y[11:8];
			col_id <= steve_x[11:8];
			
			if (tri_ray[15])
				rx <= -lx;
			else
				rx <= {{16'h0, ~steve_x[7:0]}+8'h1, 8'h0};
			if (tri_ray[31])
				ry <= -ly;
			else
				ry <= {16'h0, steve_y[7:0], 8'h0};
			
			sum_dx <= 0;
			sum_dy <= 0;	
			sum_sx <= {16'h0, steve_x[7:0], 8'h0};
			sum_sy <= {16'h0, steve_y[7:0], 8'h0};
			hit_wall <= 1'b0;
			hit_mob <= 1'b0;
		end
		else if (state[0]) begin
			if (sum_dx+dx < sum_dy+dy) begin
				sum_dx <= sum_dx + dx;
				sum_sx <= sum_sx + sx;
				ry <= (tri_ray[31])? -65536: 65536;
				row_id <= (tri_ray[31])? row_id + 4'h1: row_id - 4'h1;
				who <= 1'b0;
			end
			else begin
				sum_dy <= sum_dy + dy;
				sum_sy <= sum_sy - sy;
				rx <= (tri_ray[15])? -65536: 65536;
				col_id <= (tri_ray[15])? col_id - 4'h1: col_id + 4'h1;
				who <= 1'b1;
			end
			
			if (ray_mob_data[7:5] > 3'd0 && ray_mob_data[7:5] < 3'd7)
				hit_mob <= 1'b0;
		end
		else begin
			if (~hit_wall & map[{row_id, col_id}][4]) begin
				hit_wall <= 1'b1;
				if (who) begin
					ray_wall_data <= {disty[31:16], 8'h0, sum_sy[15:12], map[{row_id, col_id}][3:0]};
					ray_wall_wren <= 1'b1;
				end
				else begin
					ray_wall_data <= {distx[31:16], 8'h0, sum_sx[15:12], map[{row_id, col_id}][3:0]};
					ray_wall_wren <= 1'b1;
				end
			end
			else if (~hit_wall & ~hit_mob & mob[{row_id, col_id}][3]) begin
				hit_mob <= 1'b1;
				if (who) begin
					ray_mob_data <= {mob_disty[31:16], {row_id, col_id}, mob_sy[24:19], mob[{row_id, col_id}][2:1]};
					ray_mob_wren <= 1'b1;
				end
				else begin
					ray_mob_data <= {mob_distx[31:16], {row_id, col_id}, mob_sx[24:19], mob[{row_id, col_id}][2:1]};
					ray_mob_wren <= 1'b1;
				end
			end
		end
		
		if (state == 6'd62) begin
			if (~hit_wall) begin
				ray_wall_data <= 32'hffff0000;
				ray_wall_wren <= 1'b1;
			end
			if (~hit_mob) begin
				ray_mob_data <= 32'hffff0000;
				ray_mob_wren <= 1'b1;
			end
		end
	end

endmodule
