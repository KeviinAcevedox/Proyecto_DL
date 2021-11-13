`timescale 1ns/1ps

module RegistroUniversal #(parameter ANCHO=8)(
	input clk, rst,
  	input [3:0] Control,
	input InHaciaDerecha, //Primer bit de la suma o Ultimo bit del registro A
	input [ANCHO-1:0] ResultadoSuma,
	input [ANCHO-1:0] EntradaParalela,
	output reg [ANCHO-1:0] Salida
);

reg [ANCHO-1:0]state,next_state;
parameter Memoria=4'b0000;
parameter Add_regs=4'b1000,Shift_regs=4'b0100;
parameter Decr_P=4'b0010, Load_regs=4'b0001; 
//memoria
always @(posedge clk) begin
	if(!rst) state<=0;
	else state<=next_state;
end

//siguiente estado
if(ANCHO==8) begin
	always @(*) begin
		case(Control)
          Memoria: next_state=state;
          Add_regs: next_state=ResultadoSuma; //memoria, se mantiene el dato
          Shift_regs: next_state={InHaciaDerecha,state[ANCHO-1:1]};
          Decr_P: next_state=state;
          Load_regs: next_state=EntradaParalela;
          default:next_state=state;
		endcase
	end
end
else begin	
	always @(*) begin
		case(Control)
          	Memoria:next_state=state;
        	Add_regs: next_state=state; //memoria, se mantiene el dato
            Shift_regs: next_state=state;
            Decr_P: next_state=state-1'b1;
            Load_regs: next_state=EntradaParalela;
            default:next_state=state;
        endcase
	end
end

//salidas
always @(*) begin
	Salida=state;
end
endmodule