// mipsfpga_sys.v
//
// This module is an add-on to the MIPS core, m14k_top. It instantiates // the MIPS core (m14k_top) and an AHB module of memories and I/Os on 
// the AHB-Lite bus. It also taps out the interface signals and 
// initializes signals required by the core.

`include "m14k_const.vh"

module mipsfpga_sys(input         SI_Reset_N,
                    input         SI_ClkIn,
                    output [31:0] HRDATA, //testbench
		    output        HREADY,
		    output	  HRESP,
		     output 	  SI_AHBStb,
		    output     	HCLK,
		    output 	HRESETn,
                    input         EJ_TRST_N_probe, //testbench
                    input         EJ_TDI, //testbench
                    output        EJ_TDO, //testbench
                    input         EJ_TMS, //testbench
                    input         EJ_TCK, //testbench
                    input         SI_ColdReset_N, //testbench
                    input         EJ_DINT,  //testbench
                    input  [17:0] IO_Switch, //testbnehc
                    input  [ 4:0] IO_PB, //testbench
                    output [17:0] IO_LEDR, //testbench
                    output [ 8:0] IO_LEDG, //testbench
                    
                    output [31:0] IO_SCRATCH0, //testbench
                    output [31:0] IO_SCRATCH1, //testbench
                    output [31:0] IO_SCRATCH2, //testbench
                    output [31:0] IO_SCRATCH3, //testbench
                    output [31:0] IO_SCRATCH4, //testbench
                    output [31:0] IO_SCRATCH5, //testbench
                    output [31:0] IO_SCRATCH6, //testbench
                    output [31:0] IO_SCRATCH7, //testbench
                    
		    output [1:0] CORE_ID,
		   
		    output [31:0] HADDR0,	
		    output [31:0] HRDATA0, //testbench
                    output [31:0] HWDATA0,  //testbench
                    output        HWRITE0,   //testbench
		    output        HREADY0,
		    output	  HRESP0,
		    output 	  SI_AHBStb0,
		    output     	 HCLK0,
		    output  	HRESETn0,
  		    output [2:0]  HBURST0,
		    output  [3:0] HPROT0,
		    output       HMASTLOCK0,
		    output   [2:0] HSIZE0,
   		    output   [1:0]   HTRANS0,	
            output HBUSREQ0,
            output HGRANT0,

                    output [31:0] HADDR1,	
		    output [31:0] HRDATA1, //testbench
                    output [31:0] HWDATA1,  //testbench
                    output        HWRITE1,   //testbench
		    output        HREADY1,
		    output	  HRESP1,
		    output 	  SI_AHBStb1,
		    output     	 HCLK1,
		    output  	HRESETn1,
  		    output [2:0]  HBURST1,
		    output  [3:0] HPROT1,
		    output       HMASTLOCK1,
		    output   [2:0] HSIZE1,
   		    output   [1:0]   HTRANS1,
            output HBUSREQ1,
            output HGRANT1
		
);

    /*
	wire           HREADY;         //AHB: Indicate the previous transfer is complete
	wire           HRESP;          //AHB: 0 is OKAY, 1 is ERROR
	wire 		SI_AHBStb;     //AHB: Signal indicating phase and frequency relationship between clk and hclk. 
	wire          HCLK;           //AHB: The bus clock times all bus transfer.
	wire          HRESETn;        //AHB: The bus reset signal is active LOW and resets the system and the bus.
	wire [2:0]    HBURST;         //AHB: Burst type; Only Two types:
                                                //                      3'b000  ---     Single; 3'b10  --- 4-beat Wrapping;
	wire [3:0]    HPROT;          //AHB: The single indicate the transfer type; Tie to 4'b0011, no significant meaning;
	wire          HMASTLOCK;      //AHB: Indicates the current transfer is part of a locked sequence; Tie to 0.
	wire [2:0]    HSIZE;          //AHB: Indicates the size of transfer; Only Three types:
                                                //              3'b000 --- Byte; 3'b001 --- Halfword; 3'b010 --- Word;
	wire  [1:0]  HTRANS;          //AHB: Indicates the transfer type; Three Types
                                                // 2'b00 --- IDLE, 2'b10 --- NONSEQUENTIAL, 2'b11 --- SEQUENTIAL.
	wire [31:0]  HADDR, HRDATA, HWDATA;
	wire HWRITE;
 	wire EJ_TRST_N_probe, EJ_TDI;
        wire EJ_TDO;
        wire EJ_TMS, EJ_TCK, EJ_DINT;

	*/ 
// All of the previous signals have been sent to the testbench
// System Interface Signals

	wire		SI_Endian;	// Base endianess: 1=big	
	wire		SI_Reset;       // greset THIS IS NOT CHANGED FOR NAY CORE
	wire		SI_ColdReset;

// ********************** WIRES FOR CORE 00************************************************
//*****************************************************************************************
	wire [1:0] CORE_ID0;
//	wire           HREADY0;         //AHB: Indicate the previous transfer is complete
//	wire           HRESP0;          //AHB: 0 is OKAY, 1 is ERROR
//	wire 	       SI_AHBStb0;     //AHB: Signal indicating phase and frequency relationship between clk and hclk. 
//	wire           HCLK0;           //AHB: The bus clock times all bus transfer.
//	wire           HRESETn0;        //AHB: The bus reset signal is active LOW and resets the system and the bus.
//	wire [2:0]     HBURST0;         //AHB: Burst type; Only Two types:
                                                //                      3'b000  ---     Single; 3'b10  --- 4-beat Wrapping;
//	wire [3:0]     HPROT0;          //AHB: The single indicate the transfer type; Tie to 4'b0011, no significant meaning;
//	wire           HMASTLOCK0;      //AHB: Indicates the current transfer is part of a locked sequence; Tie to 0.
//	wire [2:0]     HSIZE0;          //AHB: Indicates the size of transfer; Only Three types:
                                                //              3'b000 --- Byte; 3'b001 --- Halfword; 3'b010 --- Word;
//	wire  [1:0]   HTRANS0;          //AHB: Indicates the transfer type; Three Types
                                                // 2'b00 --- IDLE, 2'b10 --- NONSEQUENTIAL, 2'b11 --- SEQUENTIAL.
//	wire [31:0]  HADDR0, HRDATA0, HWDATA0;
//	wire HWRITE0;
 	wire EJ_TRST_N_probe0, EJ_TDI0;
        wire EJ_TDO0;
        wire EJ_TMS0, EJ_TCK0, EJ_DINT0;
	wire [7:0]     SI_Int0;         // Ext. Interrupt pins
	wire		SI_NMI0;         // Non-maskable interrupt
	
	wire [1:0]     SI_MergeMode0;	// SI_MergeMode[0] not used in this design
					// Merging algorithm: 
					// 00- No sub-word store merging
	                                // X1- Reserved
	                                // 10- Full merging - swiss cheese ok
					// Bus Mode
					// 00- Full ECi - swiss cheese, tribytes
					// 01- Naturally aligned B,H,W's only 	
					// 1X- Reserved


	wire [9:0]	SI_CPUNum0;	// EBase CPU number
	wire [2:0]	SI_IPTI0;	// TimerInt connection
	wire		SI_EICPresent0;	// External Interrupt cpntroller present
	wire [5:0]	SI_EICVector0;	// Vector number for EIC interrupt
	wire [17:1]	SI_Offset0;
	wire [3:0]	SI_EISS0;	// Shadow set, comes with the requested interrupt
	wire           SI_BootExcISAMode0;
	wire [3:0]     SI_SRSDisable0;  // Disable banks of shadow sets
	wire		SI_TraceDisable0; // Disables trace hardware	
	wire		SI_ClkOut0;	// External bus reference clock
	wire 		SI_ERL0;         // Error level pin
	wire 		SI_EXL0;         // Exception level pin
	wire		SI_NMITaken0;	// NMI pinned out
	wire		SI_NESTERL0;	// nested error level pinned out
	wire		SI_NESTEXL0;	// nested exception level pinned out
	wire 		SI_RP0;          // Reduce power pin
	wire 		SI_Sleep0;       // Processor is in sleep mode
	wire		SI_TimerInt0;    // count==compare interrupt
	wire [1:0]	SI_SWInt0;	// Software interrupt requests to external interrupt controller
	wire		SI_IAck0;	// Interrupt Acknowledge
	wire [7:0]    SI_IPL0;         // Current IPL, contains information of which int SI_IACK ack.
	wire [5:0] 	SI_IVN0;         // Cuurent IVN, contains information of which int SI_IAck ack.
	wire [17:1] 	SI_ION0;         // Cuurent ION, contains information of which int SI_IAck ack.
	wire [7:0]    SI_Ibs0;         // Instruction break status
	wire [3:0]    SI_Dbs0;         // Data break status
	// Performance monitoring signals
        wire          PM_InstnComplete0;
	/* Scan I/O's */
	wire		gscanmode0;
	wire		gscanenable0;
	wire [`M14K_NUM_SCAN_CHAIN-1:0] gscanin0;
	wire [`M14K_NUM_SCAN_CHAIN-1:0] gscanout0;                
	wire 		gscanramwr0;
	wire 		gmbinvoke0;
	wire		gmbdone0;	// Asserted to indicate that all mem-BIST test is done
	wire		gmbddfail0;  	// Asserted to indicate that D$ date test failed
	wire		gmbtdfail0;  	// Asserted to indicate that D$ tag test failed
	wire		gmbwdfail0;  	// Asserted to indicate that D$ WS test failed
	wire		gmbspfail0;  	// Asserted to indicate that D$ date test failed
	wire		gmbdifail0;  	// Asserted to indicate that I$ date test failed
	wire		gmbtifail0;  	// Asserted to indicate that I$tag test failed
	wire		gmbwifail0;  	// Asserted to indicate that I$WS test failed
	wire		gmbispfail0;  	// Asserted to indicate that D$ date test failed
	wire	[7:0]	gmb_ic_algorithm0; // Alogrithm selection for I$ BIST controller.
	wire	[7:0]	gmb_dc_algorithm0; // Alogrithm selection for D$ BIST controller.
	wire	[7:0]	gmb_isp_algorithm0; // Alogrithm selection for ISPRAM BIST controller.
	wire	[7:0]	gmb_sp_algorithm0; // Alogrithm selection for DSPRAM BIST controller.
	/* User defined Bist I/O's */
	wire  [`M14K_TOP_BIST_IN-1:0]	BistIn0;
	wire [`M14K_TOP_BIST_OUT-1:0]	BistOut0;
	/* EJTAG I/O's */
	wire 		EJ_TDOzstate0;
 	wire          EJ_ECREjtagBrk0;
	wire [10:0] 	EJ_ManufID0;
	wire [15:0] 	EJ_PartNumber0;
	wire [3:0] 	EJ_Version0;
	wire		EJ_DINTsup0;
	wire		EJ_DisableProbeDebug0;
	wire		EJ_PerRst0;
	wire		EJ_PrRst0;
	wire		EJ_SRstE0;
	wire 		EJ_DebugM0;	// Indication that we are in debug mode
	// TCB PIB signals
	wire [2:0]	TC_ClockRatio0;  	// User's clock ratio selection.
	wire		TC_Valid0;             	// Data valid indicator.  Not used in this design.
	wire [63:0]	TC_Data0;       		// Data from TCB.
	wire		TC_Stall0;             	// Stall request.  Not used in this design.
	wire           TC_PibPresent0;          // PIB is present    
// Impl specific IOs to cpu external modules
	wire  [`M14K_UDI_EXT_TOUDI_WIDTH-1:0] UDI_toudi0; // External input to UDI module
	wire  [`M14K_UDI_EXT_FROMUDI_WIDTH-1:0] UDI_fromudi0; // Output from UDI module to external system    
	wire [`M14K_CP2_EXT_TOCP2_WIDTH-1:0]   CP2_tocp20; // External input to COP2
	wire [`M14K_CP2_EXT_FROMCP2_WIDTH-1:0] CP2_fromcp20; // External output from COP2
	wire [`M14K_ISP_EXT_TOISP_WIDTH-1:0]    ISP_toisp0;  // External input ISPRAM
	wire [`M14K_ISP_EXT_FROMISP_WIDTH-1:0] ISP_fromisp0; // External output from ISPRAM
	wire [`M14K_DSP_EXT_TODSP_WIDTH-1:0]    DSP_todsp0;  // External input DSPRAM
	wire [`M14K_DSP_EXT_FROMDSP_WIDTH-1:0] DSP_fromdsp0; // External output from DSPRAM
	wire [2:0]  SI_IPFDCI0;       // FDC connection
	wire       SI_FDCInt0;      // FDC receive FIFO full interrupt
	wire [2:0]  SI_IPPCI0;       // PCI connection
	wire       SI_PCInt0;       // PCI receive full interrupt    
      wire trst_n0, EJ_TRST_N0;    // Reset core at EJTAG initialization
    wire [3:0] HMASTER;
	
//**********************************************************************************************
//********************************************************************************************************************


// ********************** WIRES FOR CORE 01************************************************
//*****************************************************************************************
	wire [1:0] 	CORE_ID1;
//	wire           HREADY1;         //AHB: Indicate the previous transfer is complete
//	wire           HRESP1;          //AHB: 0 is OKAY, 1 is ERROR
//	wire 	       SI_AHBStb1;     //AHB: Signal indicating phase and frequency relationship between clk and hclk. 
//	wire           HCLK1;           //AHB: The bus clock times all bus transfer.
//	wire           HRESETn1;        //AHB: The bus reset signal is active LOW and resets the system and the bus.
//	wire [2:0]     HBURST1;         //AHB: Burst type; Only Two types:
                                                //                      3'b000  ---     Single; 3'b10  --- 4-beat Wrapping;
//	wire [3:0]     HPROT1;          //AHB: The single indicate the transfer type; Tie to 4'b0011, no significant meaning;
//	wire           HMASTLOCK1;      //AHB: Indicates the current transfer is part of a locked sequence; Tie to 0.
//	wire [2:0]     HSIZE1;          //AHB: Indicates the size of transfer; Only Three types:
                                                //              3'b000 --- Byte; 3'b001 --- Halfword; 3'b010 --- Word;
//	wire  [1:0]   HTRANS1;          //AHB: Indicates the transfer type; Three Types
                                                // 2'b00 --- IDLE, 2'b10 --- NONSEQUENTIAL, 2'b11 --- SEQUENTIAL.
//	wire [31:0]  HADDR1, HRDATA1, HWDATA1;
//	wire HWRITE1;
 	wire EJ_TRST_N_probe1, EJ_TDI1;
        wire EJ_TDO1;
        wire EJ_TMS1, EJ_TCK1, EJ_DINT1;
	wire [7:0]     SI_Int1;         // Ext. Interrupt pins
	wire		SI_NMI1;         // Non-maskable interrupt
	
	wire [1:0]     SI_MergeMode1;	// SI_MergeMode[0] not used in this design
					// Merging algorithm: 
					// 00- No sub-word store merging
	                                // X1- Reserved
	                                // 10- Full merging - swiss cheese ok
					// Bus Mode
					// 00- Full ECi - swiss cheese, tribytes
					// 01- Naturally aligned B,H,W's only 	
					// 1X- Reserved
	
	wire [9:0]	SI_CPUNum1;	// EBase CPU number
	wire [2:0]	SI_IPTI1;	// TimerInt connection
	wire		SI_EICPresent1;	// External Interrupt cpntroller present
	wire [5:0]	SI_EICVector1;	// Vector number for EIC interrupt
	wire [17:1]	SI_Offset1;
	wire [3:0]	SI_EISS1;	// Shadow set, comes with the requested interrupt
	wire           SI_BootExcISAMode1;
	wire [3:0]     SI_SRSDisable1;  // Disable banks of shadow sets
	wire		SI_TraceDisable1; // Disables trace hardware	
	wire		SI_ClkOut1;	// External bus reference clock
	wire 		SI_ERL1;         // Error level pin
	wire 		SI_EXL1;         // Exception level pin
	wire		SI_NMITaken1;	// NMI pinned out
	wire		SI_NESTERL1;	// nested error level pinned out
	wire		SI_NESTEXL1;	// nested exception level pinned out
	wire 		SI_RP1;          // Reduce power pin
	wire 		SI_Sleep1;       // Processor is in sleep mode
	wire		SI_TimerInt1;    // count==compare interrupt
	wire [1:0]	SI_SWInt1;	// Software interrupt requests to external interrupt controller
	wire		SI_IAck1;	// Interrupt Acknowledge
	wire [7:0]    SI_IPL1;         // Current IPL, contains information of which int SI_IACK ack.
	wire [5:0] 	SI_IVN1;         // Cuurent IVN, contains information of which int SI_IAck ack.
	wire [17:1] 	SI_ION1;         // Cuurent ION, contains information of which int SI_IAck ack.
	wire [7:0]    SI_Ibs1;         // Instruction break status
	wire [3:0]    SI_Dbs1;         // Data break status
	// Performance monitoring signals
        wire          PM_InstnComplete1;
	/* Scan I/O's */
	wire		gscanmode1;
	wire		gscanenable1;
	wire [`M14K_NUM_SCAN_CHAIN-1:0] gscanin1;
	wire [`M14K_NUM_SCAN_CHAIN-1:0] gscanout1;                
	wire 		gscanramwr1;
	wire 		gmbinvoke1;
	wire		gmbdone1;	// Asserted to indicate that all mem-BIST test is done
	wire		gmbddfail1;  	// Asserted to indicate that D$ date test failed
	wire		gmbtdfail1;  	// Asserted to indicate that D$ tag test failed
	wire		gmbwdfail1;  	// Asserted to indicate that D$ WS test failed
	wire		gmbspfail1;  	// Asserted to indicate that D$ date test failed
	wire		gmbdifail1;  	// Asserted to indicate that I$ date test failed
	wire		gmbtifail1;  	// Asserted to indicate that I$tag test failed
	wire		gmbwifail1;  	// Asserted to indicate that I$WS test failed
	wire		gmbispfail1;  	// Asserted to indicate that D$ date test failed
	wire	[7:0]	gmb_ic_algorithm1; // Alogrithm selection for I$ BIST controller.
	wire	[7:0]	gmb_dc_algorithm1; // Alogrithm selection for D$ BIST controller.
	wire	[7:0]	gmb_isp_algorithm1; // Alogrithm selection for ISPRAM BIST controller.
	wire	[7:0]	gmb_sp_algorithm1; // Alogrithm selection for DSPRAM BIST controller.
	/* User defined Bist I/O's */
	wire  [`M14K_TOP_BIST_IN-1:0]	BistIn1;
	wire [`M14K_TOP_BIST_OUT-1:0]	BistOut1;
	/* EJTAG I/O's */
	wire 		EJ_TDOzstate1;
 	wire          EJ_ECREjtagBrk1;
	wire [10:0] 	EJ_ManufID1;
	wire [15:0] 	EJ_PartNumber1;
	wire [3:0] 	EJ_Version1;
	wire		EJ_DINTsup1;
	wire		EJ_DisableProbeDebug1;
	wire		EJ_PerRst1;
	wire		EJ_PrRst1;
	wire		EJ_SRstE1;
	wire 		EJ_DebugM1;	// Indication that we are in debug mode
	// TCB PIB signals
	wire [2:0]	TC_ClockRatio1;  	// User's clock ratio selection.
	wire		TC_Valid1;             	// Data valid indicator.  Not used in this design.
	wire [63:0]	TC_Data1;       		// Data from TCB.
	wire		TC_Stall1;             	// Stall request.  Not used in this design.
	wire           TC_PibPresent1;          // PIB is present    
// Impl specific IOs to cpu external modules
	wire  [`M14K_UDI_EXT_TOUDI_WIDTH-1:0] UDI_toudi1; // External input to UDI module
	wire  [`M14K_UDI_EXT_FROMUDI_WIDTH-1:0] UDI_fromudi1; // Output from UDI module to external system    
	wire [`M14K_CP2_EXT_TOCP2_WIDTH-1:0]   CP2_tocp21; // External input to COP2
	wire [`M14K_CP2_EXT_FROMCP2_WIDTH-1:0] CP2_fromcp21; // External output from COP2
	wire [`M14K_ISP_EXT_TOISP_WIDTH-1:0]    ISP_toisp1;  // External input ISPRAM
	wire [`M14K_ISP_EXT_FROMISP_WIDTH-1:0] ISP_fromisp1; // External output from ISPRAM
	wire [`M14K_DSP_EXT_TODSP_WIDTH-1:0]    DSP_todsp1;  // External input DSPRAM
	wire [`M14K_DSP_EXT_FROMDSP_WIDTH-1:0] DSP_fromdsp1; // External output from DSPRAM
	wire [2:0]  SI_IPFDCI1;       // FDC connection
	wire       SI_FDCInt1;      // FDC receive FIFO full interrupt
	wire [2:0]  SI_IPPCI1;       // PCI connection
	wire       SI_PCInt1;       // PCI receive full interrupt    
      wire trst_n1, EJ_TRST_N1;    // Reset core at EJTAG initialization
//***************************************************************************************************************
//*********************************************************************************************************


	//wire [1:0] CORE_ID;
//CORE INSTANTIATIONS
    m14k_top top (
			HRDATA0,
			HREADY0,
			HRESP0,
			SI_AHBStb0,
			HCLK0,
			HRESETn0,
			HADDR0,
			HBURST0,
			HPROT0,
			HMASTLOCK0,
			HSIZE0,
			HTRANS0,
			HWRITE0,
			HWDATA0,
            HBUSREQ0,
            HGRANT0,
			SI_ClkIn,		//Input Colck
			SI_ColdReset,		//Reset
			SI_Endian,		//Endianess
			SI_Int0,
			SI_NMI0,
			SI_Reset,
			SI_MergeMode0,
			SI_CPUNum0,
			SI_IPTI0,
			SI_EICPresent0,
			SI_EICVector0,
			SI_Offset0,
			SI_EISS0,
			SI_BootExcISAMode0,
			SI_SRSDisable0,
			SI_TraceDisable0,
			SI_ClkOut0,
			SI_ERL0,
			SI_EXL0,
			SI_NMITaken0,
			SI_NESTERL0,
			SI_NESTEXL0,
			SI_RP0,
			SI_Sleep0,
			SI_TimerInt0,
			SI_SWInt0,
			SI_IAck0,
			SI_IPL0,
			SI_IVN0,
			SI_ION0,
			SI_Ibs0,
			SI_Dbs0,
			PM_InstnComplete0,
			gscanmode0,
			gscanenable0,
			gscanin0,
			gscanout0,
			gscanramwr0,
			gmbinvoke0,
			gmbdone0,
			gmbddfail0,
			gmbtdfail0,
			gmbwdfail0,
			gmbspfail0,
			gmbdifail0,
			gmbtifail0,
			gmbwifail0,
			gmbispfail0,
			gmb_ic_algorithm0,
			gmb_dc_algorithm0,
			gmb_isp_algorithm0,
			gmb_sp_algorithm0,
			BistIn0,
			BistOut0,
			EJ_TCK0,
			EJ_TDO0,
			EJ_TDI0,
			EJ_TMS0,
			EJ_TRST_N0,
			EJ_TDOzstate0,
			EJ_ECREjtagBrk0,
			EJ_ManufID0,
			EJ_PartNumber0,
			EJ_Version0,
			EJ_DINTsup0,
			EJ_DINT0,
			EJ_DisableProbeDebug0,
			EJ_PerRst0,
			EJ_PrRst0,
			EJ_SRstE0,
			EJ_DebugM0,
			TC_ClockRatio0,
			TC_Valid0,
			TC_Data0,
			TC_Stall0,
			TC_PibPresent0,
			UDI_toudi0,
			UDI_fromudi0,
			CP2_tocp20,
			CP2_fromcp20,
			ISP_toisp0,
			ISP_fromisp0,
			DSP_todsp0,
			DSP_fromdsp0,
			SI_IPFDCI0,
			SI_FDCInt0,
			SI_IPPCI0,
			SI_PCInt0,
			2'b00,
			CORE_ID0);



m14k_top #(.RESET_VECTOR(12'h8)) top1 (
			HRDATA1,
			HREADY1,
			HRESP1,
			SI_AHBStb1,
			HCLK1,
			HRESETn1,
			HADDR1,
			HBURST1,
			HPROT1,
			HMASTLOCK1,
			HSIZE1,
			HTRANS1,
			HWRITE1,
			HWDATA1,
            HBUSREQ1,
            HGRANT1,
			SI_ClkIn,		//Input Colck
			SI_ColdReset,		//Reset
			SI_Endian,		//Endianess
			SI_Int1,
			SI_NMI1,
			SI_Reset,
			SI_MergeMode1,
			SI_CPUNum1,
			SI_IPTI1,
			SI_EICPresent1,
			SI_EICVector1,
			SI_Offset1,
			SI_EISS1,
			SI_BootExcISAMode1,
			SI_SRSDisable1,
			SI_TraceDisable1,
			SI_ClkOut1,
			SI_ERL1,
			SI_EXL1,
			SI_NMITaken1,
			SI_NESTERL1,
			SI_NESTEXL1,
			SI_RP1,
			SI_Sleep1,
			SI_TimerInt1,
			SI_SWInt1,
			SI_IAck1,
			SI_IPL1,
			SI_IVN1,
			SI_ION1,
			SI_Ibs1,
			SI_Dbs1,
			PM_InstnComplete1,
			gscanmode1,
			gscanenable1,
			gscanin1,
			gscanout1,
			gscanramwr1,
			gmbinvoke1,
			gmbdone1,
			gmbddfail1,
			gmbtdfail1,
			gmbwdfail1,
			gmbspfail1,
			gmbdifail1,
			gmbtifail1,
			gmbwifail1,
			gmbispfail1,
			gmb_ic_algorithm1,
			gmb_dc_algorithm1,
			gmb_isp_algorithm1,
			gmb_sp_algorithm1,
			BistIn1,
			BistOut1,
			EJ_TCK1,
			EJ_TDO1,
			EJ_TDI1,
			EJ_TMS1,
			EJ_TRST_N1,
			EJ_TDOzstate1,
			EJ_ECREjtagBrk1,
			EJ_ManufID1,
			EJ_PartNumber1,
			EJ_Version1,
			EJ_DINTsup1,
			EJ_DINT1,
			EJ_DisableProbeDebug1,
			EJ_PerRst1,
			EJ_PrRst1,
			EJ_SRstE1,
			EJ_DebugM1,
			TC_ClockRatio1,
			TC_Valid1,
			TC_Data1,
			TC_Stall1,
			TC_PibPresent1,
			UDI_toudi1,
			UDI_fromudi1,
			CP2_tocp21,
			CP2_fromcp21,
			ISP_toisp1,
			ISP_fromisp1,
			DSP_todsp1,
			DSP_fromdsp1,
			SI_IPFDCI1,
			SI_FDCInt1,
			SI_IPPCI1,
			SI_PCInt1,
			2'b01,
			CORE_ID1);



// AHB module that sits on AHB-Lite bus
    mipsfpga_ahb mipsfpga_ahb(
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        
        .HADDR0(HADDR0),
        .HBURST0(HBURST0),
        .HLOCK0(HMASTLOCK0),
        .HPROT0(HPROT0),
        .HSIZE0(HSIZE0),
        .HTRANS0(HTRANS0),
        .HWDATA0(HWDATA0),
        .HWRITE0(HWRITE0),
        .HBUSREQ0(HBUSREQ0),
        .HGRANT0(HGRANT0),

        .HADDR1(HADDR1),
        .HBURST1(HBURST1),
        .HLOCK1(HMASTLOCK1),
        .HPROT1(HPROT1),
        .HSIZE1(HSIZE1),
        .HTRANS1(HTRANS1),
        .HWDATA1(HWDATA1),
        .HWRITE1(HWRITE1),
        .HBUSREQ1(HBUSREQ1),
        .HGRANT1(HGRANT1),

        .HMASTER(HMASTER),
        .HRDATA(HRDATA),
        .HREADY(HREADY),
        .HRESP(HRESP),
        .SI_Endian(SI_Endian),
        .IO_Switch(IO_Switch),
        .IO_PB(IO_PB),
        .IO_LEDR(IO_LEDR),
        .IO_LEDG(IO_LEDG),
        
        .IO_SCRATCH0(IO_SCRATCH0),
        .IO_SCRATCH1(IO_SCRATCH1),
        .IO_SCRATCH2(IO_SCRATCH2),
        .IO_SCRATCH3(IO_SCRATCH3),
        .IO_SCRATCH4(IO_SCRATCH4),
        .IO_SCRATCH5(IO_SCRATCH5),
        .IO_SCRATCH6(IO_SCRATCH6),
        .IO_SCRATCH7(IO_SCRATCH7)
        );

// Module for hardware reset of EJTAG just after FPGA configuration
// It pulses EJ_TRST_N low for 16 clock cycles.
      ejtag_reset ejtag_reset(.clk(SI_ClkIn), .trst_n(trst_n0));

      assign HREADY0 = HREADY;
      assign HREADY1 = HREADY;
      assign HRDATA0 = HRDATA;
      assign HRDATA1 = HRDATA;
      assign HRESP0 = HRESP;
      assign HRESP1 = HRESP;
	assign trst_n1 = trst_n0;
      assign EJ_TRST_N0 = trst_n0 & EJ_TRST_N_probe0;
      assign EJ_TRST_N1 = trst_n1 & EJ_TRST_N_probe1;


    	assign SI_ColdReset = ~SI_ColdReset_N;
    	assign SI_Reset = ~SI_Reset_N;

    // the following signals need to be tied to something
    	assign SI_NMI0 = 0;
    	assign SI_EICPresent0 = 0;
    	assign SI_EICVector0 = 0;
        assign SI_EISS0 = 0;
	assign SI_Int0 = 0;         // Ext. Interrupt pins
	assign SI_Offset0 = 0;
	assign SI_IPTI0 = 0;	// TimerInt connection
	assign SI_CPUNum0 = 0;	// EBase CPU number
	assign SI_Endian = 1;	// Base endianess: 1=big
	assign SI_MergeMode0 = 0;	
	assign SI_SRSDisable0 = 4'b1111;  // Disable banks of shadow sets
	assign SI_TraceDisable0 = 1; // Disables trace hardware
	assign SI_IPFDCI0 = 0;       // FDC connection
	assign SI_IPPCI0 = 0;       // PCI connection
	assign SI_AHBStb0 = 1;     //AHB: Signal indicating phase and frequency relationship between clk and hclk. 
	assign SI_BootExcISAMode0 = 0;  

	/* EJTAG I/O's */
	assign EJ_ManufID0 = 0;
	assign EJ_PartNumber0 = 0;
	assign EJ_Version0 = 0;
	assign EJ_DINTsup0 = 0;
	assign EJ_DisableProbeDebug0 = 0; // Must be 0 to enable EJTAG debug

	assign TC_Stall0 = 0;             	// Stall request.  Not used in this design.
	assign TC_PibPresent0 = 0;          // PIB is present   

	assign gscanmode0 = 0;
	assign gscanenable0 = 0;
	assign gmbinvoke0 = 0;
	assign gscanramwr0 = 0;
	
	assign gmb_ic_algorithm0 = 0;
	assign gmb_dc_algorithm0 = 0;
	assign gmb_isp_algorithm0 = 0;
	assign gmb_sp_algorithm0 = 0;

	assign UDI_toudi0 = 0; // External input to UDI module
	assign CP2_tocp20 = 0; // External input to COP2
	assign ISP_toisp0 = 0;  // External input ISPRAM
	assign DSP_todsp0 = 0;  // External input DSPRAM
	
	assign SI_NMI1 = 0;
    	assign SI_EICPresent1 = 0;
    	assign SI_EICVector1 = 0;
        assign SI_EISS1 = 0;
	assign SI_Int1 = 0;         // Ext. Interrupt pins
	assign SI_Offset1 = 0;
	assign SI_IPTI1 = 0;	// TimerInt connection
	assign SI_CPUNum1 = 0;	// EBase CPU number
	//assign SI_Endian = 0;	// Base endianess: 1=big
	assign SI_MergeMode1 = 0;	
	assign SI_SRSDisable1 = 4'b1111;  // Disable banks of shadow sets
	assign SI_TraceDisable1 = 1; // Disables trace hardware
	assign SI_IPFDCI1 = 0;       // FDC connection
	assign SI_IPPCI1 = 0;       // PCI connection
	assign SI_AHBStb1 = 1;     //AHB: Signal indicating phase and frequency relationship between clk and hclk. 
	assign SI_BootExcISAMode1 = 0;  

	/* EJTAG I/O's */
	assign EJ_ManufID1 = 0;
	assign EJ_PartNumber1 = 0;
	assign EJ_Version1 = 0;
	assign EJ_DINTsup1 = 0;
	assign EJ_DisableProbeDebug1 = 0; // Must be 0 to enable EJTAG debug

	assign TC_Stall1 = 0;             	// Stall request.  Not used in this design.
	assign TC_PibPresent1 = 0;          // PIB is present   

	assign gscanmode1 = 0;
	assign gscanenable1 = 0;
	assign gmbinvoke1 = 0;
	assign gscanramwr1 = 0;
	
	assign gmb_ic_algorithm1 = 0;
	assign gmb_dc_algorithm1 = 0;
	assign gmb_isp_algorithm1 = 0;
	assign gmb_sp_algorithm1 = 0;

	assign UDI_toudi1 = 0; // External input to UDI module
	assign CP2_tocp21 = 0; // External input to COP2
	assign ISP_toisp1 = 0;  // External input ISPRAM
	assign DSP_todsp1 = 0;  // External input DSPRAM

	//assign HRESETn = HRESETn0;
	assign HRESETn = HRESETn0 | HRESETn1;
	//assign SI_AHBStb= SI_AHBStb0;
    // Should be the same for both...
	assign SI_AHBStb = SI_AHBStb0 | SI_AHBStb1;
	
	assign HCLK = HCLK0 || HCLK1;
	assign CORE_ID = HMASTER[1:0];
// **********************************************************************
	assign EJ_TRST_N_probe0 = EJ_TRST_N_probe;
	assign EJ_TRST_N_probe1 = EJ_TRST_N_probe;

	assign EJ_TDI0 = EJ_TDI;
	assign EJ_TDI1 = EJ_TDI;

    // Don't care about EJTAG
	assign EJ_TDO = EJ_TDO0;
	
	assign EJ_TMS0 = EJ_TMS;
	assign EJ_TMS1 = EJ_TMS;
	assign EJ_TCK0 = EJ_TCK;
	assign EJ_TCK1 = EJ_TCK;
	assign EJ_DINT0 = EJ_DINT;
	assign EJ_DINT1 = EJ_DINT;

endmodule
