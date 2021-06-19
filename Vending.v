////////////////////////////////////////////////
//
// Name:   Shubhi Agrawal
// Design:  Vending Machine
// Date:   21-05-2021
//
//////////////////////////////////////////////





`timescale 1ns/1ns

module vending_machine(
            input coin1,
                  coin2,
                    rst,
                    clk,
                   item,
       input [1:0] tea_loaded,
                coffee_loaded,
          output reg change,
                     deliver_tea,
                     deliver_coffee,
   output reg [1:0] tea_available,
                    coffee_available );

 // reg [1:0] tea_available,coffee_available;
  // reg  change,deliver_tea,deliver_coffee;
  reg [2:0] state, next_state;
  
  parameter Idle = 3'd7,
            Idle_tea = 3'd0,
            Idle_coffee = 3'd1,
            tea_st1 = 3'd2, 
            tea_st2 = 3'd3,
            coffee_st1 = 3'd4,
            coffee_st2 = 3'd5,
            coffee_st3 = 3'd6 ;

  
 always @(posedge clk)
   begin
     if(!rst)
       state <= Idle;
     else
       state <= next_state;
   end


 always @(state)
  begin
   case(state)
     
    Idle: if((item == 1) && tea_available)
             next_state = Idle_tea;
          else if((item == 0) && coffee_available)
             next_state = Idle_coffee;
          else  next_state = Idle;

    Idle_tea: if((coin1 == 1)&&(item == 1) && tea_available)
                next_state = tea_st1;
              else if(coin2 == 1)
                next_state = tea_st2;
               else
                next_state = Idle;

    tea_st1:   next_state = Idle;
   
    tea_st2:   next_state = Idle;

    Idle_coffee: if((coin1 == 1)&&(item == 0) && coffee_available)
                   next_state = coffee_st1;
                 else if((coin2 == 1)&&(item == 0) && coffee_available)
                   next_state = coffee_st2;
                 else
                   next_state = Idle;

    coffee_st2:   next_state = Idle;
   
    coffee_st1:   if(coin1 == 1)
                   next_state = coffee_st2;
                 else if(coin2 == 1)
                   next_state = coffee_st3;
                 else
                   next_state = Idle;

   coffee_st3:   next_state = Idle;

   default: next_state = Idle;
  endcase
  end

 // output logic
 always @(state)
 
  begin
   case(state)
     
    Idle: begin
          change = 0;
          deliver_tea = 0;
          deliver_coffee = 0;
          coffee_available = coffee_loaded;
          tea_available = tea_loaded; end
          

    Idle_tea: begin
              change = 0;
              deliver_tea = 0;
              deliver_coffee = 0;
              tea_available = tea_loaded; end

    tea_st1:   begin
                change = 0;
                deliver_tea = 1;
                deliver_coffee = 0;
                tea_available = tea_loaded - 1; end

    tea_st2:  begin
              change = 1;
              deliver_tea = 1;
              deliver_coffee = 0; 
              tea_available = tea_loaded - 1;end

    Idle_coffee: begin
                change = 0;
                deliver_tea = 0;
                deliver_coffee = 0;
                coffee_available = coffee_loaded; end

    coffee_st2:   begin
              change = 0;
              deliver_tea = 0;
              deliver_coffee = 1;
              coffee_available = coffee_loaded - 1; end

   
    coffee_st1:   begin
              change = 0;
              deliver_tea = 0;
              deliver_coffee = 0;
              coffee_available = coffee_loaded; end

   coffee_st3:   begin
              change = 1;
              deliver_tea = 0;
              deliver_coffee = 1;
              coffee_available = coffee_loaded - 1; end


   default: begin
              change = 0;
              deliver_tea = 0;
              deliver_coffee = 0;
              coffee_available = coffee_loaded;
               tea_available = tea_loaded;      end

  endcase
  end

 endmodule
   
   

                   

             
