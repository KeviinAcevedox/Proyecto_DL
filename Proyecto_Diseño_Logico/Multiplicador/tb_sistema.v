`timescale 1ns/1ps

module tb_sistema;

// Definicion de las variables a utilizar
reg Start;
reg Clock;
reg Reset;
reg [7:0] Multiplicando;
reg [7:0] Multiplicador;
wire [16:0] Producto;
wire Ready;

// Creando una instancia del controlador
Sistema DUT(
    .Clock(Clock), .Reset(Reset), .Start(Start),
    .Ready(Ready), .Multiplicando(Multiplicando),
    .Multiplicador(Multiplicador), .Producto(Producto)
);


// Generacion de graficas
initial begin
  $dumpfile("sistema.vcd");
  $dumpvars(0, tb_sistema);
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
    // En tiempo 0 se inicializan los datos
    Reset = 0;
    Start = 0;
    Multiplicador = 8'b00010111;
	Multiplicando = 8'b11010111;

    @(negedge Clock)
    // Se quita el Reset y se enciende el sistema
    Reset = 1;
    Start = 1;
    #15
    Start = 0;
    #200
    $finish;
end
endmodule