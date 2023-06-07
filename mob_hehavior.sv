module mob_behavior (
	input Clk, alive,
	input [255:0][4:0] map,
	input [15:0] steve_x, steve_y,
	input [7:0] mob_seen, mob_aimed,
	input shoot, respawn,
	output logic [255:0][3:0] mob_map,
	output logic [7:0] who_shoot,
	output logic [6:0] score = 7'h0
);

	int counter = 0;
	int mob_cnt, j;
	logic [7:0] i, loc;
	
	always_ff @ (posedge Clk) begin
		who_shoot <= 8'h0;
		if (respawn) begin
			score <= 7'h0;
			mob_cnt <= 0;
			for(j=0; j<256; j=j+1)
				mob_map[j] <= 4'b0;
		end
		else if (alive) begin
			if (counter == 30000000) begin
				i <= i + 1;
				unique case (mob_map[i])
					4'b1001: mob_map[i] <= 4'b1010;
					4'b1010: mob_map[i] <= 4'b1011;
					4'b1011: begin
						mob_map[i] <= 4'b1000;
						who_shoot <= i;
					end
					4'b1100: mob_map[i] <= 4'b1101;
					4'b1101: mob_map[i] <= 4'b1110;
					4'b1110: mob_map[i] <= 4'b1111;
					4'b1111: mob_map[i] <= 4'b0000;
					default: ;
				endcase
			
				if (i == 8'd255)
					counter <= 0;
			end
			else begin
				counter <= counter + 1;
				if (shoot && mob_map[mob_aimed][3:2] == 2'b10) begin
					mob_map[mob_aimed] <= 4'b1100;
					mob_cnt <= mob_cnt - 1;
					score <= (score < 7'd99)? score + 1: 7'd99;
				end
				else if (mob_map[mob_seen] == 4'b1000)
					mob_map[mob_seen] <= 4'b1001;
				else begin
					loc <= loc + 8'd73;
					if ((~map[loc][4] & ~mob_map[loc][3]) && mob_cnt < 7 && (steve_x[15:8]-loc[3:0])*(steve_x[15:8]-loc[3:0]-8'h1) + (steve_y[15:8]-loc[7:4])*(steve_y[15:8]-loc[7:4]-8'h1) > 20) begin
						mob_map[loc] <= 4'b1000;
						mob_cnt <= mob_cnt + 1;
					end
				end
			end
		end
	end
		
endmodule
