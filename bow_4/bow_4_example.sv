module bow_4_example (
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
	if( DrawX > 417 && DrawY > 16 && DrawX < 640 && DrawY < 480 ) begin
		rom_address = (((DrawX-418)>>1) + (((DrawY-17)>>1) * 111));
		if (rom_q == 0 || rom_q == 5)
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

bow_4_rom bow_4_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

bow_4_palette bow_4_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

endmodule
