`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module Garage(
  input up_max,dn_max, 
  input active,
  input clk , reset,
  output reg up_m , dn_m
    );
    
    localparam idel = 00,
               mv_up = 01,
               mv_dn = 10;
               
 reg [1:0] current_state , next_state;
 
 always @(posedge clk ,negedge reset)
 begin
        if (!reset)
         current_state <= idel;
        else
         current_state <= next_state;
 end 
 
 always @(*)
 begin
        case (current_state)
            idel: if (active==1 &up_max==1 &dn_max ==0) 
                      begin
                        up_m =0 ; dn_m = 1;
                        next_state = mv_dn;
                      end
                   else if (active==1 &up_max==0 &dn_max ==1)
                     begin
                      up_m =1 ; dn_m = 0;
                      next_state = mv_up;                        
                     end 
                   else 
                    begin
                       up_m =0 ; dn_m = 0;
                       next_state = idel;
                    end
                    
            mv_dn: if (dn_max ==1)
                    begin
                       up_m =0 ; dn_m = 0;
                       next_state = idel;
                    end 
                   else 
                     begin
                        up_m =0 ; dn_m = 1;
                        next_state = mv_dn;
                     end  
            
            mv_up: if(up_max == 1)
                      begin
                        up_m =0 ; dn_m = 0;
                        next_state = idel;                       
                      end 
                    else
                     begin
                      up_m =1 ; dn_m = 0;
                      next_state = mv_up;                       
                    end                                     
        endcase
 end
endmodule
