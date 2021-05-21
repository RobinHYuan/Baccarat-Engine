module tb_statemachine();

    logic slow_clock, resetb, reset, err, player_win_light,  dealer_win_light;
    logic load_pcard1, load_pcard2, load_pcard3;
    logic load_dcard1, load_dcard2, load_dcard3;
    logic [3:0] pcard3_out;
    logic [3:0] pscore_out,dscore_out;

 statemachine DUT
                    (
                        slow_clock,  resetb,
                        dscore_out,  pscore_out,  pcard3_out,
                        load_pcard1,  load_pcard2,  load_pcard3,
                        load_dcard1,  load_dcard2,  load_dcard3,
                        player_win_light,  dealer_win_light
                    );

   /*========================================
        Slow Clock Setup:
        Set all signals to the appropriate states
     ===========================================*/
    initial forever begin 
        slow_clock = ! slow_clock; #5;
    end

    /*========================================
        Setup:
        Set all signals to the appropriate states
     ===========================================*/
    initial begin
        slow_clock = 0; err = 0; resetb = 1;
        pscore_out = 0; dscore_out = 0; #15;

        resetb = 0; #15;
        assert (
                DUT.current_state == 3'b000 &&
                (load_pcard1 | load_pcard2 | load_pcard3) == 0 &&
                (load_dcard1 | load_dcard2 | load_dcard3) == 0 &&
                ( player_win_light |  dealer_win_light)   == 0
                )$display("Check: Reset done at  %d ns",$time);
        else begin $error("Reset failed"); err = 1; end #15;
        resetb = 1; #10;

        assert (
                DUT.current_state == 3'b001 &&
                (!load_pcard1 | load_pcard2 | load_pcard3) == 0 &&
                (load_dcard1 | load_dcard2 | load_dcard3)  == 0 &&
                ( player_win_light |  dealer_win_light)    == 0
                ) $display("Check: card_P1 done at%d ns",$time);
        else begin $error("Erros Found in State: card_P1"); err = 1; end #10;
      

        assert (
                DUT.current_state == 3'b010 &&
                (load_pcard1 |  load_pcard2| load_pcard3) == 0 &&
                (!load_dcard1 | load_dcard2 | load_dcard3)  == 0 &&
                ( player_win_light |  dealer_win_light)    == 0
                ) $display("Check: card_D1 done at%d ns",$time);
        else begin $error("Erros Found in State: card_D1"); err = 1; end #10;

        assert (
                DUT.current_state == 3'b011 &&
                (load_pcard1 | !load_pcard2 | load_pcard3) == 0 &&
                (load_dcard1 | load_dcard2 | load_dcard3)  == 0 &&
                ( player_win_light |  dealer_win_light)    == 0
                ) $display("Check: card_P2 done at%d ns",$time);
        else begin $error("Erros Found in State: card_P2"); err = 1; end #10;
       

        assert (
                DUT.current_state == 3'b100 &&
                (load_pcard1 | load_pcard2 |load_pcard3) == 0 &&
                (load_dcard1 | !load_dcard2 | load_dcard3)  == 0 &&
                ( player_win_light |  dealer_win_light)    == 0
                ) $display("Check: card_D2 done at%d ns",$time);
        else begin $error("Erros Found in State: card_D2"); err = 1; end 
        
        /*===============================================================
        Case 1:
        The game is over when either the player/dealer gets a score 
        of 8 or 9 
        ================================================================*/
        pscore_out = 8; #15;
        assert (
                DUT.current_state == 3'b111 &&
                (load_pcard1| load_pcard2 | load_pcard3) == 0 &&
                (load_dcard1 | load_dcard2 | load_dcard3)  == 0 &&
                ( !player_win_light &&  dealer_win_light)    == 0
                ) $display("Check: Halt[1] done at%d ns",$time);
        else begin $error("Erros Found in State: Halt[1]"); err = 1; end 



        /*===============================================================
        Case 2-a:
        Player score <=5 whereas the banker has a score of 7.
        The player gets a third card where then banker does not
        ================================================================*/
        resetb = 0; #15;
        resetb = 1; #45;
        assert(DUT.current_state == 3'b100) $display("State: card_D2  Time: %d ns", $time);

        pscore_out = 5; dscore_out = 7;# 5;
        assert (
                DUT.current_state == 3'b101 && // player gets a third card
                (load_pcard1 | load_pcard2 | !load_pcard3) == 0 &&
                (load_dcard1 | load_dcard2 | load_dcard3) == 0 &&
                ( player_win_light &&  dealer_win_light) == 0
                ) $display("Check: P3[2-A] done at%d ns",$time);
        else begin $error("Erros Found in State: P3[2-A]"); err = 1; end #10;

        assert (
                DUT.current_state == 3'b111 &&// dealer does NOT get a third card; game ends
                (load_pcard1 | load_pcard2 | load_pcard3) == 0 &&
                (load_dcard1 | load_dcard2 | load_dcard3) == 0 &&
                ( player_win_light &&  !dealer_win_light) == 0
                ) $display("Check: Halt[2-A] done at%d ns",$time);
        else begin $error("Erros Found in State: Halt[2-A]"); err = 1; end #15;
        
        /*===============================================================
        Case 2-b:
        Player score <=5 whereas the banker has a score of 6.
        The player gets a third card where then banker only gets one if 
        the player's third card has a value of 6 or 7
        ================================================================*/
        resetb = 0; #15;
        resetb = 1; #45;
        assert(DUT.current_state == 3'b100) $display("State: card_D2  Time: %d ns", $time);
        pcard3_out = 6;  //pcard3_out = 4;(Tested)
        pscore_out = 5; dscore_out = 6;# 5;
        assert ( DUT.current_state == 3'b101 ) $display("Check: P3[2-B] done at%d ns",$time);
        else begin $error("Erros Found in State: P3[2-B]"); err = 1; end #10;
        assert (
                DUT.current_state == 3'b110 &&// Player gets a third card
                (load_pcard1 | load_pcard2 | load_pcard3) == 0 &&
                (load_dcard1 | load_dcard2 | !load_dcard3) == 0 &&
                ( player_win_light &&  !dealer_win_light) == 0
                ) $display("Check: D3[2-B] done at%d ns",$time);
        else begin $error("Erros Found in State: D3[2-B]"); err = 1; end #15;
        assert (
                DUT.current_state == 3'b111 &&//  game ends
                (load_pcard1 |load_pcard2 | load_pcard3) == 0 &&
                (load_dcard1 | load_dcard2 | load_dcard3) == 0 &&
                ( player_win_light &&  !dealer_win_light) == 0
                ) $display("Check: Halt[2-B] done at%d ns",$time);
        else begin $error("Erros Found in State: Halt[2-B]"); err = 1; end #15;

         /*===============================================================
        Case 2-c:
        Player score <=5 whereas the banker has a score of 5.
        The player gets a third card where then banker only gets one if 
        the player's third card has a value of 4,5, 6 or 7
        ================================================================*/
        resetb = 0; #15;
        resetb = 1; #40;
        assert(DUT.current_state == 3'b100) $display("State: card_D2  Time: %d ns", $time);
        pcard3_out = 4; // pcard3_out = 3;//(Tested)
        pscore_out = 5; dscore_out = 5;# 5;
        assert ( DUT.current_state == 3'b101 ) $display("Check: P3[2-C] done at%d ns",$time);
        else begin $error("Erros Found in State: P3[2-C]"); err = 1; end #10;
        assert (
                DUT.current_state == 3'b110 &&// Player gets a third card
                (load_pcard1 | load_pcard2 | load_pcard3) == 0 &&
                (load_dcard1 | load_dcard2 | !load_dcard3) == 0 &&
                ( player_win_light &&  !dealer_win_light) == 0
                ) $display("Check: D3[2-C] done at%d ns",$time);
        else begin $error("Erros Found in State: D3[2-C]"); err = 1; end #15;
        assert (
                DUT.current_state == 3'b111 &&// game ends
                (load_pcard1 | load_pcard2 | load_pcard3) == 0 &&
                (load_dcard1 | load_dcard2 | load_dcard3) == 0 &&
                ( !player_win_light &&  !dealer_win_light) == 0
                ) $display("Check: Halt[2-C] done at%d ns",$time);
        else begin $error("Erros Found in State: Halt[2-C]"); err = 1; end #15;

        /*===============================================================
        Case 2-D:
        Player score <=5 whereas the banker has a score of 4.
        The player gets a third card where then banker only gets one if 
        the player's third card has a value of 2,3,4,5, 6 or 7
        ================================================================*/
        resetb = 0; #15;
        resetb = 1; #40;
        assert(DUT.current_state == 3'b100) $display("State: card_D2  Time: %d ns", $time);
        pcard3_out = 2; // pcard3_out = 1;//(Tested)
        pscore_out = 5; dscore_out = 4;# 5;
        assert ( DUT.current_state == 3'b101 ) $display("Check: P3[2-D] done at%d ns",$time);
        else begin $error("Erros Found in State: P3[2-D]"); err = 1; end #10;
        assert (
                DUT.current_state == 3'b110 &&// Player gets a third card
                (load_pcard1| load_pcard2 | load_pcard3) == 0 &&
                (load_dcard1 | load_dcard2 | !load_dcard3) == 0 &&
                ( player_win_light &&  !dealer_win_light) == 0
                ) $display("Check: D3[2-D] done at%d ns",$time);
        else begin $error("Erros Found in State: D3[2-D]"); err = 1; end #15;
        assert (
                DUT.current_state == 3'b111 &&// game ends
                (load_pcard1 | load_pcard2 | load_pcard3) == 0 &&
                (load_dcard1 | load_dcard2 | load_dcard3) == 0 &&
                ( !player_win_light &&  dealer_win_light) == 0
                ) $display("Check: Halt[2-D] done at%d ns",$time);
        else begin $error("Erros Found in State: Halt[2-D]"); err = 1; end #15;

        /*===============================================================
        Case 2-E:
        Player score <=5 whereas the banker has a score of 3.
        The player gets a third card where then banker only gets one if 
        the player's third card doesnt have a value of 8.
        ================================================================*/
        resetb = 0; #15;
        resetb = 1; #40;
        assert(DUT.current_state == 3'b100) $display("State: card_D2  Time: %d ns", $time);
        pcard3_out = 0; // pcard3_out = 8;//(Tested)
        pscore_out = 4; dscore_out = 3;# 5;
        assert ( DUT.current_state == 3'b101 ) $display("Check: P3[2-E] done at%d ns",$time);
        else begin $error("Erros Found in State: P3[2-E]"); err = 1; end #10;
        assert (
                DUT.current_state == 3'b110 &&// Player gets a third card
                (load_pcard1 | load_pcard2 | load_pcard3) == 0 &&
                (load_dcard1 | load_dcard2 | !load_dcard3) == 0 &&
                ( player_win_light &&  !dealer_win_light) == 0
                ) $display("Check: D3[2-E] done at%d ns",$time);
        else begin $error("Erros Found in State: D3[2-E]"); err = 1; end #15;
        assert (
                DUT.current_state == 3'b111 &&// game ends
                (load_pcard1 | load_pcard2 | load_pcard3) == 0 &&
                (load_dcard1 | load_dcard2 | load_dcard3) == 0 &&
                ( !player_win_light &&  dealer_win_light) == 0
                ) $display("Check: Halt[2-E] done at%d ns",$time);
        else begin $error("Erros Found in State: Halt[2-E]"); err = 1; end #15;



        /*===============================================================
        Case 2-F:
        Player score <=5 whereas the banker has a score less then 3.
        Both the player and the dealer get a third card 
        ================================================================*/
        resetb = 0; #15;
        resetb = 1; #40;
        assert(DUT.current_state == 3'b100) $display("State: card_D2  Time: %d ns", $time);
        pcard3_out = 0; // pcard3_out = 8;//(Tested)
        pscore_out = 3; dscore_out = 0;# 5;
        assert ( DUT.current_state == 3'b101 ) $display("Check: P3[2-F] done at%d ns",$time);
        else begin $error("Erros Found in State: P3[2-F]"); err = 1; end #10;
        assert (
                DUT.current_state == 3'b110 &&// Player gets a third card
                (load_pcard1 | load_pcard2 | load_pcard3) == 0 &&
                (load_dcard1 | load_dcard2 | !load_dcard3) == 0 &&
                ( player_win_light &&  !dealer_win_light) == 0
                ) $display("Check: D3[2-F] done at%d ns",$time);
        else begin $error("Erros Found in State: D3[2-F]"); err = 1; end #15;
        assert (
                DUT.current_state == 3'b111 &&// game ends
                (load_pcard1 | load_pcard2 | load_pcard3) == 0 &&
                (load_dcard1 | load_dcard2 | load_dcard3) == 0 &&
                ( !player_win_light &&  dealer_win_light) == 0
                ) $display("Check: Halt[2-F] done at%d ns",$time);
        else begin $error("Erros Found in State: Halt[2-F]"); err = 1; end #15;

        /*===============================================================
        Case 3-A:
        Player score >5 whereas the banker has a score less then 6.
        The player doesnt get a card but the banker gets a card
        ================================================================*/
        resetb = 0; #15;
        resetb = 1; #40;
        assert(DUT.current_state == 3'b100) $display("State: card_D2  Time: %d ns", $time);
        pcard3_out = 0; // pcard3_out = 8;//(Tested)
        pscore_out = 6; dscore_out = 0; #5//dscore_out = 6;# 5;
        assert (
                DUT.current_state == 3'b110 &&// Player gets a third card
                (load_pcard1 | load_pcard2 | load_pcard3) == 0 &&
                (load_dcard1 |load_dcard2 | !load_dcard3) == 0 &&
                ( player_win_light &&  !dealer_win_light) == 0
                ) $display("Check: D3[3-A] done at%d ns",$time);
        else begin $error("Erros Found in State: D3[3-A]"); err = 1; end #15;
        assert (
                DUT.current_state == 3'b111 &&// game ends
                (load_pcard1| load_pcard2 | load_pcard3) == 0 &&
                (load_dcard1 | load_dcard2 | load_dcard3) == 0 &&
                ( !player_win_light &&  dealer_win_light) == 0
                ) $display("Check: Halt[3-A] done at%d ns",$time);
        else begin $error("Erros Found in State: Halt[3-A]"); err = 1; end #15;

        assert(err == 0) $display(">>>>>NO ERRORS FOUND<<<<< ");
        else $display("CHECK ERROR MESSAGES SHOWN ABOVE");

        $stop;
    end


endmodule
