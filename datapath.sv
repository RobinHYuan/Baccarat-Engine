module datapath(input logic slow_clock, input logic fast_clock, input logic resetb,
                input logic load_pcard1, input logic load_pcard2, input logic load_pcard3,
                input logic load_dcard1, input logic load_dcard2, input logic load_dcard3,
                output logic [3:0] pcard3_out,
                output logic [3:0] pscore_out, output logic [3:0] dscore_out,
                output logic [6:0] HEX5, output logic [6:0] HEX4, output logic [6:0] HEX3,
                output logic [6:0] HEX2, output logic [6:0] HEX1, output logic [6:0] HEX0);


        logic [3:0] new_card,pcard1_out,pcard2_out,dcard1_out,dcard2_out,dcard3_out;
  

        dealcard newcard(fast_clock, resetb, new_card);

        //reg4 PCard1(resetb, slow_clock, new_card, load_pcard1, pcard1_out);
        //reg4 PCard2(resetb, slow_clock, new_card,     load_pcard2, pcard2_out);
        //reg4 PCard3(resetb, slow_clock, new_card, load_pcard3, pcard3_out);
        //reg4 DCard1(resetb, slow_clock, new_card, load_dcard1, dcard1_out);
        //reg4 DCard2(resetb, slow_clock, new_card, load_dcard2, dcard2_out);
        //reg4 DCard3(resetb, slow_clock, new_card, load_dcard3, dcard3_out);
        always@( posedge slow_clock ) begin 
                if (resetb==0) {pcard1_out, pcard2_out, pcard3_out, dcard1_out, dcard2_out, dcard3_out} = 0;
                else begin
                        case ({load_pcard1,load_pcard2,load_pcard3,load_dcard1,load_dcard2,load_dcard3})
                        6'b100_000: {pcard1_out, pcard2_out, pcard3_out, dcard1_out, dcard2_out, dcard3_out} ={new_card,   pcard2_out, pcard3_out, dcard1_out, dcard2_out, dcard3_out};
                        6'b010_000: {pcard1_out, pcard2_out, pcard3_out, dcard1_out, dcard2_out, dcard3_out} ={pcard1_out, new_card,   pcard3_out, dcard1_out, dcard2_out, dcard3_out};
                        6'b001_000: {pcard1_out, pcard2_out, pcard3_out, dcard1_out, dcard2_out, dcard3_out} ={pcard1_out, pcard2_out, new_card,   dcard1_out, dcard2_out, dcard3_out};
                        6'b000_100: {pcard1_out, pcard2_out, pcard3_out, dcard1_out, dcard2_out, dcard3_out} ={pcard1_out, pcard2_out, pcard3_out, new_card,   dcard2_out, dcard3_out};
                        6'b000_010: {pcard1_out, pcard2_out, pcard3_out, dcard1_out, dcard2_out, dcard3_out} ={pcard1_out, pcard2_out, pcard3_out, dcard1_out, new_card,   dcard3_out};
                        6'b000_001: {pcard1_out, pcard2_out, pcard3_out, dcard1_out, dcard2_out, dcard3_out} ={pcard1_out, pcard2_out, pcard3_out, dcard1_out, dcard2_out, new_card};
                        default:    {pcard1_out, pcard2_out, pcard3_out, dcard1_out, dcard2_out, dcard3_out} ={pcard1_out, pcard2_out, pcard3_out, dcard1_out, dcard2_out, dcard3_out};
                        endcase
                end   
                
        end




        scorehand Player(pcard1_out, pcard2_out, pcard3_out, pscore_out);
        scorehand Dealer(dcard1_out, dcard2_out, dcard3_out, dscore_out);
 
        card7seg cardP1(pcard1_out, HEX0 );
        card7seg cardP2(pcard2_out, HEX1 );
        card7seg cardP3(pcard3_out, HEX2 );

        card7seg cardD1(dcard1_out, HEX3 );
        card7seg cardD2(dcard2_out, HEX4 );
        card7seg cardD3(dcard3_out, HEX5 );
endmodule

 /*===============================================================
 Module-Reg4:
 This module is used  to store the card on player's/dealer's hands.
 It should include a reset function; howerver, due to the nature of 
 low-active reset and the reverse keybind of DE1_SoC, it will only 
 perform reset iff we see falling edge of the "slow clock (Key0)"
 and Key1 is also pressed indicating that resetb == 0.
 =================================================================*/

module reg4 (resetb,clk,in,load,out);
    parameter n = 4 ;
    input  clk, load, resetb;
    input  [n-1:0]  in;
    output reg [n-1:0] out;
    wire   [n-1:0] mux_out;

    assign mux_out = load ? in:out;
    always @( posedge clk)
        if(resetb == 0) out = 0;
        else out = mux_out;
endmodule


