module VendingMachine_0(
 input [3:0] item_number,
 input nickel_in, dime_in, clock, reset,
 output reg nickel_out, dispense
);
  // Wires for outputs from each item
 wire No1, D1, No2, D2, No3, D3, No4, D4;
 // Parameterized modules for each item
 Item #(15, 4) item1 (.nickel_in(nickel_in), .dime_in(dime_in), .clock(clock), .reset(reset),
.nickel_out(No1), .dispense(D1));
 Item #(25, 5) item2 (.nickel_in(nickel_in), .dime_in(dime_in), .clock(clock), .reset(reset),
.nickel_out(No2), .dispense(D2));
 Item #(30, 6) item3 (.nickel_in(nickel_in), .dime_in(dime_in), .clock(clock), .reset(reset),
.nickel_out(No3), .dispense(D3));
 Item #(35, 7) item4 (.nickel_in(nickel_in), .dime_in(dime_in), .clock(clock), .reset(reset),
.nickel_out(No4), .dispense(D4));
 // Select the correct item output
 always @(*) begin
 case(item_number)
 4'b0001: {nickel_out, dispense} = {No1, D1};
 4'b0010: {nickel_out, dispense} = {No2, D2};
 4'b0100: {nickel_out, dispense} = {No3, D3};
 4'b1000: {nickel_out, dispense} = {No4, D4};
 default: {nickel_out, dispense} = 2'b00;
 endcase
 end
endmodule
module Item #(parameter COST = 15, WIDTH = 4)(
 input nickel_in, dime_in, clock, reset,
 output reg nickel_out, dispense
);
 reg [WIDTH-1:0] current_state, next_state;
 // A state will change when there is a positive edge in either clock or reset
 always @(posedge clock or posedge reset) begin
 if(reset) begin
 current_state <= 0;
 end
 else begin
 current_state <= next_state;
 end
 end
  // State transition logic
 always @(*) begin
 next_state = current_state;
 {nickel_out, dispense} = 2'b00;
 if(current_state < COST) begin
 if(nickel_in) next_state = current_state + 5;
 else if(dime_in) next_state = current_state + 10;
 end
 if(current_state >= COST) begin
 dispense = 1;
 next_state = 0;
 end
 end
endmodule
