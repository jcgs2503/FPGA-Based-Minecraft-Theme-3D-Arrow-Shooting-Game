module mob_texture (
	input Clk,
	input [3:0] pxl_x, 
	input int pxl_y,
   input [1:0] texture_sel,
   output logic [3:0] r, g, b,
	output logic a
);

	localparam [0:31][0:15][2:0] mob0 = {
		{3'd0,3'd0,3'd0,3'd0,3'd2,3'd3,3'd2,3'd3,3'd4,3'd3,3'd2,3'd2,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd3,3'd3,3'd3,3'd2,3'd1,3'd1,3'd2,3'd3,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd3,3'd1,3'd1,3'd1,3'd1,3'd1,3'd1,3'd2,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd2,3'd1,3'd2,3'd1,3'd2,3'd1,3'd2,3'd2,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd1,3'd6,3'd6,3'd1,3'd1,3'd6,3'd6,3'd1,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd3,3'd2,3'd1,3'd4,3'd4,3'd1,3'd2,3'd4,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd3,3'd6,3'd6,3'd6,3'd6,3'd6,3'd6,3'd4,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd4,3'd4,3'd4,3'd4,3'd2,3'd4,3'd2,3'd4,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd3,3'd3,3'd4,3'd4,3'd5,3'd3,3'd3,3'd4,3'd4,3'd4,3'd3,3'd3,3'd0,3'd0},
		{3'd0,3'd0,3'd3,3'd4,3'd5,3'd5,3'd4,3'd5,3'd3,3'd4,3'd5,3'd5,3'd4,3'd3,3'd0,3'd0},
		{3'd0,3'd0,3'd3,3'd2,3'd4,3'd4,3'd5,3'd4,3'd4,3'd5,3'd4,3'd4,3'd2,3'd3,3'd0,3'd0},
		{3'd0,3'd0,3'd4,3'd2,3'd5,3'd4,3'd4,3'd5,3'd5,3'd4,3'd4,3'd5,3'd2,3'd4,3'd0,3'd0},
		{3'd0,3'd0,3'd3,3'd2,3'd4,3'd5,3'd5,3'd4,3'd4,3'd5,3'd5,3'd4,3'd2,3'd3,3'd0,3'd0},
		{3'd0,3'd0,3'd3,3'd3,3'd0,3'd3,3'd0,3'd4,3'd4,3'd0,3'd3,3'd0,3'd3,3'd3,3'd0,3'd0},
		{3'd0,3'd0,3'd3,3'd4,3'd0,3'd4,3'd3,3'd3,3'd2,3'd4,3'd4,3'd0,3'd4,3'd3,3'd0,3'd0},
		{3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0},
		{3'd0,3'd0,3'd2,3'd3,3'd7,3'd0,3'd0,3'd3,3'd2,3'd0,3'd0,3'd0,3'd3,3'd2,3'd0,3'd0},
		{3'd0,3'd0,3'd3,3'd3,3'd7,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0},
		{3'd0,3'd0,3'd4,3'd4,3'd7,3'd2,3'd3,3'd2,3'd3,3'd4,3'd3,3'd3,3'd4,3'd4,3'd0,3'd0},
		{3'd0,3'd0,3'd4,3'd4,3'd7,3'd3,3'd3,3'd3,3'd2,3'd2,3'd2,3'd3,3'd4,3'd4,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd7,3'd3,3'd3,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd7,3'd3,3'd4,3'd0,3'd0,3'd4,3'd3,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd7,3'd3,3'd2,3'd0,3'd0,3'd2,3'd3,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd7,3'd4,3'd2,3'd0,3'd0,3'd2,3'd4,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd2,3'd0,3'd0,3'd2,3'd3,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd4,3'd0,3'd0,3'd4,3'd3,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd2,3'd3,3'd0,3'd0,3'd3,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd4,3'd4,3'd0,3'd0,3'd4,3'd4,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd4,3'd4,3'd0,3'd0,3'd4,3'd4,3'd0,3'd0,3'd0,3'd0,3'd0}
	};
	
	localparam [0:31][0:15][2:0] mob1 = {
		{3'd0,3'd0,3'd0,3'd0,3'd2,3'd3,3'd2,3'd3,3'd4,3'd3,3'd2,3'd2,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd3,3'd3,3'd3,3'd2,3'd1,3'd1,3'd2,3'd3,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd3,3'd1,3'd1,3'd7,3'd1,3'd1,3'd1,3'd2,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd2,3'd1,3'd7,3'd7,3'd2,3'd1,3'd2,3'd2,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd1,3'd6,3'd7,3'd1,3'd1,3'd6,3'd6,3'd1,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd3,3'd7,3'd7,3'd4,3'd4,3'd1,3'd2,3'd4,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd3,3'd7,3'd6,3'd6,3'd6,3'd6,3'd6,3'd4,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd7,3'd7,3'd4,3'd4,3'd2,3'd4,3'd2,3'd4,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd4,3'd4,3'd7,3'd4,3'd5,3'd3,3'd3,3'd4,3'd4,3'd4,3'd4,3'd4,3'd0,3'd0},
		{3'd0,3'd0,3'd4,3'd7,3'd7,3'd5,3'd4,3'd5,3'd3,3'd4,3'd5,3'd5,3'd4,3'd4,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd7,3'd4,3'd4,3'd5,3'd4,3'd4,3'd5,3'd4,3'd4,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd7,3'd7,3'd5,3'd4,3'd4,3'd5,3'd5,3'd4,3'd4,3'd5,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd7,3'd0,3'd4,3'd5,3'd5,3'd4,3'd4,3'd5,3'd5,3'd4,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd7,3'd7,3'd0,3'd0,3'd3,3'd0,3'd4,3'd4,3'd0,3'd3,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd7,3'd0,3'd0,3'd0,3'd4,3'd3,3'd3,3'd2,3'd4,3'd4,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd7,3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd2,3'd2,3'd3,3'd2,3'd3,3'd4,3'd3,3'd3,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd2,3'd3,3'd3,3'd3,3'd2,3'd2,3'd2,3'd3,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd4,3'd0,3'd0,3'd4,3'd3,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd2,3'd0,3'd0,3'd2,3'd3,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd4,3'd2,3'd0,3'd0,3'd2,3'd4,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd2,3'd0,3'd0,3'd2,3'd3,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd4,3'd0,3'd0,3'd4,3'd3,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd2,3'd3,3'd0,3'd0,3'd3,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd4,3'd4,3'd0,3'd0,3'd4,3'd4,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd4,3'd4,3'd0,3'd0,3'd4,3'd4,3'd0,3'd0,3'd0,3'd0,3'd0}
	};
	
	localparam [0:31][0:15][2:0] mob2 = {
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd2,3'd3,3'd4,3'd3,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd2,3'd1,3'd1,3'd2,3'd3,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd1,3'd1,3'd1,3'd1,3'd1,3'd1,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd2,3'd1,3'd2,3'd1,3'd2,3'd1,3'd2,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd1,3'd6,3'd6,3'd1,3'd1,3'd6,3'd6,3'd1,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd3,3'd2,3'd1,3'd4,3'd4,3'd1,3'd2,3'd4,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd3,3'd6,3'd6,3'd6,3'd6,3'd6,3'd6,3'd4,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd4,3'd4,3'd4,3'd4,3'd2,3'd4,3'd2,3'd4,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd7,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd7,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd4,3'd4,3'd4,3'd0},
		{3'd0,3'd0,3'd7,3'd0,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd5,3'd3,3'd4,3'd5,3'd5,3'd0},
		{3'd0,3'd0,3'd0,3'd7,3'd0,3'd2,3'd0,3'd0,3'd4,3'd5,3'd4,3'd4,3'd5,3'd4,3'd4,3'd0},
		{3'd0,3'd0,3'd0,3'd7,3'd0,3'd0,3'd2,3'd5,3'd4,3'd4,3'd5,3'd5,3'd4,3'd4,3'd5,3'd0},
		{3'd0,3'd0,3'd0,3'd7,3'd0,3'd0,3'd0,3'd2,3'd5,3'd5,3'd4,3'd4,3'd5,3'd5,3'd4,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd7,3'd0,3'd4,3'd4,3'd2,3'd0,3'd4,3'd4,3'd0,3'd3,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd7,3'd4,3'd4,3'd0,3'd4,3'd2,3'd3,3'd2,3'd4,3'd4,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd7,3'd4,3'd0,3'd0,3'd0,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd7,3'd7,3'd0,3'd0,3'd0,3'd2,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd7,3'd7,3'd7,3'd0,3'd2,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd4,3'd0,3'd0,3'd7,3'd7,3'd7,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd2,3'd3,3'd0,3'd0,3'd3,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd3,3'd3,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd4,3'd4,3'd0,3'd0,3'd4,3'd4,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd4,3'd4,3'd0,3'd0,3'd4,3'd4,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0}
	};
	
	localparam [0:31][0:15][2:0] mob3 = {
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd3,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd3,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd3,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd2,3'd2,3'd0,3'd0,3'd0,3'd0,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd2,3'd2,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd2,3'd2,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd2,3'd2,3'd2,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd2,3'd2,3'd0,3'd0,3'd0,3'd2,3'd0,3'd2,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd2,3'd0,3'd0,3'd2,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd2,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd2,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd1,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd2,3'd0,3'd0,3'd0,3'd2,3'd0,3'd0,3'd0,3'd3,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd1,3'd1,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd1,3'd0,3'd0,3'd1,3'd1,3'd1,3'd1,3'd1,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd1,3'd1,3'd1,3'd1,3'd0,3'd1,3'd1,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd1,3'd0,3'd0,3'd0,3'd1,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd2,3'd0,3'd0,3'd0,3'd0,3'd1,3'd0,3'd1,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd2,3'd0,3'd0,3'd0,3'd1,3'd1,3'd1,3'd0,3'd2,3'd0,3'd0,3'd2,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd1,3'd1,3'd0,3'd0,3'd0,3'd2,3'd2,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd1,3'd1,3'd1,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd1,3'd1,3'd1,3'd1,3'd1,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd1,3'd1,3'd1,3'd1,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd1,3'd1,3'd1,3'd0,3'd1,3'd1,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd1,3'd1,3'd1,3'd1,3'd1,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd1,3'd1,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0},
		{3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0,3'd0}
	};
	
	localparam [0:7][11:0] palette = {
		12'h000,
		12'hccc,
		12'hbbb,
		12'h999,
		12'h777,
		12'h555,
		12'h333,
		12'h642
	};
	
	logic [3:0] q;
	
	always_comb begin
		unique case (texture_sel)
			2'd0: q <= mob0[pxl_y][pxl_x];
			2'd1: q <= mob1[pxl_y][pxl_x];
			2'd2: q <= mob2[pxl_y][pxl_x];
			2'd3: q <= mob3[pxl_y][pxl_x];
		endcase
	end
	
	always_ff @ (posedge Clk) begin
		if (q == 3'b0)
			a <= 1'b0;
		else 
			a <= 1'b1;
		
		if (texture_sel == 2'd2) begin
			r <= palette[q][11:8] + 4'd3;
			g <= palette[q][7:4] - 4'd2;
			b <= palette[q][3:0] - 4'd2;
		end
		else begin
			r <= palette[q][11:8];
			g <= palette[q][7:4];
			b <= palette[q][3:0];
		end
	end

endmodule
