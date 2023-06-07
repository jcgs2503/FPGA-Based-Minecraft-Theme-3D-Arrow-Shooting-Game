module bow_3_example (
	input logic vga_clk,
	input logic [9:0] DrawX, DrawY,
	input logic blank,
	output logic [3:0] red, green, blue,
	output logic a
);

logic [16:0] rom_address;
logic [2:0] rom_q;

logic [3:0] palette_red, palette_green, palette_blue;

logic negedge_vga_clk;

// read from ROM on negedge, set pixel on posedge
assign negedge_vga_clk = ~vga_clk;

// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
// this will stretch out the sprite across the entire screen
always_comb begin
	if( DrawX > 420 && DrawY > 32 && DrawX < 627 && DrawY < 480 ) begin
		rom_address = (((DrawX-421)>>1) + (((DrawY-33)>>1) * 103));
		if (rom_q == 0 || rom_q == 6)
			a = 1'b0;
		else 
			a = 1'b1;
	end else begin
		rom_address = 15'b0;
		a = 1'b0;
	end
end

always_ff @ (posedge vga_clk) begin
	red <= 4'h0;
	green <= 4'h0;
	blue <= 4'h0;

	if (blank) begin
		red <= palette_red;
		green <= palette_green;
		blue <= palette_blue;
	end
end

bow_3_rom bow_3_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

bow_3_palette bow_3_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

endmodule
