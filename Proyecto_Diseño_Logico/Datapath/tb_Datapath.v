`timescale 1ns/1ps
module tb_Datapath;

// Definicion de las variables a utilizar
parameter ANCHO=8;
reg clk, rst;
reg Load_regs,Shift_regs,Add_regs,Decr_P;
reg [ANCHO-1:0] Multiplicador;
reg [ANCHO-1:0] Multiplicando;
wire [ANCHO*2:0] Producto;
wire Q_Cero, Zero;


// Creando una instancia del controlador
Datapath #(.ANCHO(ANCHO)) DUT(
	.clk(clk),.Load_regs(Load_regs),.Shift_regs(Shift_regs),.Add_regs(Add_regs),.Decr_P(Decr_P),
	.Multiplicando(Multiplicando),
	.Multiplicador(Multiplicador),
	.Producto(Producto),
    .Zero(Zero),.Q_Cero(Q_Cero)
);


// Generacion de graficas
initial begin
  $dumpfile("datapath.vcd");
  $dumpvars(0, tb_Datapath);
end


// Reloj de 100 MHz
initial begin
    clk = 0; // En tiempo 0
end
always begin
    #5 clk = ~clk; // Periodo de 10ns  
end


// Generar el reset
initial begin
	// El controlador esta en estado reset
    Load_regs=0;
	Shift_regs=0;
	Add_regs=0;
	Decr_P=0;

    #10
	// Controlador manda a cargar los registros
	// En este punto la salida Q0 deberìa ser 1
	Multiplicador=8'b00010111;
	Multiplicando=8'b11010111;
    Load_regs=1;
	Shift_regs=0;
	Add_regs=0;
	Decr_P=0;

    #10 
	// Controlador se encuentra en un estado en donde lee Q0
	//En este punto Q0 deberia de ser 1
    Load_regs=0;
	Shift_regs=0;
	Add_regs=0;
	Decr_P=0;

    #10
	// Si Q0 es 1, controlador manda a sumar
	// En este instante el Datapath realiza la suma
    Load_regs=0;
	Shift_regs=0;
	Add_regs=1;
	Decr_P=0;

    #10
	// El controlador ordena hacer shift y decremento del contador
	// Se valida la salida Zero
    Load_regs=0;
	Shift_regs=1;
	Add_regs=0;
	Decr_P=1;

	#10
	// Controlador no envia ninguna orden porque està analizando la bandera Zero
    Load_regs=0;
	Shift_regs=0;
	Add_regs=0;
	Decr_P=0;

	#10
	// Aun no termina el contador. Asi que, el controlador vuelve a analizar Q0
	// En este punto, Q0 deberia de ser 1
    Load_regs=0;
	Shift_regs=0;
	Add_regs=0;
	Decr_P=0;

 	#10
	// Si Q0 es 1, controlador manda a sumar
	// En este instante el Datapath realiza la suma
    Load_regs=0;
	Shift_regs=0;
	Add_regs=1;
	Decr_P=0;

    #10
	// El controlador ordena hacer shift y decremento del contador
	// Se valida la salida Zero
    Load_regs=0;
	Shift_regs=1;
	Add_regs=0;
	Decr_P=1;

	#10
	// Controlador no envia ninguna orden porque està analizando la bandera Zero
    Load_regs=0;
	Shift_regs=0;
	Add_regs=0;
	Decr_P=0;


	#10
	// Aun no termina el contador. Asi que, el controlador vuelve a analizar Q0
	// En este punto, Q0 deberia de ser 1
    Load_regs=0;
	Shift_regs=0;
	Add_regs=0;
	Decr_P=0;

	$finish;

end
endmodule