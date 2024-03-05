// 
// mipsfpga_ahb_const.vh
//
// Verilog include file with AHB definitions
// 

//-------------------------------------------
// Memory-mapped I/O addresses
//-------------------------------------------
`define H_LEDR_ADDR   			(32'h1f800000)
`define H_LEDG_ADDR   			(32'h1f800004)
`define H_SW_ADDR   			(32'h1f800008)
`define H_PB_ADDR   			(32'h1f80000c)

`define H_SCRATCH0_ADDR   		(32'h1f800010)
`define H_SCRATCH1_ADDR   		(32'h1f800014)
`define H_SCRATCH2_ADDR   		(32'h1f800018)
`define H_SCRATCH3_ADDR   		(32'h1f80001c)
`define H_SCRATCH4_ADDR   		(32'h1f800020)
`define H_SCRATCH5_ADDR   		(32'h1f800024)
`define H_SCRATCH6_ADDR   		(32'h1f800028)
`define H_SCRATCH7_ADDR   		(32'h1f80002c)

`define H_LEDR_IONUM   			(4'h0)
`define H_LEDG_IONUM   			(4'h1)
`define H_SW_IONUM  			(4'h2)
`define H_PB_IONUM  			(4'h3)

`define H_SCRATCH0_IONUM  		(4'h4)
`define H_SCRATCH1_IONUM  		(4'h5)
`define H_SCRATCH2_IONUM  		(4'h6)
`define H_SCRATCH3_IONUM  		(4'h7)
`define H_SCRATCH4_IONUM  		(4'h8)
`define H_SCRATCH5_IONUM  		(4'h9)
`define H_SCRATCH6_IONUM  		(4'ha)
`define H_SCRATCH7_IONUM  		(4'hb)

//-------------------------------------------
// RAM addresses
//-------------------------------------------
`define H_RAM_RESET_ADDR 		(32'h1fc?????)
`define H_RAM_ADDR	 		(32'h0???????)
`define H_RAM_RESET_ADDR_WIDTH		(15) 
`define H_RAM_ADDR_WIDTH		(16) 

`define H_RAM_RESET_ADDR_Match 		(7'h7f)
`define H_RAM_ADDR_Match 		(1'b0)
`define H_LEDR_ADDR_Match		(7'h7e)

