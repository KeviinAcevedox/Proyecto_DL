// Modulo para el controlador del proyecto del curso de Diseño Logico
`timescale 1ns/1ps

module Controller(
    input Clock, Reset, Start, Q0, Zero,
    output reg Ready, Load_regs, Shift_regs, Add_regs, Decr_P
);


// Variables de estados
reg [2:0] Current_State, Next_State;


// Definicion de los estados posiblesç
parameter SLEEP = 0, LOAD_DATA = 1, Q0_ONE = 2, ADD = 3, SHIFT = 4, ZERO = 5, READY = 6;


// Logica de memoria
always @ (posedge Clock) begin
    if(!Reset) Current_State <= SLEEP;
    else Current_State <= Next_State;
end


// Logica de siguiente estado
always @(*) begin
    case (Current_State)

        SLEEP: begin
          if(Start == 1) Next_State = LOAD_DATA;
        end

        LOAD_DATA: begin
          Next_State = Q0_ONE;
        end

        Q0_ONE: begin
          if(Q0 == 1) Next_State = ADD;
          else Next_State = SHIFT;
        end

        ADD: begin
          Next_State = SHIFT;
        end

        SHIFT: begin
          Next_State = ZERO;
        end

        ZERO: begin
          if(Zero == 1) Next_State = READY;
          else Next_State = Q0_ONE;
        end

        READY: begin
          Next_State = SLEEP;
        end

        default: begin
          Next_State = SLEEP;
        end
    endcase    
end

// Logica de salida
always @(*) begin
    // Evitar latches
    Load_regs = 0;
    Shift_regs = 0;
    Add_regs = 0;
    Decr_P = 0;
    Ready = 0;

    case (Current_State)

        LOAD_DATA: begin
          Load_regs = 1;
          Ready = 0;
        end

        ADD: begin
            Add_regs = 1;
        end

        SHIFT: begin
            Shift_regs = 1;
            Decr_P = 1;
        end

        READY: begin
            Ready = 1;
        end

    endcase     
end
endmodule