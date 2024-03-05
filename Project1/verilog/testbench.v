// testbench.v
// 31 May 2014
//
// Drive the mipsfpga_sys module for simulation testing

`timescale 100ps/1ps

module testbench;

    reg  SI_Reset_N, SI_ClkIn;
    wire [31:0] HADDR, HRDATA, HWDATA;
    wire        HWRITE;
     wire           HREADY;         
     wire           HRESP;          
     wire 	    SI_AHBStb;     
     wire          HCLK;          
     wire          HRESETn;        
     wire [2:0]    HBURST;                                                 
     wire [3:0]    HPROT;          
     wire          HMASTLOCK;      
     wire [2:0]    HSIZE;                                                   
     wire  [1:0]  HTRANS;


	wire [31:0] HADDR0, HRDATA0, HWDATA0;
    wire        HWRITE0;
     wire           HREADY0;         
     wire           HRESP0;          
     wire 	    SI_AHBStb0;     
     wire          HCLK0;          
     wire          HRESETn0;        
     wire [2:0]    HBURST0;                                                 
     wire [3:0]    HPROT0;          
     wire          HMASTLOCK0;      
     wire [2:0]    HSIZE0;                                                   
     wire  [1:0]  HTRANS0;
    wire        HBUSREQ0;
    wire        HGRANT0;

	wire [31:0] HADDR1, HRDATA1, HWDATA1;
    wire        HWRITE1;
     wire           HREADY1;         
     wire           HRESP1;          
     wire 	    SI_AHBStb1;     
     wire          HCLK1;          
     wire          HRESETn1;        
     wire [2:0]    HBURST1;                                                 
     wire [3:0]    HPROT1;          
     wire          HMASTLOCK1;      
     wire [2:0]    HSIZE1;                                                   
     wire  [1:0]  HTRANS1;
     wire         HBUSREQ1;
     wire         HGRANT1;
        
     wire [1:0] CORE_ID; 
                                          
    reg         EJ_TRST_N_probe, EJ_TDI; 
    wire        EJ_TDO;
    reg         SI_ColdReset_N;
    reg         EJ_TMS, EJ_TCK, EJ_DINT;
    wire [17:0] IO_Switch;
    wire [ 4:0] IO_PB;
    wire [17:0] IO_LEDR;
    wire [ 8:0] IO_LEDG;
    
    wire [31:0] IO_SCRATCH0;
    wire [31:0] IO_SCRATCH1;
    wire [31:0] IO_SCRATCH2;
    wire [31:0] IO_SCRATCH3;
    wire [31:0] IO_SCRATCH4;
    wire [31:0] IO_SCRATCH5;
    wire [31:0] IO_SCRATCH6;
    wire [31:0] IO_SCRATCH7;
    
   wire count_bit;
	
    mipsfpga_sys sys(SI_Reset_N,
                 SI_ClkIn,
                 HRDATA, HREADY,HRESP,SI_AHBStb,HCLK,HRESETn,
                 EJ_TRST_N_probe, EJ_TDI, EJ_TDO, EJ_TMS, 
                 EJ_TCK, 
                 SI_ColdReset_N, 
                 EJ_DINT,
                 IO_Switch, IO_PB, IO_LEDR, IO_LEDG,
                 IO_SCRATCH0, IO_SCRATCH1, IO_SCRATCH2, IO_SCRATCH3,
                 IO_SCRATCH4, IO_SCRATCH5, IO_SCRATCH6, IO_SCRATCH7,
                 CORE_ID,
		 HADDR0, HRDATA0, HWDATA0, HWRITE0, HREADY0, HRESP0, SI_AHBStb0, HCLK0,
		  HRESETn0, HBURST0, HPROT0, HMASTLOCK0, HSIZE0, HTRANS0, HBUSREQ0, HGRANT0,
		 HADDR1, HRDATA1, HWDATA1, HWRITE1, HREADY1, HRESP1, SI_AHBStb1, HCLK1,
		  HRESETn1, HBURST1, HPROT1, HMASTLOCK1, HSIZE1, HTRANS1, HBUSREQ1, HGRANT1);

    initial
    begin
        SI_ClkIn = 0;
        EJ_TRST_N_probe = 0; EJ_TDI = 0; EJ_TMS = 0; EJ_TCK = 0; EJ_DINT = 0;
        SI_ColdReset_N = 1;

        forever
	   begin
            #50 SI_ClkIn = ~ SI_ClkIn;
	    end	
    end

    initial
    begin
        SI_Reset_N  <= 0;
        repeat (100)  @(posedge SI_ClkIn);
        SI_Reset_N  <= 1;
        repeat (10000) @(posedge SI_ClkIn);
        $finish;
    end

    initial
    begin
        $dumpvars;
        $timeformat (-9, 1, "ns", 10);
    end
    
endmodule


