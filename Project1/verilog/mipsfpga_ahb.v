// mipsfpga_ahb.v
//
// 13 Feb 2017
//
// Mostly standards-compliant AHB Bus

module mipsfpga_ahb
(
    input               HCLK,
    input               HRESETn,

    // From each master
    input      [ 31: 0] HADDR0,
    input      [  2: 0] HBURST0,
    input      [  3: 0] HPROT0,
    input      [  2: 0] HSIZE0,
    input      [  1: 0] HTRANS0,
    input      [ 31: 0] HWDATA0,
    input               HWRITE0,
    input               HBUSREQ0,
    input               HLOCK0,
    output              HGRANT0,

    input      [ 31: 0] HADDR1,
    input      [  2: 0] HBURST1,
    input      [  3: 0] HPROT1,
    input      [  2: 0] HSIZE1,
    input      [  1: 0] HTRANS1,
    input      [ 31: 0] HWDATA1,
    input               HWRITE1,
    input               HBUSREQ1,
    input               HLOCK1,
    output              HGRANT1,

    // To all masters
    output     [  3: 0] HMASTER, // Will only have 2
    output     [ 31: 0] HRDATA,
    output              HREADY,
    output              HRESP,

    // Config
    input               SI_Endian,

    // memory-mapped I/O
    input      [ 17: 0] IO_Switch,
    input      [  4: 0] IO_PB,
    output     [ 17: 0] IO_LEDR,
    output     [  8: 0] IO_LEDG,
    
    output     [ 31: 0] IO_SCRATCH0,
    output     [ 31: 0] IO_SCRATCH1,
    output     [ 31: 0] IO_SCRATCH2,
    output     [ 31: 0] IO_SCRATCH3,
    output     [ 31: 0] IO_SCRATCH4,
    output     [ 31: 0] IO_SCRATCH5,
    output     [ 31: 0] IO_SCRATCH6,
    output     [ 31: 0] IO_SCRATCH7
);

    // Address and Control
    wire   [ 31: 0] HADDR;
    wire   [  2: 0] HBURST;
    wire            HMASTLOCK;
    wire   [  3: 0] HPROT;
    wire   [  2: 0] HSIZE;
    wire   [  1: 0] HTRANS;

    // Write Data
    wire   [ 31: 0] HWDATA;
    wire            HWRITE;

    wire   [  3: 0] hmaster_reg;
    // Change over control of the data bus one cycle AFTER the master changes
    // (assuming ready)
    // (q, cond, clk, d)
    mvp_cregister #(4) _hmaster_reg(hmaster_reg, HREADY, HCLK, HMASTER);

    // Address and Control (ONLY FOR 2 MASTERS)
    assign HADDR = (HMASTER == 4'b0000) ? HADDR0 : HADDR1;
    assign HBURST = (HMASTER == 4'b0000) ? HBURST0 : HBURST1;
    assign HPROT = (HMASTER == 4'b0000) ? HPROT0 : HPROT1;
    assign HSIZE = (HMASTER == 4'b0000) ? HSIZE0 : HSIZE1;
    assign HTRANS = (HMASTER == 4'b0000) ? HTRANS0 : HTRANS1;

    // Write Data
    assign HWDATA = (hmaster_reg == 4'b0000) ? HWDATA0 : HWDATA1;
    assign HWRITE = (HMASTER == 4'b0000) ? HWRITE0 : HWRITE1;

    mipsfpga_ahb_lite ahb_lite(
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        .HADDR(HADDR),
        .HBURST(HBURST),
        .HMASTLOCK,
        .HPROT(HPROT),
        .HSIZE(HSIZE),
        .HTRANS(HTRANS),
        .HWDATA(HWDATA),
        .HWRITE(HWRITE),
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

    mipsfpga_ahb_arbiter arbiter(
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        .HMASTER(HMASTER),
        .HMASTLOCK(HMASTLOCK),
        .HREADY(HREADY),
        .HADDR(HADDR),
        .HBURST(HBURST),
        .HTRANS(HTRANS),
        .HRESP({1'b0, HRESP}), // No Split/Retry: only care about lower bit
        .HBUSREQ_CPU0(HBUSREQ0),
        .HLOCK_CPU0(HLOCK0),
        .HGRANT_CPU0(HGRANT0),
        .HBUSREQ_CPU1(HBUSREQ1),
        .HLOCK_CPU1(HLOCK1),
        .HGRANT_CPU1(HGRANT1)
    );

endmodule

