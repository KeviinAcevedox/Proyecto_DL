`timescale 1ns/1ps

module tb_Multiplicador;

// Definicion de las variables a utilizar
reg Start;
reg Clock;
reg Reset;
reg [7:0] Multiplicando;
reg [7:0] Multiplicador;
wire [16:0] Producto;
wire Ready;

// Creando una instancia del sistema completo
Multiplicador_KCA_MMP DUT(
    .Clock(Clock), .Reset(Reset), .Start(Start),
    .Ready(Ready), .Multiplicando(Multiplicando),
    .Multiplicador(Multiplicador), .Producto(Producto)
);

// Generacion de graficas
initial begin
  $dumpfile("Multiplicador.vcd");
  $dumpvars(0, tb_Multiplicador);
end


// Reloj de 100 MHz
initial begin
    Clock = 0; // En tiempo 0
end
always begin
    #5 Clock = ~Clock; // Periodo de 10ns  
end


initial begin
    Reset = 0;
    Start = 0;
    Multiplicador = 8'b11010111; //215
	Multiplicando = 8'b11011111; //223

    @(negedge Clock)
    Reset = 1;
    #10
    Start = 1;
    #10 
    Start = 0;
    #1000
    Multiplicador = 8'b11000111; //199
	Multiplicando = 8'b01010101; //85
    #10
    Start = 1;
    #10 
    Start = 0;
    #1000
    $finish;
end
endmodule