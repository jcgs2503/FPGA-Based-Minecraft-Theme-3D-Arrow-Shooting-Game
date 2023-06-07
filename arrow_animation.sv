module arrow_animation(
	input Clk, alive, vga_clk,
	input logic [7:0] who_shoot,
	input [15:0] steve_x,
	input [15:0] steve_y,
	input [9:0] vga_x, vga_y,
	output a,
	output hit
);

//logic [31:0] memory [0:7];
// 
//assign memory[1] = {steve_x, steve_y};
//
//always_ff @ (posedge Clk) begin
//	if(who_shoot > 0)  
//		memory[0] <= {8'b0, who_shoot, angle};
//	else
//		memory[0] <= {8'b0, memory[0][23:16], angle};
//	
//	if(AVL_READ) 
//		q <= memory[AVL_ADDR];
//	
//	if(AVL_WRITE && AVL_ADDR == 3'd0) 
//		memory[0] <= AVL_WRITE_DATA;
//	else if(AVL_WRITE && AVL_ADDR == 3'd2)
//		memory[2] <= AVL_WRITE_DATA;
//	else if(AVL_WRITE && AVL_ADDR == 3'd3)
//		memory[3] <= AVL_WRITE_DATA;
//	else if(AVL_WRITE && AVL_ADDR == 3'd4)
//		memory[4] <= AVL_WRITE_DATA;
//	else if(AVL_WRITE && AVL_ADDR == 3'd5)
//		memory[5] <= AVL_WRITE_DATA;
//	else if(AVL_WRITE && AVL_ADDR == 3'd6)
//		memory[6] <= AVL_WRITE_DATA;
//	else if(AVL_WRITE && AVL_ADDR == 3'd7)
//		memory[7] <= AVL_WRITE_DATA;	
//end
//
//int i;
//logic [9:0] arrow_vga_x [0:11];
//logic [5:0] length [0:11];
//logic [9:0] within_range;
//logic arrow;
//
//always_comb begin
//	for( i = 0; i <= 9; i++ ) begin
//		if( ~i[0] )
//			{ arrow_vga_x[i] , length[i] } = memory[(i>>1) + 2][31:16];
//		else          		       
//			{ arrow_vga_x[i] , length[i] } = memory[(i>>1) + 2][15:0];
//	end
//	
//	for( i = 0; i <= 9; i++ ) begin
//		if( arrow_vga_x[i] > 0 && vga_x <= arrow_vga_x[i] + (length[i]>>1) && vga_x >= arrow_vga_x[i] - (length[i]>>1)) 
//			within_range[i] = 1'b1;
//		else 
//			within_range[i] = 1'b0;
//	end
//	
//	if((within_range > 10'h0) && vga_y <= 241 && vga_y >= 237) begin
//		r = 4'hf;
//		g = 4'h0;
//		b = 4'h0;
//		a = 1'b1;
//	end else begin
//		r = 4'h0;
//		g = 4'h0;
//		b = 4'h0;
//		a = 1'b0;
//	end
//end
//
//assign hit = memory[7] > 0 ? 1'b1 : 1'b0;
//assign who_shot = memory[7][7:0];

int frame_counter = 0;
logic arrow;
logic [7:0] aim_x, aim_y;

always_ff @(posedge Clk) begin
	if(who_shoot > 0 && frame_counter == 0) begin
		aim_x <= steve_x[15:8];
		aim_y <= steve_y[15:8];
		frame_counter <= 1;
	end else if (frame_counter > 0 && frame_counter < 15000000) begin
		aim_x <= aim_x;
		aim_y <= aim_y;
		frame_counter <= frame_counter + 1;
	end else if (frame_counter == 15000000) begin
		if(steve_x[15:8]==aim_x && steve_y[15:8]==aim_y) begin
			hit <= 1'b1;
			arrow <= 1'b1;
		end
		frame_counter <= frame_counter + 1;
	end
	else if (frame_counter > 15000000 && frame_counter < 25000000) begin
		frame_counter <= frame_counter + 1;
		arrow <= arrow;
		hit <= hit;
	end else if (frame_counter >= 25000000 && frame_counter < 27000000) begin
		frame_counter <= frame_counter + 1;
		arrow <= arrow;
		hit <= 1'b0;
	end else if (frame_counter == 27000000) begin
		aim_x <= 8'b0;
		aim_y <= 8'b0;
		arrow <= 1'b0;
		hit <= 1'b0;
		frame_counter <= 0;
	end
end

//assign a = (arrow & color_a);
assign a = arrow;

endmodule