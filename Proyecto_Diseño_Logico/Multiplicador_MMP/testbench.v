// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module testbench;
    
    reg clk,rst;

    wire S0,S1,S2,S3,S4,S5,S6,S7;
    reg C1,C2,C3,C4,C5,C6;

    initial begin
        $dumpfile("testbench.vcd");
        $dumpvars(0,testbench);
    end

    always #50 clk=~clk;

    initial begin
        clk=0;
		//aplicar reset
        rst<=0;
        repeat (2) begin
            @(posedge clk);
        end
        rst<=1;
		//reset aplicado
    end

	initial begin
		C1<=0; C2<=0; C3<=0; C4<=0; C5<=0; C6<=0;
		repeat (20) begin
            @(posedge clk);
        end
		//despues de 20 ciclos de reloj cambiamos C1 a 1;
		C1<=1;
        C2<=1;
        C3<=1;
		//enaprueba demo con C1 se 
		//llega a una condición donde {S7,S6,S5,S4,S3,S2,S1,S0}==11h
		wait({S7,S6,S5,S4,S3,S2,S1,S0}==8'b00010001);
		C1<=0;
		C2<=1; 
		//en la prueba demo con C2 se 
		//llega a una condición donde {S7,S6,S5,S4,S3,S2,S1,S0}==22h
		wait({S7,S6,S5,S4,S3,S2,S1,S0}==8'b00100010);
		C2<=0; 
		C3<=1; 
		//en la prueba demo con C2 se 
		//llega a una condición donde {S7,S6,S5,S4,S3,S2,S1,S0}==33h
		wait({S7,S6,S5,S4,S3,S2,S1,S0}==8'b00110011);
		C3<=0; 
		C4<=1; 
		//en la prueba demo con C2 se 
		//llega a una condición donde {S7,S6,S5,S4,S3,S2,S1,S0}==44h
		wait({S7,S6,S5,S4,S3,S2,S1,S0}==8'b01000100);
		C4<=0; 
		C5<=1; 
		//en la prueba demo con C2 se 
		//llega a una condición donde {S7,S6,S5,S4,S3,S2,S1,S0}==55h
		wait({S7,S6,S5,S4,S3,S2,S1,S0}==8'b01010101);
		C5<=0; 
		C6<=1; 
		//en la prueba demo con C2 se 
		//llega a una condición donde {S7,S6,S5,S4,S3,S2,S1,S0}==66h
		wait({S7,S6,S5,S4,S3,S2,S1,S0}==8'b01100110);
		C6<=0; 
		repeat (20) begin
            @(posedge clk);
        end
		$finish;
	end
    
	initial begin //en caso de que no se cumplan las condiciones de arriba
    	repeat (200) begin
			@(posedge clk);
		end
		$finish;
	end

    
    Controlador DUT (
        .clk(clk),
        .rst(rst),
        .Start(C1),
        .Q0(C2),
        .Zero(C3),
        .Condicion4(C4),
        .Condicion5(C5),
        .Condicion6(C6),
        .Load_regs(S0),
        .Shift_regs(S1),
        .Add_regs(S2),
        .Decr_P(S3),
        .ready(S4),
        .salida5(S5),
        .salida6(S6),
        .salida7(S7)
    );

endmodule