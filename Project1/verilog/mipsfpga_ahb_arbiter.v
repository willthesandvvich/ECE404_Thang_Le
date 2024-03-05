// mipsfpga_ahb_arbiter.v
//
// 1 Feb 2017
//
// AHB Bus arbiter

module mipsfpga_ahb_arbiter
(
    input               HCLK,
    input               HRESETn,

    output reg [  3: 0] HMASTER, // Only allow 2 masters
    output reg          HMASTLOCK,

// From bus
    input               HREADY,
    input      [ 31: 0] HADDR,
    input      [  2: 0] HBURST,
    input      [  1: 0] HTRANS,
    // Probably will ignore upper bit (no split/retry-capable slaves)
    input      [  1: 0] HRESP,

// Request & Grant Lines
    input               HBUSREQ_CPU0,
    // HLOCKx prevents arbiter from degranting until lock is deasserted
    input               HLOCK_CPU0,
    output              HGRANT_CPU0,

    input               HBUSREQ_CPU1,
    input               HLOCK_CPU1,
    output              HGRANT_CPU1

// Unused
//  // Probably will be unused since no split-capable slaves
//  input      [ 15: 0] HSPLITx, 
);

    // Should the arbiter change who is being granted?
    wire        should_regrant;
    // How much of the current burst is left
    reg  [ 3:0] burst_count;
    // HLOCKx of granted master
    wire        granted_HLOCK;
    // HBUSREQx of granted master
    wire        granted_HBUSREQ;
    // Which master will be granted the bus?
    wire [ 3:0] granted_MASTER;
    // How many beats in the burst?
    reg  [ 3:0] initial_burst_count;
    wire        INCR_burst;
    wire        single_burst;
    // Burst is in last stage
    wire        burst_completing;
    // Which was granted the bus in the previous transaction?
    reg         last_grant;

    // Is there a new grant
    reg         new_grant;

    // Should regrant if all hold:
    //     1) current master has not made a locked request
    //     2) the current burst is completing
    //          a) beat count is 0, and a non-INCR burst
    //          b) SINGLE burst
    //     3) there has not been a new grant, unless it was a single burst
    assign should_regrant   = ~granted_HLOCK &
                              (burst_completing |
                                ((burst_count == 0) &
                                 ~INCR_burst) |
                                single_burst) &
                              (~new_grant | single_burst);

    assign granted_HLOCK    = ((HMASTER == 4'h0) & HLOCK_CPU0) |
                              ((HMASTER == 4'h1) & HLOCK_CPU1);

    assign granted_HBUSREQ  = ((HMASTER == 4'h0) & HBUSREQ_CPU0) |
                              ((HMASTER == 4'h1) & HBUSREQ_CPU1);

    assign granted_MASTER   = {3'b0, HGRANT_CPU1};

    // Burst is an INCR and has no specified number of beats
    assign INCR_burst       = (HBURST == 3'b001);
    // Single beat burst
    assign single_burst     = (HBURST == 3'b000);

    // A burst is completing if not a new grant and any hold:
    //     1) Only one beat left in a fixed-length burst
    //     2) INCR burst with a dropped request
    //     3) SINGLE burst
    assign burst_completing = ((burst_count == 4'h1) |
                              (INCR_burst & ~granted_HBUSREQ) |
                              (single_burst)) & ~new_grant;

    // Only one grant line can be high at a time
    assign HGRANT_CPU0      = (should_regrant) ?
                              HBUSREQ_CPU0 & (~HBUSREQ_CPU1 | last_grant) :
                              (HMASTER == 4'h0) &
                              (~burst_completing | HLOCK_CPU0);
    assign HGRANT_CPU1      = (should_regrant) ?
                              HBUSREQ_CPU1 & (~HBUSREQ_CPU0 | ~last_grant) :
                              (HMASTER == 4'h1) &
                              (~burst_completing | HLOCK_CPU1);

    always @(HBURST)
    begin
        // See Table 3-2 (page 3-11) of AMBA specification Rev 2.0
        case (HBURST)
            // Count is set to 1 less because the counter will be set the
            // cycle of the first beat in the burst
            // There are special cases handled for SINGLE and INCR
            3'b010 : initial_burst_count = 4'h3; // WRAP4
            3'b011 : initial_burst_count = 4'h3; // INCR4
            3'b100 : initial_burst_count = 4'h7; // WRAP8
            3'b101 : initial_burst_count = 4'h7; // INCR8
            3'b110 : initial_burst_count = 4'hf; // WRAP16
            3'b111 : initial_burst_count = 4'hf; // INCR16
            // Present only to prevent an inferred latch
            default : initial_burst_count = 4'b0;
        endcase
    end

    always @(negedge (HRESETn) or posedge (HCLK))
    begin

        if (!HRESETn)
        begin
            HMASTLOCK <= 1'b0;
            HMASTER <= 4'h0;
            last_grant <= 1'b0;
            new_grant <= 1'b0;
            burst_count <= 4'b0;
        end
        else
        begin
            if (HREADY)
            begin
                // If there is a grant, note which got the grant
                if (HGRANT_CPU0 | HGRANT_CPU1)
                    last_grant <= HGRANT_CPU1;
                // HMASTLOCK has the same timing as the address and
                // control signals
                HMASTLOCK <= granted_HLOCK;
                // If there is an active grant, there are one of two
                // options:
                // (1): The bus was not in use last cycle and
                //      burst_count will be 0.
                // (2): The bus was in use last cycle and burst_count
                //      will be 1. In this case, if there was no
                //      request to follow the finishing one, the grant
                //      line would not be asserted. Because a grant
                //      line *has* been asserted, there must be
                //      a request immediately following the current
                //      one. It is to be serviced the moment this one
                //      finishes. Because new_grant introduces a cycle
                //      delay, consider the grant to have started now
                //      so the rest of the logic works as it should.
                if ((HGRANT_CPU0 | HGRANT_CPU1) &
                    ((burst_count[3:1] == 3'b000) & ~new_grant &
                    ~(INCR_burst & granted_HBUSREQ) |
                    single_burst))
                begin
                    new_grant <= 1;
                    // HMASTER is 0 if #1 is granted, 1 if #2 is
                    // granted, default #1
                    HMASTER <= granted_MASTER;
                end
                else
                    new_grant <= 0;
                // On the first grant after a completed burst, reset
                // the burst count
                // Happens the cycle after setting HMASTER
                if (new_grant)
                    burst_count <= initial_burst_count;
                else if (burst_count != 4'b0000)
                    burst_count <= burst_count - 4'b1;
            end
        end

    end
    
endmodule

