`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module Garage_TB();

  reg up_max_tb,dn_max_tb; 
  reg active_tb;
  reg clk_tb , reset_tb;
  wire up_m_tb , dn_m_tb;
  
  Garage DUT (
        .up_max(up_max_tb),
        .dn_max(dn_max_tb),
        .active(active_tb),
        .clk(clk_tb),
        .reset(reset_tb),
        .up_m(up_m_tb),
        .dn_m(dn_m_tb)
        );
        
    always #10 clk_tb = ~clk_tb;
    
    initial 
      begin
         $dumpfile("garage.vcd");  
         $dumpvars;
          
         initialized();
         reset();
         
        active();
        check_out(1'b1,1'b0);
        up_sensor();
        #2
        check_out(1'b0,1'b0);
        
        active();
        check_out(1'b0,1'b1); 
        dn_sensor();
        
        @(negedge clk_tb)
        $stop;
      end
      
   task initialized ;
    begin
         clk_tb = 1'b0;
         active_tb = 1'b0;
         up_max_tb = 1'b0;
         dn_max_tb = 1'b1;
     end    
   endtask
   
   task reset ;
     begin
        reset_tb = 1'b1;
        #3
        reset_tb = 1'b0;
        #3
        reset_tb = 1'b1;
     end 
   endtask
   
 task active;
   begin
      active_tb = 1;
      repeat(3) @(negedge clk_tb);
      active_tb = 0;
   end
 endtask
 
 task up_sensor;
  begin
        repeat(6) @(negedge clk_tb);
        up_max_tb =1;
        dn_max_tb =0;
  end   
 endtask 
 
  task dn_sensor;
  begin
        repeat(5) @(negedge clk_tb);
        up_max_tb =0;
        dn_max_tb =1;
  end   
 endtask 
 
  task check_out(
    input  up_mv_t ,
    input dn_mv_t 
  );
   begin
       if (up_mv_t == up_m_tb &&dn_mv_t ==dn_m_tb)
        $display ("The moter is woking correctly");
       else
        $display ("The moter isn't working correctly"); 
   end  
  endtask
endmodule
