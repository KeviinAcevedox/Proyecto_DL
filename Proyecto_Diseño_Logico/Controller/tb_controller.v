`timescale 1ns/1ps
module tb_controller;

// Definicion de las variables a utilizar
reg Clock, Reset, Start, Q0, Zero;
wire Ready, Load_Regs, Shift_Regs, Add_Regs, Decr_P;


// Creando una instancia del controlador
Controller FSM(
    .Clock(Clock), .Reset(Reset), .Start(Start), .Q0(Q0),
    .Zero(Zero), .Ready(Ready), .Load_Regs(Load_Regs),
    .Shift_Regs(Shift_Regs), .Add_Regs(Add_Regs), .Decr_P(Decr_P)
);


// Generacion de graficas
initial begin
  $dumpfile("controlador.vcd");
  $dumpvars(0, tb_controller);
end


// Reloj de 100 MHz
initial begin
    Clock = 0; // En tiempo 0
end
always begin
    #5 Clock = ~Clock; // Periodo de 10ns  
end


// Generar el reset
initial begin
    // En tiempo 0
    Reset = 0;
    Start = 0;
    Q0 = 0;
    Zero = 0;
    #10
    Reset = 1;
    Start = 1;
    #10 
    Start = 0;
    Q0 = 1;
    #30
    Q0 = 0;
    Zero = 0;
    #20
    Zero = 1;


end
endmodule