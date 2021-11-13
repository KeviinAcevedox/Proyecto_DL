`timescale 1ns/1ps

module Datapath #(parameter ANCHO=8) (
	input clk,Load_regs,Shift_regs,Add_regs,Decr_P,
	input [ANCHO-1:0] Multiplicando,
	input [ANCHO-1:0] Multiplicador,
	output reg [ANCHO*2:0] Producto,
    output reg Zero,Q_Cero
);
  
	wire rst;
	wire [ANCHO-1:0] OUT_SUMADOR_IN_REGA;
	wire [ANCHO-1:0] IN_REGB;
	wire [ANCHO-1:0] OUT_REGB_IN_SUMA;
	wire [ANCHO-1:0] OUT_REGA_IN_SUMA;
	wire [ANCHO-1:0] OUT_REGQ;
	wire Suma_MSB;
  	wire REGA_LSB;
	wire [ANCHO-5:0] Contador;
	reg [3:0] Control;
	reg [ANCHO-5:0] PaseAControl;
	
	
	//Logica para comandos en registros
	always @(*) begin
      	Control={Add_regs,Shift_regs,Decr_P,Load_regs};
		
	end
	
	
  Sumador #(.ANCHO(ANCHO)) SUMA (.a(OUT_REGA_IN_SUMA),.b(OUT_REGB_IN_SUMA),.cin(1'b0),.sum(OUT_SUMADOR_IN_REGA),.cout(Suma_MSB),.Control(Control));
		
	RegistroUniversal #(.ANCHO(ANCHO)) REGISTRO_A (
	.clk(clk),
	.rst(rst),
	.Control(Control),
	.InHaciaDerecha(Suma_MSB),
	.ResultadoSuma(OUT_SUMADOR_IN_REGA),
      .EntradaParalela(8'b00000000),
	.Salida(OUT_REGA_IN_SUMA)
);

	RegistroUniversal #(.ANCHO(ANCHO)) REGISTRO_Q (
	.clk(clk),
	.rst(rst),
	.Control(Control),
	.InHaciaDerecha(OUT_REGA_IN_SUMA[0]),
	.ResultadoSuma(OUT_REGQ),
	.EntradaParalela(Multiplicador),
	.Salida(OUT_REGQ)
);

	RegistroUniversal #(.ANCHO(ANCHO)) REGISTRO_B (
	.clk(clk),
	.rst(rst),
      .Control(4'b0001),
      .InHaciaDerecha(1'b0),
	.ResultadoSuma(1'b0),
	.EntradaParalela(Multiplicando),
	.Salida(OUT_REGB_IN_SUMA)
);

	RegistroUniversal #(.ANCHO(ANCHO-4)) REGISTRO_P (
	.clk(clk),
	.rst(rst),
	.Control(Control),
	.InHaciaDerecha(1'b0),
	.ResultadoSuma(1'b0),
	.EntradaParalela(4'b1000),
	.Salida(Contador)
);

	//Logica de salida
  	always @(*) begin
      if(Control == 4'b0010)
		#0.1 assign Producto = {Suma_MSB,OUT_REGA_IN_SUMA,OUT_REGQ};
	end 
	always @(*) begin
      assign Q_Cero = OUT_REGQ[0];
      if(Contador==4'b0000)
		Zero=1;
      else
		Zero=0;
	end
	
	//definimos el 	valor de la salida..	
	//assign Salida=	OUT_SUMADOR_IN_REG1; //copiar salida del sumador
	
endmodule