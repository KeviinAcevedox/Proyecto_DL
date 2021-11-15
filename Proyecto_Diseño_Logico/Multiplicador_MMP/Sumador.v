`timescale 1ns/1ps

module Sumador #(parameter ANCHO=8)(
  input [ANCHO-1:0] a,
  input [ANCHO-1:0] b,
  input cin,
  input [3:0] Control,
  output reg [ANCHO-1:0] sum,
  output reg cout
);

  reg [ANCHO:0] sumita;
  always @(*) begin
    sumita = a + b;
    if(Control == 4'b1000) begin
              sum = sumita[ANCHO-1:0];
        	cout = sumita[ANCHO];
    end
   
    if(Control == 4'b0010) begin
              sum = 8'b00000000;
        	cout = 1'b0;
    end
  end
endmodule

