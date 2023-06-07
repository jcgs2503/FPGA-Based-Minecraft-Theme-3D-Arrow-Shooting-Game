module death_color (
	input Clk,
	input [9:0] vga_x, vga_y,
	input [6:0] score,
   output logic [3:0] dr, dg, db,
	output logic da
);
	
	localparam [0:7][0:5] Y = {6'b100010,6'b010100,6'b001000,6'b001000,6'b001000,6'b001000,6'b001000,6'b000000};
	localparam [0:7][0:5] o = {6'b000000,6'b000000,6'b011100,6'b100010,6'b100010,6'b100010,6'b011100,6'b000000};
	localparam [0:7][0:5] u = {6'b000000,6'b000000,6'b100010,6'b100010,6'b100010,6'b100010,6'b011110,6'b000000};
	
	localparam [0:7][0:5] di0 = {6'b000000,6'b000000,6'b000001,6'b000010,6'b000010,6'b000010,6'b000001,6'b000000};
	localparam [0:7][0:5] di1 = {6'b001010,6'b001000,6'b101010,6'b011010,6'b001010,6'b001010,6'b111010,6'b000000};
	localparam [0:7][0:5] e = {6'b000000,6'b000000,6'b011100,6'b100010,6'b111110,6'b100000,6'b011110,6'b000000};
	localparam [0:7][0:5] d = {6'b000010,6'b000010,6'b011010,6'b100110,6'b100010,6'b100010,6'b011110,6'b000000};
	localparam [0:7][0:5] ex = {6'b100000,6'b100000,6'b100000,6'b100000,6'b100000,6'b000000,6'b100000,6'b000000};
	
	localparam [0:7][0:5] S = {6'b011110,6'b100000,6'b011100,6'b000010,6'b000010,6'b100010,6'b011100,6'b000000};
	localparam [0:7][0:5] c = {6'b000000,6'b000000,6'b011100,6'b100010,6'b100000,6'b100010,6'b011100,6'b000000};
	localparam [0:7][0:5] r = {6'b000000,6'b000000,6'b101100,6'b110010,6'b100000,6'b100000,6'b100000,6'b000000};
	localparam [0:7][0:5] co = {6'b000000,6'b100000,6'b100000,6'b000000,6'b000000,6'b100000,6'b100000,6'b000000};
	
	localparam [0:7][0:5] R = {6'b111100,6'b100010,6'b111100,6'b100010,6'b100010,6'b100010,6'b100010,6'b000000};
	localparam [0:7][0:5] s = {6'b000000,6'b000000,6'b011110,6'b100000,6'b011100,6'b000010,6'b111100,6'b000000};
	localparam [0:7][0:5] p = {6'b000000,6'b000000,6'b101100,6'b110010,6'b100010,6'b111100,6'b100000,6'b100000};
	localparam [0:7][0:5] a = {6'b000000,6'b000000,6'b011100,6'b000010,6'b011110,6'b100010,6'b011110,6'b000000};
	localparam [0:7][0:5] w = {6'b000000,6'b000000,6'b100010,6'b100010,6'b101010,6'b101010,6'b011110,6'b000000};
	localparam [0:7][0:5] n = {6'b000000,6'b000000,6'b111100,6'b100010,6'b100010,6'b100010,6'b100010,6'b000000};
	
	localparam [0:7][0:5] n0 = {6'b011100,6'b100010,6'b100110,6'b101010,6'b110010,6'b100010,6'b011100,6'b000000};
	localparam [0:7][0:5] n1 = {6'b001000,6'b011000,6'b001000,6'b001000,6'b001000,6'b001000,6'b111110,6'b000000};
	localparam [0:7][0:5] n2 = {6'b011100,6'b100010,6'b000010,6'b001100,6'b010000,6'b100010,6'b111110,6'b000000};
	localparam [0:7][0:5] n3 = {6'b011100,6'b100010,6'b000010,6'b001100,6'b000010,6'b100010,6'b011100,6'b000000};
	localparam [0:7][0:5] n4 = {6'b000110,6'b001010,6'b010010,6'b100010,6'b111110,6'b000010,6'b000010,6'b000000};
	localparam [0:7][0:5] n5 = {6'b111110,6'b100000,6'b111100,6'b000010,6'b000010,6'b100010,6'b011100,6'b000000};
	localparam [0:7][0:5] n6 = {6'b001100,6'b010000,6'b100000,6'b111100,6'b100010,6'b100010,6'b011100,6'b000000};
	localparam [0:7][0:5] n7 = {6'b111110,6'b100010,6'b000010,6'b000100,6'b001000,6'b001000,6'b001000,6'b000000};
	localparam [0:7][0:5] n8 = {6'b011100,6'b100010,6'b100010,6'b011100,6'b100010,6'b100010,6'b011100,6'b000000};
	localparam [0:7][0:5] n9 = {6'b011100,6'b100010,6'b100010,6'b011110,6'b000010,6'b000100,6'b011000,6'b000000};
	
	// You died!
	logic [7:0] x0, y0, x1, y1;
	logic q0, q1;
	
	always_comb begin
		x0 = vga_x[9:2] - 8'd56;
		y0 = vga_y[9:2] - 8'd30;
		x1 = vga_x[9:2] - 8'd57;
		y1 = vga_y[9:2] - 8'd31;
		
		if (vga_x > 10'd223 && vga_x < 10'd416 && vga_y > 10'd119 && vga_y < 10'd148) begin
			unique case (x0 / 6)
				0: q0 = Y[y0][x0];
				1: q0 = o[y0][x0-8'd6];
				2: q0 = u[y0][x0-8'd12];
				3: q0 = di0[y0][x0-8'd18];
				4: q0 = di1[y0][x0-8'd24];
				5: q0 = e[y0][x0-8'd30];
				6: q0 = d[y0][x0-8'd36];
				7: q0 = ex[y0][x0-8'd42];
				default: q0 = 1'b0;
			endcase
		end
		else
			q0 = 1'b0;
		
		if (vga_x > 10'd227 && vga_x < 10'd420 && vga_y > 10'd123 && vga_y < 10'd152) begin
			unique case (x1 / 6)
				0: q1 = Y[y1][x1];
				1: q1 = o[y1][x1-8'd6];
				2: q1 = u[y1][x1-8'd12];
				3: q1 = di0[y1][x1-8'd18];
				4: q1 = di1[y1][x1-8'd24];
				5: q1 = e[y1][x1-8'd30];
				6: q1 = d[y1][x1-8'd36];
				7: q1 = ex[y1][x1-8'd42];
				default: q1 = 1'b0;
			endcase
		end
		else
			q1 = 1'b0;
	end
	
	// Score:
	logic [8:0] x2, y2, x3, y3;
	logic q2, q3;
	
	always_comb begin
		x2 = vga_x[9:1] - 9'd136;
		y2 = vga_y[9:1] - 9'd100;
		x3 = vga_x[9:1] - 9'd137;
		y3 = vga_y[9:1] - 9'd101;
		
		if (vga_x > 10'd271 && vga_x < 10'd344 && vga_y > 10'd199 && vga_y < 10'd216) begin
			unique case (x2 / 6)
				0: q2 = S[y2][x2];
				1: q2 = c[y2][x2-8'd6];
				2: q2 = o[y2][x2-8'd12];
				3: q2 = r[y2][x2-8'd18];
				4: q2 = e[y2][x2-8'd24];
				5: q2 = co[y2][x2-8'd30];
				default: q2 = 1'b0;
			endcase
		end
		else
			q2 = 1'b0;
			
		if (vga_x > 10'd273 && vga_x < 10'd346 && vga_y > 10'd201 && vga_y < 10'd218) begin
			unique case (x3 / 6)
				0: q3 = S[y3][x3];
				1: q3 = c[y3][x3-8'd6];
				2: q3 = o[y3][x3-8'd12];
				3: q3 = r[y3][x3-8'd18];
				4: q3 = e[y3][x3-8'd24];
				5: q3 = co[y3][x3-8'd30];
				default: q3 = 1'b0;
			endcase
		end
		else
			q3 = 1'b0;
	end
	
	// Respawn
	logic [8:0] x4, y4, x5, y5;
	logic q4, q5;
	
	always_comb begin
		x4 = vga_x[9:1] - 9'd139;
		y4 = vga_y[9:1] - 9'd150;
		x5 = vga_x[9:1] - 9'd140;
		y5 = vga_y[9:1] - 9'd151;
		
		if (vga_x > 10'd277 && vga_x < 10'd362 && vga_y > 10'd299 && vga_y < 10'd316) begin
			unique case (x4 / 6)
				0: q4 = R[y4][x4];
				1: q4 = e[y4][x4-8'd6];
				2: q4 = s[y4][x4-8'd12];
				3: q4 = p[y4][x4-8'd18];
				4: q4 = a[y4][x4-8'd24];
				5: q4 = w[y4][x4-8'd30];
				6: q4 = n[y4][x4-8'd36];
				default: q4 = 1'b0;
			endcase
		end
		else
			q4 = 1'b0;
			
		if (vga_x > 10'd279 && vga_x < 10'd364 && vga_y > 10'd301 && vga_y < 10'd318) begin
			unique case (x5 / 6)
				0: q5 = R[y5][x5];
				1: q5 = e[y5][x5-8'd6];
				2: q5 = s[y5][x5-8'd12];
				3: q5 = p[y5][x5-8'd18];
				4: q5 = a[y5][x5-8'd24];
				5: q5 = w[y5][x5-8'd30];
				6: q5 = n[y5][x5-8'd36];
				default: q5 = 1'b0;
			endcase
		end
		else
			q5 = 1'b0;
	end
	
	// button
	logic [8:0] x6, y6;
	logic [3:0] q6;
	
	always_comb begin
		x6 = vga_x[9:1] - 9'd80;
		y6 = vga_y[9:1] - 9'd144;
		
		if (vga_x > 10'd159 && vga_x < 10'd480 && vga_y > 10'd287 && vga_y < 10'd328) begin
			if (x6 == 9'd0 || x6 == 9'd159 || y6 == 9'd0 || y6 == 9'd19)
				q6 = 4'h0;
			else if (x6 == 9'd1 || y6 == 9'd1)
				q6 = 4'ha;
			else if (x6 == 9'd158 || y6 == 9'd18)
				q6 = 4'h4;
			else
				q6 = 4'h6;
		end
		else
			q6 = 4'h0;
	end
	
	// Score:
	logic [8:0] x7, y7, x8, y8;
	logic q7, q8;
	
	always_comb begin
		x7 = vga_x[9:1] - 9'd172;
		y7 = vga_y[9:1] - 9'd100;
		x8 = vga_x[9:1] - 9'd173;
		y8 = vga_y[9:1] - 9'd101;
		
		if (vga_x > 10'd343 && vga_x < 10'd368 && vga_y > 10'd199 && vga_y < 10'd216) begin
			unique case (x7 / 6)
				0: begin
					unique case (score / 10)
						1: q7 = n1[y7][x7];
						2: q7 = n2[y7][x7];
						3: q7 = n3[y7][x7];
						4: q7 = n4[y7][x7];
						5: q7 = n5[y7][x7];
						6: q7 = n6[y7][x7];
						7: q7 = n7[y7][x7];
						8: q7 = n8[y7][x7];
						9: q7 = n9[y7][x7];
						default: q7 = 1'b0;
					endcase
				end
				1: begin
					unique case (score % 10)
						0: q7 = n0[y7][x7-8'd6];
						1: q7 = n1[y7][x7-8'd6];
						2: q7 = n2[y7][x7-8'd6];
						3: q7 = n3[y7][x7-8'd6];
						4: q7 = n4[y7][x7-8'd6];
						5: q7 = n5[y7][x7-8'd6];
						6: q7 = n6[y7][x7-8'd6];
						7: q7 = n7[y7][x7-8'd6];
						8: q7 = n8[y7][x7-8'd6];
						9: q7 = n9[y7][x7-8'd6];
						default: q7 = 1'b0;
					endcase
				end
				default: q7 = 1'b0;
			endcase
		end
		else
			q7 = 1'b0;
			
		if (vga_x > 10'd345 && vga_x < 10'd370 && vga_y > 10'd201 && vga_y < 10'd218) begin
			unique case (x8 / 6)
				0: begin
					unique case (score / 10)
						1: q8 = n1[y8][x8];
						2: q8 = n2[y8][x8];
						3: q8 = n3[y8][x8];
						4: q8 = n4[y8][x8];
						5: q8 = n5[y8][x8];
						6: q8 = n6[y8][x8];
						7: q8 = n7[y8][x8];
						8: q8 = n8[y8][x8];
						9: q8 = n9[y8][x8];
						default: q8 = 1'b0;
					endcase
				end
				1: begin
					unique case (score % 10)
						0: q8 = n0[y8][x8-8'd6];
						1: q8 = n1[y8][x8-8'd6];
						2: q8 = n2[y8][x8-8'd6];
						3: q8 = n3[y8][x8-8'd6];
						4: q8 = n4[y8][x8-8'd6];
						5: q8 = n5[y8][x8-8'd6];
						6: q8 = n6[y8][x8-8'd6];
						7: q8 = n7[y8][x8-8'd6];
						8: q8 = n8[y8][x8-8'd6];
						9: q8 = n9[y8][x8-8'd6];
						default: q8 = 1'b0;
					endcase
				end
				default: q8 = 1'b0;
			endcase
		end
		else
			q8 = 1'b0;
	end
	
	always_ff @ (posedge Clk) begin
		if (vga_x > 10'd159 && vga_x < 10'd480 && vga_y > 10'd287 && vga_y < 10'd328) begin
			da <= 1'b1;
			if (q4) begin
				dr <= 4'hf;
				dg <= 4'hf;
				db <= 4'hf;
			end
			else if (q5) begin
				dr <= 4'h3;
				dg <= 4'h3;
				db <= 4'h3;
			end
			else begin
				dr <= q6;
				dg <= q6;
				db <= q6;
			end
		end
		else begin
			da <= q0 | q1 | q2 | q3 | q7 | q8;
			if (q0 | q2) begin
				dr <= 4'hf;
				dg <= 4'hf;
				db <= 4'hf;
			end
			else if (q7) begin
				dr <= 4'hf;
				dg <= 4'he;
				db <= 4'h0;
			end
			else if (q1 | q3 | q8) begin
				dr <= 4'h4;
				dg <= 4'h4;
				db <= 4'h4;
			end
			else begin
				dr <= 4'hf;
				dg <= vga_y[9:6];
				db <= vga_y[9:6];
			end
		end
	end
	
endmodule
