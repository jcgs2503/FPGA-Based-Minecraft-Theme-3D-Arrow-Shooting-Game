module bow_5_example (
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
//
// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
// this will stretch out the sprite across the entire screen
always_comb begin
	if( DrawX > 387 && DrawX < 640 && DrawY < 480 ) begin
		rom_address = ((DrawX-388) + (DrawY * 262));
		if (rom_q == 0)
			a = 1'b0;
		else 
			a = 1'b1;
	end else begin
		rom_address = 15'b0;
		a = 1'b0;
	end
end

//assign rom_address = ((DrawX * 131) / 640) + (((DrawY * 240) / 480) * 131);
//assign a = 1'b1;

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

bow_5_rom bow_5_rom (
	.clock   (negedge_vga_clk),
	.address (rom_address),
	.q       (rom_q)
);

bow_5_palette bow_5_palette (
	.index (rom_q),
	.red   (palette_red),
	.green (palette_green),
	.blue  (palette_blue)
);

endmodule
