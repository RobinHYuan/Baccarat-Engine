`timescale 1 ps / 1 ps
module tb_task5();

    logic   CLOCK_50, err;
    logic [3:0] KEY;
    logic [9:0] LEDR;
    logic [6:0] HEX5,  HEX4, HEX3, HEX2, HEX1, HEX0;
    logic [9:0] cycle;
    task5 DUT   (  
                    CLOCK_50, KEY,    LEDR,
                    HEX5,     HEX4,   HEX3,
                    HEX2,     HEX1,   HEX0
                );

    initial forever begin
        CLOCK_50 = ! CLOCK_50; 
        if(CLOCK_50) cycle ++;
        #5;
    end

    initial begin
        CLOCK_50 = 0; cycle = 0;
        KEY = 4'b1111; #5;      // Intial State: HIGH
        KEY[3] = 0;             // Reset Key Pressed
        KEY[0] = 0; #5;         // Slow Clock (Falling Edge)
        KEY[0] = 1; #5;         // Halt State (Rising Edge)
        KEY[3] = 1;             //Release Reset Key
        err =0; #15;

        /*============================================
                Test Rest Key
        ============================================*/
        assert(
                DUT.sm. current_state == 3'b000 &&
                (DUT.load_pcard1 | DUT.load_pcard2 | DUT.load_pcard3) == 0 &&
                (DUT.load_dcard1 | DUT.load_dcard2 | DUT.load_dcard3) == 0 &&
                ( LEDR[8] | LEDR[9] )   == 0 &&
                (DUT.dp.new_card !== 0) &&
                ( HEX0  == 7'b111_1111 ) &&
                ( HEX1  == 7'b111_1111 ) &&
                ( HEX2  == 7'b111_1111 ) &&
                ( HEX3  == 7'b111_1111 ) &&
                ( HEX4  == 7'b111_1111 ) &&
                ( HEX5  == 7'b111_1111 ) &&
                (DUT.dscore == 0) &&
                (DUT.pscore == 0) 
              )$display("Check: Reset done at       %d ns",$time);
        else begin $error("Reset failed"); err = 1; end 
        /*============================================
        P1 State
        Expectation:
        State shoud get updated at the first falling edge
        whereas the reg4 value of P1 should be loaded
        at the rising edge
        ============================================*/
        $display("Check: P1 Check Start at   %d ns",$time);
        #5;KEY[0] = 0; #5;
        assert(DUT.sm. current_state == 3'b001 &&
                (!DUT.load_pcard1 | DUT.load_pcard2 | DUT.load_pcard3) == 0 &&
                ( DUT.load_dcard1 | DUT.load_dcard2 | DUT.load_dcard3) == 0)
        $display("Check: P1 Load Enabled at  %d ns",$time);
        else begin $error("P1 Load Enable Failed"); err = 1; end  
        KEY[0] = 1; #5;
        assert(
                ( LEDR[8] | LEDR[9] )   == 0 &&
                ( DUT.dp.new_card !== 0) &&
                DUT.dp.pcard1_out == ( cycle % 14 )&&
                (DUT.dscore == 0) &&
                (DUT.pscore !== 0) 
              )$display("Check: P1 Loaded at        %d ns ",$time);
        else begin $error("P1 Load Failed"); err = 1; end #5;
        /*============================================
                D1 State
        ============================================*/
        KEY[0] = 0; #5; 
         assert(DUT.sm. current_state == 3'b010 &&
               (DUT.load_pcard1 | DUT.load_pcard2 | DUT.load_pcard3) == 0 &&
               (!DUT.load_dcard1 | DUT.load_dcard2 | DUT.load_dcard3) == 0)
        $display("Check: D1 Load Enabled at  %d ns",$time);
        else begin $error("D1 Load Enable Failed"); err = 1; end #5;
        KEY[0] = 1; #5;
        assert(
                ( LEDR[8] | LEDR[9] )   == 0 &&
                ( DUT.dp.new_card !== 0) &&
                ( (HEX0 & HEX1  & HEX2  & HEX3  & HEX4  & HEX5)   !== 7'b111_1111 ) && //P1==5
                (  DUT.dp.dcard1_out == ( cycle % 14 ))&&
                (DUT.dscore !== 0) &&
                (DUT.pscore !== 0) 
              )$display("Check: D1 Loaded  at       %d ns",$time);
        else begin $error("D1 Load Failed"); err = 1; end #5;
        /*============================================
                P2 State
        ============================================*/
         KEY[0] = 0; #5; 
         assert(DUT.sm. current_state == 3'b011 &&
               (DUT.load_pcard1 | !DUT.load_pcard2 | DUT.load_pcard3) == 0 &&
               (DUT.load_dcard1 | DUT.load_dcard2 | DUT.load_dcard3) == 0)
        $display("Check: P2 Load Enabled at  %d ns",$time);
        else begin $error("P2 Load Enable Failed"); err = 1; end #5;
        KEY[0] = 1; #5;
        assert(
                ( LEDR[8] | LEDR[9] )   == 0 &&
                ( DUT.dp.new_card !== 0) &&
                ( (HEX0 & HEX1  & HEX2  & HEX3  & HEX4  & HEX5)   !== 7'b111_1111 ) && //P1==5
                (  DUT.dp.pcard2_out == ( cycle % 14 ))&&
                (DUT.dscore !== 0) &&
                (DUT.pscore !== 0) 
              )$display("Check: P2 Loaded  at       %d ns",$time);
        else begin $error("P2 Load Failed"); err = 1; end #10;
        /*============================================
                D2 State
        ============================================*/
         KEY[0] = 0; #5; 
         assert(DUT.sm. current_state == 3'b100 &&
               (DUT.load_pcard1 | DUT.load_pcard2 | DUT.load_pcard3) == 0 &&
               (DUT.load_dcard1 | !DUT.load_dcard2 | DUT.load_dcard3) == 0)
        $display("Check: D2 Load Enabled at  %d ns",$time);
        else begin $error("D2 Load Enable Failed"); err = 1; end 
        KEY[0] = 1; #5;
        assert(
                ( LEDR[8] | LEDR[9] )   == 0 &&
                ( DUT.dp.new_card !== 0) &&
                ( (HEX0 & HEX1  & HEX2  & HEX3  & HEX4  & HEX5)   !== 7'b111_1111 ) && //P1==5
                (  DUT.dp.dcard2_out == ( cycle % 14 ))&&
                (DUT.dscore !== 0) &&
                (DUT.pscore !== 0) 
              )$display("Check: D2 Loaded  at       %d ns",$time);
        else begin $error("D2 Load Failed"); err = 1; end #10;
        
        
        /*============================================
                P3 State
        ============================================*/
         KEY[0] = 0; #5; 
         assert(DUT.sm. current_state == 3'b101 &&
               (DUT.load_pcard1 | DUT.load_pcard2 | !DUT.load_pcard3) == 0 &&
               (DUT.load_dcard1 | DUT.load_dcard2 | DUT.load_dcard3) == 0)
        $display("Check: P3 Load Enabled at  %d ns",$time);
        else begin $error("P3 Load Enable Failed"); err = 1; end 
        KEY[0] = 1; #5;
        assert(
                ( LEDR[8] | LEDR[9] )   == 0 &&
                ( DUT.dp.new_card !== 0) &&
                ( (HEX0 & HEX1  & HEX2  & HEX3  & HEX4  & HEX5)   !== 7'b111_1111 ) && //P1==5
                (  DUT.dp.pcard3_out == ( cycle % 14 ))&&
                (DUT.dscore !== 0) &&
                (DUT.pscore !== 0) 
              )$display("Check: P3 Loaded  at       %d ns",$time);
        else begin $error("P3 Load Failed"); err = 1; end #10; 
        
    

        /*============================================
                Final State
        ============================================*/
         KEY[0] = 0; #5; 
         KEY[0] = 1; #5; 
         assert(DUT.sm. current_state == 3'b111 &&
               (DUT.load_pcard1 | DUT.load_pcard2 | DUT.load_pcard3) == 0 &&
               (DUT.load_dcard1 | DUT.load_dcard2 | DUT.load_dcard3) == 0&&
                ( LEDR[8] | !LEDR[9] )   == 0 &&
                ( DUT.dp.new_card !== 0) &&
                ( (HEX0 & HEX1  & HEX2  & HEX3  & HEX4  & HEX5)   !== 7'b111_1111 ) && //P1==5
                (DUT.dscore !== 0) &&
                (DUT.pscore !== 0) 
              )$display("Check: Final Result  at    %d ns",$time);
        else begin $error("Final Result Failed"); err = 1; end #10; 
        


        /*============================================
                Final State
        ============================================*/

        KEY[3] = 0;             // Reset Key Pressed
        KEY[0] = 0; #5;         // Slow Clock (Falling Edge)
        KEY[0] = 1; #5;         // Halt State (Rising Edge)
        KEY[3] = 1; #15            //Release Reset Key
       
        $display(">>>>>> Double_Check FSM at %d ns",$time);
        repeat(14)
        #5 KEY[0] = ! KEY[0];  
        $display(">>>>>> EyeBall it at       %d ns",$time); 
        $stop;

    end

endmodule
