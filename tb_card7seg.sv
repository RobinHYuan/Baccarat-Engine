/*===========================================
This is a testbench for the module, card7seg.
The code itself is prettyself-explanatory, which 
it asserts every possible case by incrementing SW
by one bit every 10 ps seconds up till 4'b1111
============================================*/


module tb_card7seg();

    logic [3:0] SW_tb  ; 
    logic [6:0] HEX0_tb;
    logic err;

    card7seg DUT(SW_tb,HEX0_tb); 

    initial forever begin
        #10; SW_tb = SW_tb + 4'b0001;
        assert (SW_tb < 4'b1111) 
        else  $stop; end
    

    initial begin
            SW_tb = 4'b0000; #5;

            assert (HEX0_tb ==  7'b1_111_111)
            else begin  $error("DE1 cannot display the character, 0 "); err = 1'b1; end #10;

            assert (HEX0_tb ==  7'b0_001_000)
            else begin $error("DE1 cannot display the character, 1 "); err = 1'b1; end #10;
            
            assert (HEX0_tb ==  7'b0_100_100)
            else begin $error("DE1 cannot display the character, 2 "); err = 1'b1; end #10;

            assert (HEX0_tb ==  7'b0_110_000)
            else begin $error("DE1 cannot display the character, 3 "); err = 1'b1; end #10;

            assert (HEX0_tb ==  7'b0_011_001)
            else begin $error("DE1 cannot display the character, 4 "); err = 1'b1; end #10;

            assert (HEX0_tb ==  7'b0_010_010)
            else begin $error("DE1 cannot display the character, 5 "); err = 1'b1; end #10;

            assert (HEX0_tb ==  7'b0_000_010)
            else begin $error("DE1 cannot display the character, 6 "); err = 1'b1; end #10;

            assert (HEX0_tb ==  7'b1_111_000)
            else begin $error("DE1 cannot display the character, 7 "); err = 1'b1; end #10;

            assert (HEX0_tb ==  7'b0_000_000)
            else begin $error("DE1 cannot display the character, 8 "); err = 1'b1; end #10;
            
            assert (HEX0_tb ==  7'b0_010_000)
            else begin $error("DE1 cannot display the character, 9 "); err = 1'b1; end #10;

            assert (HEX0_tb ==  7'b1_000_000)
            else begin $error("DE1 cannot display the character, 10 "); err = 1'b1; end #10;

            assert (HEX0_tb ==  7'b1_100_001)
            else begin $error("DE1 cannot display the character, J "); err = 1'b1; end #10;

            assert (HEX0_tb ==  7'b0_011_000)
            else begin $error("DE1 cannot display the character, Q "); err = 1'b1; end #10;

            assert (HEX0_tb ==  7'b0_001_001)
            else begin $error("DE1 cannot display the character, K "); err = 1'b1; end #10;
            
            assert (HEX0_tb ==  7'b0_001_110)
            else begin $error("Default statement fails "); err = 1'b1; end
            
            assert (err ==  1'b1)
            else begin $display(">>>>>>>>>>>>>No errors found<<<<<<<<<<<<<< ");  end 
    end

endmodule

