`timescale 1ns/1ps

module Sumador #(parameter ANCHO=8)(
  input [ANCHO-1:0] a,
  input [ANCHO-1:0] b,
  input cin,
  input [ANCHO-1:0] Control,
  output reg [ANCHO-1:0] sum,
  output reg cout
);

  reg [ANCHO:0] sumita;
  always @(*) begin
    sumita = a + b;
        if(Control == 2'b00)
              sum = sumita[ANCHO-1:0];
        cout = sumita[ANCHO];
  end
endmodule