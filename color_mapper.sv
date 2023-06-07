module color_mapper (
   input Clk, vga_clk, vga_blank,
   input [9:0] vga_x, vga_y,
	input [3:0] health,
	input [6:0] score,
	input alive,
   input [31:0] ray_wall_q, ray_mob_q,
	input [3:0] bow_state,
	input arrow_a,
   output logic [3:0] r, g, b
);

	logic [3:0] wall_r, wall_g, wall_b;
	logic [3:0] death_r, death_g, death_b;
	logic [3:0] mob_r, mob_g, mob_b;
	logic [3:0] bow_r, bow_g, bow_b;
	logic [3:0] torch_r, torch_g, torch_b;
	logic [3:0] arrow_r, arrow_g, arrow_b;
	logic death_a, bow_a, arrow_color_a;
	logic [3:0] tool_r, tool_g, tool_b;
	logic [1:0] tool_a;
	
	wall_color wall (~Clk, vga_x, vga_y, ray_wall_q, ray_mob_q, wall_r, wall_g, wall_b);
	death_color death (~Clk, vga_x, vga_y, score, death_r, death_g, death_b, death_a);
	tool_color tool (~Clk, vga_x, vga_y, health, tool_r, tool_g, tool_b, tool_a);
	bow_color bow (~Clk, vga_x, vga_y, bow_state, bow_r, bow_g, bow_b, bow_a);
	torch_example torch_torch (~Clk, vga_x, vga_y, 1'b1, torch_r, torch_g, torch_b, torch_a);
	arrow_example arrow0 (~Clk, vga_x, vga_y, 1'b1, arrow_r, arrow_g, arrow_b, arrow_color_a);
		
	always_ff @ (posedge vga_clk) begin
		if (~vga_blank) begin
			r <= 4'h0;
			g <= 4'h0;
			b <= 4'h0;
		end
		else if (alive) begin
			if (tool_a[1]) begin
				if (tool_a[0]) begin
					r <= tool_r;
					g <= tool_g;
					b <= tool_b;
				end
				else if (bow_a) begin
					r <= {1'b0, tool_r} + {1'b0, bow_r} >> 1;
					g <= {1'b0, tool_g} + {1'b0, bow_g} >> 1;
					b <= {1'b0, tool_b} + {1'b0, bow_b} >> 1;
				end
				else if (torch_a) begin
					r <= {1'b0, tool_r} + {1'b0, torch_r} >> 1;
					g <= {1'b0, tool_g} + {1'b0, torch_g} >> 1;
					b <= {1'b0, tool_b} + {1'b0, torch_b} >> 1;
				end
				else begin
					r <= {1'b0, tool_r} + {1'b0, wall_r} >> 1;
					g <= {1'b0, tool_g} + {1'b0, wall_g} >> 1;
					b <= {1'b0, tool_b} + {1'b0, wall_b} >> 1;				
				end
			end
			else if (bow_a) begin
				r <= bow_r;
				g <= bow_g; 
				b <= bow_b;
			end else if (torch_a) begin
				r <= torch_r;
				g <= torch_g;
				b <= torch_b;
			end else if (arrow_color_a & arrow_a) begin
				r <= arrow_r;
				g <= arrow_g; 
				b <= arrow_b;
			end else begin
				r <= wall_r;
				g <= wall_g;
				b <= wall_b;
			end
		end
		else begin
			if (death_a) begin
				r <= death_r;
				g <= death_g;
				b <= death_b;
			end
			else begin
				r <= {1'b0, death_r} + {1'b0, wall_r} >> 1;
				g <= {1'b0, death_g} + {1'b0, wall_g} >> 1;
				b <= {1'b0, death_b} + {1'b0, wall_b} >> 1;
			end
		end
		
		if ((vga_x >= 10'd315 && vga_x < 10'd325 && vga_y == 10'd240) || (vga_x >= 10'd319 && vga_x <= 10'd320 && vga_y >= 10'd235 && vga_y <= 10'd246)) begin
			r <= 4'hf;
			g <= 4'hf;
			b <= 4'hf;		
		end
	end

endmodule
