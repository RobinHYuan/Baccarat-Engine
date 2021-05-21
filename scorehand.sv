module scorehand(input logic [3:0] card1, input logic [3:0] card2, input logic [3:0] card3, output logic [3:0] total);

logic [3:0] score1, score2, score3;
logic [6:0] temp;
assign score1 = card1 > 4'b1001 ? 4'b0000 : card1;
assign score2 = card2 > 4'b1001 ? 4'b0000 : card2;
assign score3 = card3 > 4'b1001 ? 4'b0000 : card3;

assign temp  = (score1 + score2 + score3) % 4'd10;
assign total = temp[3:0];

endmodule
