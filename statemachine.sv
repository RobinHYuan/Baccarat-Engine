module statemachine(
                        input logic slow_clock, input logic resetb,
                        input logic [3:0] dscore, input logic [3:0] pscore, input logic [3:0] pcard3,
                        output logic load_pcard1, output logic load_pcard2, output logic load_pcard3,
                        output logic load_dcard1, output logic load_dcard2, output logic load_dcard3,
                        output logic player_win_light, output logic dealer_win_light
                    );

    `define reset   3'b000
    `define card_P1 3'b001
    `define card_D1 3'b010
    `define card_P2 3'b011
    `define card_D2 3'b100
    `define card_P3 3'b101 
    `define card_D3 3'b110
    `define halt    3'b111

    logic [2:0] current_state;
	 logic P3toD3 ;
	 assign P3toD3=  ((dscore == 4'd6) && (pcard3>4'd5) && (pcard3<4'd8)) ||
                     ((dscore == 4'd5) && (pcard3>4'd3) && (pcard3<4'd8)) ||
                     ((dscore == 4'd4) && (pcard3>4'd1) && (pcard3<4'd8)) ||
                     ((dscore == 4'd3) && (pcard3!==4'd8)) || 
                     ((dscore <  4'd3) );

    always@( negedge slow_clock ) begin
        if(!resetb) current_state = `reset;
        else 	
				case (current_state) 			
                `reset   : current_state = `card_P1;
                `card_P1 : current_state = `card_D1;
                `card_D1 : current_state = `card_P2;
                `card_P2 : current_state = `card_D2;
                `card_D2 : if  ( (pscore < 4'd6) && (dscore <4'd8))  current_state = `card_P3;  
										else if  ((( pscore == 4'd6) || (pscore == 4'd7)) && (dscore < 4'd6))  current_state = `card_D3; 
												else  if ((pscore>7) || (dscore >7)) current_state =`halt;
                                                        else current_state = `halt; 
                `card_P3 : if (P3toD3) current_state = `card_D3;
                           else current_state = `halt;
                `card_D3: current_state = `halt;
			    `halt: current_state =`halt;
                default: current_state = `reset;
        endcase 
    


        case(current_state) 
            `reset   : {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b000_000_00;
            `card_P1 : {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b100_000_00;  
            `card_D1 : {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b000_100_00;
            `card_P2 : {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b010_000_00;
            `card_D2 : {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b000_010_00;
            `card_P3 : {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b001_000_00;
            `card_D3 : {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b000_001_00;
            `halt    : if        (dscore > pscore) {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b000_000_01;
                        else if  (dscore < pscore) {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b000_000_10;
                            else                   {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b000_000_11;
            default  : {load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3,player_win_light,dealer_win_light} = 8'b000_000_00;
        endcase
    end
endmodule

