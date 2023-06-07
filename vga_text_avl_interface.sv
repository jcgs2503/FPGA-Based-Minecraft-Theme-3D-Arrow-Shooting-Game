/************************************************************************
Avalon-MM Interface VGA Text mode display

Registers:
0x000-0x00f : map (2 bits X 16 X 16)
0x258       : control register

VRAM Format:
X->
[ 31  30-24][ 23  22-16][ 15  14-8 ][ 7    6-0 ]
[IV3][CODE3][IV2][CODE2][IV1][CODE1][IV0][CODE0]

Control Register Format:
[[31-25][24-21][20-17][16-13][ 12-9][ 8-5 ][ 4-1 ][   0    ] 
[[RSVD ][FGD_R][FGD_G][FGD_B][BKG_R][BKG_G][BKG_B][RESERVED]


************************************************************************/
module vga_text_avl_interface (
	// Avalon Clock Input, note this clock is also used for VGA, so this must be 50Mhz
	// We can put a clock divider here in the future to make this IP more generalizable
	input logic CLK,
	
	// Avalon Reset Input
	input logic RESET,
	
	// Avalon-MM Slave Signals
	input logic AVL_READ,						// Avalon-MM Read
	input logic AVL_WRITE,						// Avalon-MM Write
	input logic AVL_CS,							// Avalon-MM Chip Select
	input logic [3:0] AVL_BYTE_EN,			// Avalon-MM Byte Enable
	input logic [10:0] AVL_ADDR,				// Avalon-MM Address
	input logic [31:0] AVL_WRITEDATA,		// Avalon-MM Write Data
	output logic [31:0] AVL_READDATA,		// Avalon-MM Read Data
	
	// Exported Conduit (mapped to VGA port - make sure you export in Platform Designer)
	output logic [3:0] red, green, blue,	// VGA color channels (mapped to output pins in top-level)
	output logic hs, vs							// VGA HS/VS
);

	//registers
	logic [255:0][4:0] map_ram; // {is_wall, [3:0] wall_texture}
	logic [255:0][3:0] mob_ram; // {is_mob, [1:0] mob_action, buffer}
	logic [7:0] keycode;
	logic [3:0] bow_state;
	logic [7:0] mob_seen, mob_aimed, who_shoot; // {[3:0] row, [3:0] col}
	logic shoot, alive, respawn;
	logic [3:0] health;
	logic [6:0] score;
	
	// wires
	logic vga_clk, vga_blank, sync;
	logic [9:0] vga_x, vga_y;
	logic [9:0] ray_id;
	logic [15:0] steve_x, steve_y;
	shortint angle, dir;
	
	// ray ram
	logic ray_wall_wren, ray_mob_wren;
	logic [31:0] ray_wall_data, ray_wall_q;
	logic [31:0] ray_mob_data, ray_mob_q;
	
	ray_ram ram_wall (
		CLK,
		ray_wall_data,
		vga_x,
		1'b1,
		ray_id,
		ray_wall_wren,
		ray_wall_q
	);
	
	ray_ram ram_mob (
		CLK,
		ray_mob_data,
		vga_x,
		1'b1,
		ray_id,
		ray_mob_wren,
		ray_mob_q
	);
	
	// tri ram
	logic [9:0] tri_addr_a, tri_addr_b;
	logic [31:0] tri_q_a, tri_q_b;
	logic [31:0] tri_center, tri_ray;
	
	tri_ram ram1 (
		tri_addr_a,
		tri_addr_b,
		CLK,
		AVL_WRITEDATA,
		32'b0,
		1'b1,
		1'b1,
		(AVL_ADDR[10] & AVL_WRITE),
		1'b0,
		tri_q_a,
		tri_q_b
	);
		
	always_comb begin
		if (AVL_ADDR[10] & AVL_WRITE) begin
			tri_addr_a = AVL_ADDR[9:0];
			tri_center = 32'h0;
		end
		else begin
			if (angle < 601) begin
				tri_addr_a = angle;
				tri_center = tri_q_a;
			end
			else if (angle < 1201) begin
				tri_addr_a = 1200 - angle;
				tri_center = {tri_q_a[31:16], ~tri_q_a[15:0]+16'h1};
			end
			else if (angle < 1801) begin
				tri_addr_a = angle - 1200;
				tri_center = {~tri_q_a[31:16]+16'h1, ~tri_q_a[15:0]+16'h1};
			end
			else begin
				tri_addr_a = 2400 - angle;
				tri_center = {~tri_q_a[31:16]+16'h1, tri_q_a[15:0]};
			end
		end
		
		dir = angle + 16'd320 - ray_id;
		if (dir < 0) begin
			tri_addr_b = -dir;
			tri_ray = {~tri_q_b[31:16]+16'h1, tri_q_b[15:0]};
		end
		else if (dir < 601) begin
			tri_addr_b = dir;
			tri_ray = tri_q_b;
		end
		else if (dir < 1200) begin
			tri_addr_b = 1200 - dir;
			tri_ray = {tri_q_b[31:16], ~tri_q_b[15:0]+16'h1};
		end
		else if (dir < 1801) begin
			tri_addr_b = dir - 1200;
			tri_ray = {~tri_q_b[31:16]+16'h1, ~tri_q_b[15:0]+16'h1};
		end
		else if (dir < 2400) begin
			tri_addr_b = 2400 - dir;
			tri_ray = {~tri_q_b[31:16]+16'h1, tri_q_b[15:0]};
		end
		else begin
			tri_addr_b = dir - 2400;
			tri_ray = tri_q_b;
		end
	end
	
	steve steve0 (
		CLK, 
		RESET,
		keycode,
		map_ram,
		mob_ram,
		tri_center,
		who_shoot,
		hit,
		steve_x,
		steve_y,
		angle,
		bow_state,
		shoot,
		health,
		alive,
		respawn
	);
	
	mob_behavior mobs(
		CLK,
		alive,
		map_ram,
		steve_x,
		steve_y,
		mob_seen, 
		mob_aimed,
		shoot,
		respawn,
		mob_ram,
		who_shoot,
		score
	);
	
	raycasting raycasting (
		CLK,
		RESET,
		map_ram,
		mob_ram,
		steve_x,
		steve_y,
		tri_center,
		tri_ray,
		ray_id,
		ray_wall_data,
		ray_wall_wren,
		ray_mob_data,
		ray_mob_wren,
		mob_seen,
		mob_aimed
	);
	
	vga_controller vga(
		CLK, 
		RESET, 
		hs, 
		vs, 
		vga_clk, 
		vga_blank, 
		sync, 
		vga_x, 
		vga_y
	);
	
	color_mapper mapper (
		CLK,
		vga_clk,
		vga_blank,
		vga_x, 
		vga_y, 
		health,
		score,
		alive,
		ray_wall_q,
		ray_mob_q,
		bow_state,
		arrow_a,
		red, 
		green, 
		blue
	);
	
	logic arrow_a;
	logic hit;
	
	arrow_animation arrow (
		CLK, 
		alive, 
		vga_clk,
	   who_shoot,
		steve_x,
		steve_y,
		vga_x, 
		vga_y,
		arrow_a,
		hit
	);

	
	always_ff @ (posedge CLK) begin
		if (AVL_WRITE & AVL_CS) begin
			if (AVL_ADDR == 0)
				keycode <= AVL_WRITEDATA[7:0];
			else if (~AVL_ADDR[10] & AVL_ADDR[9]) begin
				if (AVL_BYTE_EN[0])
					map_ram[{AVL_ADDR[5:0], 2'd0}] <= AVL_WRITEDATA[7:0];
				if (AVL_BYTE_EN[1])
					map_ram[{AVL_ADDR[5:0], 2'd1}] <= AVL_WRITEDATA[15:8];
				if (AVL_BYTE_EN[2])
					map_ram[{AVL_ADDR[5:0], 2'd2}] <= AVL_WRITEDATA[23:16];
				if (AVL_BYTE_EN[3])
					map_ram[{AVL_ADDR[5:0], 2'd3}] <= AVL_WRITEDATA[31:24];
			end
		end
	end

endmodule
