`timescale 1ns/1ps

// Modulo del sistema completo
module Multiplicador_KCA_MMP(
    input Start,
    input Clock,
    input Reset,
    input [7:0] Multiplicando,
	input [7:0] Multiplicador,
	output [16:0] Producto,
    output Ready);

// Declaraciòn de los cables que conectan en ambas partes
    wire Load_regs;
    wire Shift_regs;
    wire Add_regs;
    wire Decr_P;
    wire Zero;
    wire Q0;
    wire salida5;
    wire salida6;
    wire salida7;

// Usando una instancia del modulo Controller MMP
    Controlador TheController(
        .clk(Clock),
        .rst(Reset),
        .Start(Start),
        .Q0(Q0),
        .Zero(Zero),
        .Condicion4(1'b0),
        .Condicion5(1'b0),
        .Condicion6(1'b0),
        .ready(Ready),
        .Load_regs(Load_regs),
        .Shift_regs(Shift_regs),
        .Add_regs(Add_regs),
        .Decr_P(Decr_P),
        .salida5(salida5),
        .salida6(salida6),
        .salida7(salida7)
    );

// Usando una instancia del modulo Datapath
    Datapath TheDatapath(
        .clk(Clock),
        .Load_regs(Load_regs),
        .Shift_regs(Shift_regs),
        .Add_regs(Add_regs),
        .Decr_P(Decr_P),
        .Multiplicando(Multiplicando),
        .Multiplicador(Multiplicador),
        .Producto(Producto),
        .Zero(Zero),
        .Q_Cero(Q0)
    );

endmodule


