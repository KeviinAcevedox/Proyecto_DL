// Code your design here
`timescale 1ns / 1ps

//Mux 8 a 1

module MuxCondiciones #(parameter SEL_BITS=3)(
    input [SEL_BITS-1:0] sel, //Bus de selección con ancho SEL_BITS (ej.: 3 bits)
    input [(2**SEL_BITS)-1:0] in_bits, //los bits de entrada: 2^SEL_BITS (ej.: 2^3=8 bits)
    output reg out //bit de salida
    );
    
    always @(*)
        out = in_bits[sel];
        
endmodule

//contador con carga

module CounterWithLoad #(parameter ANCHO = 8) (
    input clk,
    input rst,
    input LD_C, //cargar (1), contar (0)
    input [ANCHO-1:0] CuentaEntrada, //Valor para carga paralela (donde vamos a saltar)
    output reg [ANCHO-1:0] cuenta  //salida del contador
    );
    
    always @(posedge clk)
      if (!rst) //reset activo en BAJO
         cuenta <= {ANCHO{1'b0}};
      else
         if (LD_C) //si LD_C es 1 entonces cargue el valor a la entrada
            cuenta <= CuentaEntrada;
         else // sino entonces cuente hacia arriba
            cuenta <= cuenta + 1'b1;
    
endmodule

// Memoria ROM 20bits x 256

module SimpleRom  #(parameter ANCHO = 20, parameter ANCHO_DIR = 8) (
    //ANCHO: es el tamaño de las palabras almacenadas
    //ANCHO_DIR: El ancho del bus de direcciones!
    //por defecto:
    //Bus de direcciones de 8 bits, lo que genera una memoria con un Largo de 256 palabras
    //El bus de datos es de 20 bits 
    input [ANCHO_DIR-1:0]A, //dirección 
    output [ANCHO-1:0]Do //Dato de salida
    );
    reg [ANCHO-1:0] MATRIX [0:(2**ANCHO_DIR)-1];
    
    initial begin
        $readmemh("rom_content_t.mem", MATRIX); //cargar contenido de archivo de memoria (binario)
    end    
    
    assign #5 Do = MATRIX[A]; //simulando 25ns de retraso (un poco más real)
    
endmodule

//controlador microprogramado
module Controlador(
    input clk,
    input rst,
    input Start,
    input Q0,
    input Zero,
    input Condicion4,
    input Condicion5,
    input Condicion6,
    output Load_regs,
    output Shift_regs,
    output Add_regs,
    output Decr_P,
    output ready,
    output salida5,
    output salida6,
    output salida7
    );
    
    parameter ANCHO_CONTADOR = 8;//Ancho del contador y del bus de la memoria
    parameter BITS_SELECCION_SALTO = 3;//bits usados para seleccionar condiciones de salto
    parameter ANCHO_MEMORIA = ANCHO_CONTADOR+8+1+BITS_SELECCION_SALTO; //20 bits en este ejemplo
    
    
    wire [ANCHO_CONTADOR-1:0] Cuenta_Direccion_Memoria;
    wire [ANCHO_CONTADOR-1:0] Direccion_Salto;
    wire [BITS_SELECCION_SALTO-1:0] Seleccion_De_Condicion_Salto;
    wire Senal_De_Carga_Contador;
    
    wire tmp0;//para relleno, no se usa en este ejemplo
    
    CounterWithLoad #(.ANCHO(ANCHO_CONTADOR)) Uconta (
        .clk(clk),
        .rst(rst),
        .LD_C(Senal_De_Carga_Contador), //cargar (1), contar (0)
        .CuentaEntrada(Direccion_Salto), //Valor para carga paralela (donde vamos a saltar)
        .cuenta(Cuenta_Direccion_Memoria) //salida del contador
    );
    
    SimpleRom  #(.ANCHO(ANCHO_MEMORIA), .ANCHO_DIR(ANCHO_CONTADOR)) Umem (
        .A(Cuenta_Direccion_Memoria), //dirección 
        .Do({
            Direccion_Salto, //8 bits //bits 19-12
            salida7, //8 bits de salida  //bit 11
            salida6, //bit 10
            salida5, //bit 9
            ready, //bit 8
            Decr_P, //bit 7
            Add_regs, //bit 6
            Shift_regs, //bit 5
            Load_regs, //bit 4
            tmp0,// 1 bit de relleno  //bit 3
            Seleccion_De_Condicion_Salto //3 bits de selección de salto  //bits 2-0 
        }) //Dato de salida de memoria -- TOTAL: 20 bits (5 digitos en hex)
    );
    
    MuxCondiciones #(.SEL_BITS(BITS_SELECCION_SALTO)) MUX(
       .sel(Seleccion_De_Condicion_Salto), //Bus de selección 
       /*
       Para el ejemplo de 3 bits de selección de salto:
       La selección en 000 significa NO SALTO
       La selección en 111 significa SALTO INCONDICIONAL
       Cualquier otra selección corresponde a las condiciones...
       
       **RECORDAR que el contador salta si la condición es 1
         y continua contando si la condición es 0!!!
       */
       .in_bits(//8 opciones
            {1'b1,//salto incondicional
            Condicion6, //sel 6
            Condicion5, //sel 5
            Condicion4, //sel 4
            Zero, //sel 3
            Q0, //sel 2
            Start, //sel 1
            1'b0}//NO saltar //menos significativo
            ), //los bits de entrada: 2^SEL_BITS (ej.: 2^3=8 bits)
       .out(Senal_De_Carga_Contador) //bit de salida
    );
    
endmodule