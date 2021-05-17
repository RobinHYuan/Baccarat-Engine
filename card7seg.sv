/*======================================
This is a purely combinational module
used for driving the 7-segment display
on the DE1-SOC using its slider swithces
=======================================*/


module card7seg(input logic [3:0] SW, output logic [6:0] HEX0 );
always_comb 
	case(SW)
  	4'b0_000: HEX0 = 7'b1_111_111; // 0
  	4'b0_001: HEX0 = 7'b0_001_000; // 1
  	4'b0_010: HEX0 = 7'b0_100_100; // 2
	4'b0_011: HEX0 = 7'b0_110_000; // 3
    4'b0_100: HEX0 = 7'b0_011_001; // 4
  	4'b0_101: HEX0 = 7'b0_010_010; // 5
	4'b0_110: HEX0 = 7'b0_000_010; // 6
  	4'b0_111: HEX0 = 7'b1_111_000; // 7 
	4'b1_000: HEX0 = 7'b0_000_000; // 8
	4'b1_001: HEX0 = 7'b0_010_000; // 9
  	4'b1_010: HEX0 = 7'b1_000_000; //10
    4'b1_011: HEX0 = 7'b1_100_001; // J
    4'b1_100: HEX0 = 7'b0_011_000; // Q
    4'b1_101: HEX0 = 7'b0_001_001; // K
	default : HEX0 = 7'b0_001_110; // F 
	endcase
endmodule

