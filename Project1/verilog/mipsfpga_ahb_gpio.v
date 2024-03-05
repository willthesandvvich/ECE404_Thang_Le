// mipsfpga_ahb_gpio.v
//
// General-purpose I/O module for Altera's DE2-115 and 
// Digilent's (Xilinx) Nexys4-DDR board
//
// Altera's DE2-115 board:
// Outputs:
// 18 red LEDs (IO_LEDR), 9 green LEDs (IO_LEDG) 
// Inputs:
// 18 slide switches (IO_Switch), 4 pushbutton switches (IO_PB[3:0])
//
// Digilent's (Xilinx) Nexys4-DDR board:
// Outputs:
// 15 LEDs (IO_LEDR[14:0]) 
// Inputs:
// 15 slide switches (IO_Switch[14:0]), 
// 5 pushbutton switches (IO_PB)
//


`timescale 100ps/1ps

`include "mipsfpga_ahb_const.vh"


module mipsfpga_ahb_gpio(
    input               HCLK,
    input               HRESETn,
    input      [  3: 0] HADDR,
    input      [ 31: 0] HWDATA,
    input               HWRITE,
    input               HSEL,
    output reg [ 31: 0] HRDATA,

// memory-mapped I/O
    input      [ 17: 0] IO_Switch,
    input      [  4: 0] IO_PB,
    output reg [ 17: 0] IO_LEDR,
    output reg [  8: 0] IO_LEDG,
    
    output reg [ 31: 0] IO_SCRATCH0,
    output reg [ 31: 0] IO_SCRATCH1,
    output reg [ 31: 0] IO_SCRATCH2,
    output reg [ 31: 0] IO_SCRATCH3,
    output reg [ 31: 0] IO_SCRATCH4,
    output reg [ 31: 0] IO_SCRATCH5,
    output reg [ 31: 0] IO_SCRATCH6,
    output reg [ 31: 0] IO_SCRATCH7
);


    always @(posedge HCLK or negedge HRESETn)
       if (~HRESETn) begin
         IO_LEDR <= 18'b0;  // Red LEDs
         IO_LEDG <= 9'b0;  // Green LEDs
         
         IO_SCRATCH0 <= 32'b0;
         IO_SCRATCH1 <= 32'b0;
         IO_SCRATCH2 <= 32'b0;
         IO_SCRATCH3 <= 32'b0;
         IO_SCRATCH4 <= 32'b0;
         IO_SCRATCH5 <= 32'b0;
         IO_SCRATCH6 <= 32'b0;
         IO_SCRATCH7 <= 32'b0;
       end else if (HWRITE & HSEL)
         case (HADDR)
           `H_LEDR_IONUM: IO_LEDR <= HWDATA[17:0];
           `H_LEDG_IONUM: IO_LEDG <= HWDATA[8:0];
           
           `H_SCRATCH0_IONUM: IO_SCRATCH0 <= HWDATA;
           `H_SCRATCH1_IONUM: IO_SCRATCH1 <= HWDATA;
           `H_SCRATCH2_IONUM: IO_SCRATCH2 <= HWDATA;
           `H_SCRATCH3_IONUM: IO_SCRATCH3 <= HWDATA;
           `H_SCRATCH4_IONUM: IO_SCRATCH4 <= HWDATA;
           `H_SCRATCH5_IONUM: IO_SCRATCH5 <= HWDATA;
           `H_SCRATCH6_IONUM: IO_SCRATCH6 <= HWDATA;
           `H_SCRATCH7_IONUM: IO_SCRATCH7 <= HWDATA;
         endcase
    
    always @(*)
      case (HADDR)
        `H_SW_IONUM: HRDATA = {14'b0, IO_Switch};
        `H_PB_IONUM: HRDATA = {27'b0, IO_PB};
        
        `H_SCRATCH0_IONUM: HRDATA = IO_SCRATCH0;
        `H_SCRATCH1_IONUM: HRDATA = IO_SCRATCH1;
        `H_SCRATCH2_IONUM: HRDATA = IO_SCRATCH2;
        `H_SCRATCH3_IONUM: HRDATA = IO_SCRATCH3;
        `H_SCRATCH4_IONUM: HRDATA = IO_SCRATCH4;
        `H_SCRATCH5_IONUM: HRDATA = IO_SCRATCH5;
        `H_SCRATCH6_IONUM: HRDATA = IO_SCRATCH6;
        `H_SCRATCH7_IONUM: HRDATA = IO_SCRATCH7;
        
        default:     HRDATA = 32'h00000000;
      endcase

endmodule

