module tb_scorehand();

  logic [3:0] card1, card2, card3, temp1, temp2, temp3, total, total_tb;
  scorehand DUT( card1, card2, card3, total);
 
  initial begin

     for( card1=4'b1101, card2=4'b0000, card3 = 4'b0000; card3 < 4'b1100 ;card1--,card2++,card3++) begin

             if (card1 > 4'b1001) temp1 = 0; else temp1 = card1;
	           if (card2 > 4'b1001) temp2 = 0; else temp2 = card2;
	           if (card3 > 4'b1001) temp3 = 0; else temp3 = card3;

             total_tb = (temp1 + temp2 + temp3)%10; #5;

             assert(total == total_tb)
             else $fatal("Error Detected");
      end
      $stop;
      
  end 

endmodule
