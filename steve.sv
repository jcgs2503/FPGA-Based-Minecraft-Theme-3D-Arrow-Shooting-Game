module steve (
	input Clk, Reset,
	input [7:0] keycode,
	input [255:0][4:0] map,
	input [255:0][3:0] mob,
	input [31:0] tri_center,
	input [7:0] who_shoot,
	input hit,
	output [15:0] steve_x,
	output [15:0] steve_y,
	output logic [15:0] angle = 16'h0,
	output logic [3:0] bow_state,
	output logic shoot,
	output logic [3:0] health = 4'd10,
	output logic alive = 1'b1,
	output logic respawn
);

	// keycode = {x, space, ->, <-, D, S, A, W}
	
	logic frame_clk;
	logic blk_u, blk_d, blk_r, blk_l;
	int x = 32'h18000;
	int y = 32'h18000;
	int tmp_x, tmp_y;
	int next_x, next_y;
	int sin, cos, op, op_mem;
	logic [7:0] who_mem;
	
	assign sin = {{16{tri_center[31]}},tri_center[31:16]};
	assign cos = {{16{tri_center[15]}},tri_center[15:0]};
	assign op = cos * (y - {12'h0, who_mem[7:4], 16'h8000}) + sin * (x - {12'h0, who_mem[3:0], 16'h8000});
	
	assign steve_x = x[23:8];
	assign steve_y = y[23:8];
	
	assign blk_u = mob[{y[19:16]-4'b1, x[19:16]}][3] | map[{y[19:16]-4'b1, x[19:16]}][4];
	assign blk_d = mob[{y[19:16]+4'b1, x[19:16]}][3] | map[{y[19:16]+4'b1, x[19:16]}][4];
	assign blk_r = mob[{y[19:16], x[19:16]+4'b1}][3] | map[{y[19:16], x[19:16]+4'b1}][4];
	assign blk_l = mob[{y[19:16], x[19:16]-4'b1}][3] | map[{y[19:16], x[19:16]-4'b1}][4];
		
	clk_divider clk0 (Clk, 32'd200000, frame_clk);  //125Hz

	always_ff @ (posedge frame_clk) begin
		if (respawn | Reset)
			angle <= 16'h0;
		else if (alive) begin
			if (keycode[6]) begin
				if (keycode[5] & ~keycode[4]) begin
					if (angle < 16'd1)
						angle <= angle + 16'd2399;
					else
						angle <= angle - 16'd1;
				end
				else if (keycode[4] & ~keycode[5]) begin
					if (angle > 16'd2399)
						angle <= angle - 16'd2399;
					else
						angle <= angle + 16'd1;
				end
			end
			else begin
				if (keycode[5] & ~keycode[4]) begin
					if (angle < 16'd4)
						angle <= angle + 16'd2396;
					else
						angle <= angle - 16'd4;
				end
				else if (keycode[4] & ~keycode[5]) begin
					if (angle > 16'd2396)
						angle <= angle - 16'd2396;
					else
						angle <= angle + 16'd4;
				end
			end
		end
		else begin
			if (op_mem < 0 && op < 0) begin
				if (angle < 16'd4)
					angle <= angle + 16'd2396;
				else
					angle <= angle - 16'd4;
			end
			else if (op_mem > 0 && op > 0) begin
				if (angle > 16'd2396)
					angle <= angle - 16'd2396;
				else
					angle <= angle + 16'd4;
			end
		end
	end
	
	always_comb begin
		if (keycode[0] & ~keycode[2] & ~hit_back) begin
			if (keycode[6]) begin
				tmp_x = x + cos;
				tmp_y = y - sin;
			end
			else begin
				tmp_x = x + (cos << 2);
				tmp_y = y - (sin << 2);
			end		
		end
		else if (keycode[2] & ~keycode[0] | hit_back) begin
			if (keycode[6]) begin
				tmp_x = x - cos;
				tmp_y = y + sin;
			end
			else begin
				tmp_x = x - (cos << 2);
				tmp_y = y + (sin << 2);
			end
		end
		else begin
			tmp_x = x;
			tmp_y = y;
		end
	end
	
	always_comb begin
		if (keycode[1] & ~keycode[3]) begin
			if (keycode[6]) begin
				next_x = tmp_x - sin;
				next_y = tmp_y - cos;
			end
			else begin
				next_x = tmp_x - (sin << 2);
				next_y = tmp_y - (cos << 2);
			end
		end
		else if (keycode[3] & ~keycode[1]) begin
			if (keycode[6]) begin
				next_x = tmp_x + sin;
				next_y = tmp_y + cos;
			end
			else begin
				next_x = tmp_x + (sin << 2);
				next_y = tmp_y + (cos << 2);
			end
		end
		else begin
			next_x = tmp_x;
			next_y = tmp_y;
		end
	end
	
	always_ff @ (posedge frame_clk) begin
		if (respawn | Reset) begin
			x <= 32'h18000;
			y <= 32'h18000;
		end
		else if (alive) begin
			if (blk_l && next_x < {x[31:16], 16'h4000})
				x <= {x[31:16], 16'h4000};
			else if (blk_r && next_x > {x[31:16], 16'hc000})
				x <= {x[31:16], 16'hc000};
			else
				x <= next_x;
			
			if (blk_u && next_y < {y[31:16], 16'h4000})
				y <= {y[31:16], 16'h4000};
			else if (blk_d && next_y > {y[31:16], 16'hc000})
				y <= {y[31:16], 16'hc000};
			else
				y <= next_y;
		end
		else begin
			if (((x >> 8) - {20'h0, who_mem[3:0], 8'h80}) * ((x >> 8) - {20'h0, who_mem[3:0], 8'h80}) + ((y >> 8) - {20'h0, who_mem[7:4], 8'h80}) * ((y >> 8) - {20'h0, who_mem[7:4], 8'h80}) > 32'h10000) begin
				x <= (x * 31 >> 5) + {17'h0, who_mem[3:0], 11'h400};
				y <= (y * 31 >> 5) + {17'h0, who_mem[7:4], 11'h400};
			end
		end
	end
	
	// Bow State Machine
	
	int bow_counter = 0;
	
	always_ff @ (posedge frame_clk) begin
		shoot <= 1'b0;
		if (respawn | Reset) begin
			bow_state <= 4'b0000;
			bow_counter <= 0;	
		end 
		else if (keycode[6] && bow_counter < 25) begin
			bow_state <= 4'b0001;
			bow_counter <= bow_counter + 1;	
		end
		else if (keycode[6] && bow_counter < 50) begin
			bow_state <= 4'b0010;
			bow_counter <= bow_counter + 1;
		end
		else if (keycode[6] && bow_counter < 75) begin
			bow_state <= 4'b0011;
			bow_counter <= bow_counter + 1;
		end
		else if (keycode[6] && bow_counter < 100) begin
			bow_state <= 4'b0100;
			bow_counter <= bow_counter + 1;
		end
		else if (bow_counter == 100) begin
			bow_state <= 4'b0101;
			if (~keycode[6]) begin
				bow_counter <= bow_counter + 1;
				shoot <= 1'b1;
			end
		end
		else if (bow_counter > 100 && bow_counter < 107) begin
			bow_state <= 4'b0110;
			bow_counter <= bow_counter + 1;
		end
		else if (bow_counter >= 107  && bow_counter < 117) begin
			bow_state <= 4'b0111;
			bow_counter <= bow_counter + 1;
		end
		else begin
			bow_state <= 4'b0000;
			bow_counter <= 0;
		end
	end
	
	// health
	int hp_counter = 0;
	logic hit_state;
	logic [3:0] hp_mem;
	logic hit_back;
	
	always_ff @ (posedge Clk) begin
		if (respawn | Reset) begin
			health <= 4'd10;
			alive <= 1'b1;
			hit_back <= 1'b0;
		end
		else if (hit && hp_counter == 0) begin
			hp_counter <= 1;
			hit_back <= 1'b1;
			hp_mem <= health;
			who_mem <= who_shoot;
			op_mem = cos * (y - {12'h0, who_shoot[7:4], 16'h8000}) + sin * (x - {12'h0, who_shoot[3:0], 16'h8000});
		end
	
		
		if (hp_counter == 30000000) begin
			health <= hp_mem - 1;
			hp_counter <= 0;
			hit_back <= 1'b0;
		end
		else if (hp_counter > 0 && hp_counter < 30000000) begin
			hit_back <= 1'b1;
			hp_counter <= hp_counter + 1;
//			if (hit && ~hit_state) begin
//				health <= hp_mem - 1;
//				hit_state <= 1'b1;
//			end else if (~hit && hit_state) begin
//				hit_state <= 1'b0;
//				health <= hp_mem;
//			end
//				health <= hp_mem;
//				hit_state <= hit_state;
				
			if (hp_counter[23])
				health <= hp_mem - 1;
			else
				health <= hp_mem;
//			
//			if (hp_counter > 20000000)
//				hit <= 1'b0;
//			else if (hp_counter > 20000000)
//				hit <= 1'b1;
		end
		
		if (health == 4'd0)
			alive <= 1'b0;
		

	end
	
	always_ff @ (posedge frame_clk) begin
		respawn <= 1'b0;
		if (~alive & keycode[7])
			respawn <= 1'b1;
	end
	
endmodule
