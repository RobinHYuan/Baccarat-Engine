module tb_datapath();

    logic slow_clock, fast_clock, resetb, reset, err;
    logic load_pcard1, load_pcard2, load_pcard3;
    logic load_dcard1, load_dcard2, load_dcard3;
    logic [3:0] pcard3_out, temp_store;
    logic [3:0] pscore_out, dscore_out;
    logic [6:0] HEX5, HEX4, HEX3;
    logic [6:0] HEX2, HEX1, HEX0;

    logic [3:0] temp_pcard1,temp_pcard2, temp_pcard3;
    logic [3:0] temp_dcard1,temp_dcard2, temp_dcard3;
    logic [3:0] score_p, score_d;
    datapath DUT(
                    slow_clock, fast_clock, resetb,
                    load_pcard1, load_pcard2, load_pcard3,
                    load_dcard1, load_dcard2, load_dcard3,
                    pcard3_out,
                    pscore_out, dscore_out,
                    HEX5, HEX4, HEX3,
                    HEX2, HEX1, HEX0
                );

     /*========================================
        Fast Clock Setup:
        Set all signals to the appropriate states
     ===========================================*/
    initial forever begin 
        fast_clock = ! fast_clock; #5;
    end

    /*========================================
     Testbench:
    If there is any mistake, the signal "err"
    will be become high.
    ===========================================*/
    initial begin

        /*========================================
        Initialization:
        Set all signals to the appropriate states
        ==========================================*/
        err = 0; fast_clock = 0; slow_clock = 1; resetb = 1; 
 	    load_pcard1 = 0; load_pcard2 = 0; load_pcard3 = 0;
        load_dcard1 = 0; load_dcard2 = 0; load_dcard3 = 0;#5;
     
        resetb = !resetb;
        slow_clock = ! slow_clock; #15;
        slow_clock = ! slow_clock; #15;

        resetb = !resetb;; #10;
       
        /*======================================
        Test Reset:
        See if the reset function works.
        Remeber Resetb is low-active meaning that
        we will only peform reset when we see a
        falling egde
        =========================================*/
        assert ( (DUT.pcard1_out == 4'b0) && (DUT.pcard2_out == 4'b0) && (DUT.pcard3_out == 4'b0) && (DUT.pscore_out == 4'b0)) 
        else  begin $error("Player card reset failed"); err = 1;  end 

        assert ( (DUT.dcard1_out == 4'b0) && (DUT.dcard2_out == 4'b0) && (DUT.dcard3_out == 4'b0)  && (DUT.dscore_out == 4'b0)) 
        else  begin $error("Dealer card reset failed"); err = 1;  end 

        /*==========================================================
        Get New Card:
        Note: The lab handout requires us to "sample the current value
        of this counter (the output of module, dealcard) when the user
        presses the 'next step' key." Therefore, we should turn on load 
        whenever we see a falling edge of "slow_clock" since the logic 
        status of it while halting is high due to the reverse keybind 
        of DE1-SOC. Similarily, we will turn off the load whenever we 
        detect a rising edge of slow_clock indicating the user has 
        released the key.
        ============================================================*/
  	    
        slow_clock  = ! slow_clock; 
	    load_pcard1 = 1;#15;

	    slow_clock  = ! slow_clock;
	    load_pcard1 = 0;
        temp_store  = DUT.pcard1_out;
        assert((DUT.new_card !== 4'b0) && (DUT.pcard1_out !== 4'b0 )) 
        temp_pcard1 = DUT.pcard1_out;
        else begin $error("Player cannot get a new card[1]"); err = 1; end
        #15;

	    /*=========================================================
        Toggle Slow-clock to Test Load Function:
        The register should only update its output iff the load 
        signal is high, and it sees a negedge of slow clock. 
        ===========================================================*/
        slow_clock = ! slow_clock; #15; 
        slow_clock = ! slow_clock;
        assert( (DUT.pcard1_out == temp_store ))
        else begin $error("Load function failed"); err = 1; end #25;

        /*============================================================
        Test Module Scorehand:
        We will load random cards into all six registers and see if the
        results of scorehand modules matches with the cards
        ==============================================================*/
        assert(slow_clock == 1) else $fatal(">>>CHECK SLOW CLOCK STATE<<<");

        slow_clock  = ! slow_clock; 
	    load_pcard2 = 1; #5;
	    slow_clock  = ! slow_clock;
	    load_pcard2 = 0; #25;
        assert((DUT.new_card !== 4'b0) && (DUT.pcard2_out !== 4'b0 )) 
            temp_pcard2 = DUT.pcard2_out;
        else begin $error("Player cannot get a new card[2]"); err = 1; end

        slow_clock  = ! slow_clock; 
	    load_pcard3 = 1; #15;
	    slow_clock  = ! slow_clock;
	    load_pcard3 = 0; #10
        assert((DUT.new_card !== 4'b0) && (DUT.pcard3_out !== 4'b0 )) 
            temp_pcard3 = DUT.pcard3_out;
        else begin $error("Player cannot get a new card[3]"); err = 1; end

        slow_clock  = ! slow_clock; 
	    load_dcard1 = 1; #5;
	    slow_clock  = ! slow_clock;
	    load_dcard1 = 0; #30;
        assert((DUT.new_card !== 4'b0) && (DUT.dcard1_out !== 4'b0 )) 
            temp_dcard1 = DUT.dcard1_out;
        else begin $error("Dealer cannot get a new card[1]"); err = 1; end

        slow_clock  = ! slow_clock; 
	    load_dcard2 = 1; #25;
	    slow_clock  = ! slow_clock;
	    load_dcard2 = 0; #35
        assert((DUT.new_card !== 4'b0) && (DUT.dcard2_out !== 4'b0 )) 
            temp_dcard2 = DUT.dcard2_out;
        else begin $error("Dealer cannot get a new card[2]"); err = 1; end
        
        slow_clock  = ! slow_clock; 
	    load_dcard3 = 1; #15;
	    slow_clock  = ! slow_clock;
	    load_dcard3 = 0; #15;
        assert((DUT.new_card !== 4'b0) && (DUT.dcard3_out !== 4'b0 )) 
            temp_dcard3 = DUT.dcard3_out;
        else begin $error("Dealer cannot get a new card[3]"); err = 1; end

        temp_pcard1 = DUT.pcard1_out > 4'b1001 ? 4'b0000 : DUT.pcard1_out;
        temp_pcard2 = DUT.pcard2_out > 4'b1001 ? 4'b0000 : DUT.pcard2_out;
        temp_pcard3 = DUT.pcard3_out > 4'b1001 ? 4'b0000 : DUT.pcard3_out;
        assert(pscore_out == (temp_pcard1 + temp_pcard2 + temp_pcard3 ) %10)
        else begin $error ("Player's score is wrong"); err = 1; end

        temp_dcard1 = DUT.dcard1_out > 4'b1001 ? 4'b0000 : DUT.dcard1_out;
        temp_dcard2 = DUT.dcard2_out > 4'b1001 ? 4'b0000 : DUT.dcard2_out;
        temp_dcard3 = DUT.dcard3_out > 4'b1001 ? 4'b0000 : DUT.dcard3_out;
        assert(dscore_out == (temp_dcard1 + temp_dcard2 + temp_dcard3 ) %10)
        else begin $error ("Dealer's score is wrong"); err = 1; end

        /*=========================================================
        Test Seven-segment Display 
        ===========================================================*/
        assert
        (
            HEX0 !==  7'b0_001_110 &&
            HEX1 !==  7'b0_001_110 &&
            HEX2 !==  7'b0_001_110 &&
            HEX3 !==  7'b0_001_110 &&
            HEX4 !==  7'b0_001_110 &&
            HEX5 !==  7'b0_001_110 
        ) 
        else begin $error ("Display is not working"); err = 1; end


        assert(err == 0) $display(">>>>>NO ERRORS FOUND<<<<< ");
        else $display("CHECK ERROR MESSAGES SHOWN ABOVE");

        $stop;
    end

endmodule
