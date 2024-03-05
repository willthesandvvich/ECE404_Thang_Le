// mipsfpga_ahb_arbiter_testbench.v
//
// 2 Feb 2017
//
// Testbench for mipsfpga_ahb_arbiter

`timescale 100ps/1ps
`include "test_helper.vh"

module mipsfpga_ahb_arbiter_testbench;

    `testDefines;

    reg         HCLK;
    reg         HRESETn;
    reg         HREADY;
    reg  [31:0] HADDR;
    reg  [ 2:0] HBURST;
    reg  [ 1:0] HTRANS;
    reg  [ 1:0] HRESP;

    reg         HBUSREQ_CPU0;
    reg         HLOCK_CPU0;
    wire        HGRANT_CPU0;

    reg         HBUSREQ_CPU1;
    reg         HLOCK_CPU1;
    wire        HGRANT_CPU1;

    wire [ 3:0] HMASTER;
    wire        HMASTLOCK;

    mipsfpga_ahb_arbiter arbiter(
        .HCLK(HCLK),
        .HRESETn(HRESETn),
        .HREADY(HREADY),
        .HADDR(HADDR),
        .HBURST(HBURST),
        .HTRANS(HTRANS),
        .HRESP(HRESP),
        .HBUSREQ_CPU0(HBUSREQ_CPU0),
        .HLOCK_CPU0(HLOCK_CPU0),
        .HGRANT_CPU0(HGRANT_CPU0),
        .HBUSREQ_CPU1(HBUSREQ_CPU1),
        .HLOCK_CPU1(HLOCK_CPU1),
        .HGRANT_CPU1(HGRANT_CPU1),
        .HMASTER(HMASTER),
        .HMASTLOCK(HMASTLOCK)
    );

    task test_handoff;
    begin
        HRESETn = 0;
        HBUSREQ_CPU0 = 0;
        HBUSREQ_CPU1 = 0;
        HLOCK_CPU0 = 0;
        HLOCK_CPU1 = 0;
        HADDR = 32'h0;
        HBURST = 3'b0;
        HTRANS = 2'b0;
        HRESP = 2'b0;
        HREADY = 0;
        repeat(5) @(posedge HCLK);
        HRESETn = 1;
        repeat(5) @(posedge HCLK);

        // Make the initial request (T1 in Figure 3-18 of AMBA Rev 2)
        #1 HBUSREQ_CPU0 = 1;
        HREADY = 1;
        #1 `assertEqual(HGRANT_CPU0, 1);

        // Address & Control (T2)
        // Should see HMASTER become 0 this cycle
        @(posedge HCLK);
        #1 HADDR = 32'hdead0000;
        HBURST = 3'b011; // INCR4
        `assertEqual(HMASTER, 0);
        `assertEqual(HGRANT_CPU0, 1);
        `assertEqual(HGRANT_CPU1, 0);

        // 1st data and CPU1 request (T3)
        @(posedge HCLK);
        #1 HADDR = HADDR + 4;
        HBUSREQ_CPU1 = 1;
        `assertEqual(HMASTER, 0);
        `assertEqual(HGRANT_CPU0, 1);
        `assertEqual(HGRANT_CPU1, 0);

        // 2nd data (T4)
        @(posedge HCLK);
        #1 HADDR = HADDR + 4;
        `assertEqual(HMASTER, 0);
        `assertEqual(HGRANT_CPU0, 1);

        // 3rd data (T5)
        @(posedge HCLK);
        // Grants should change from CPU0 to CPU1
        #1 HREADY = 0;
        HADDR = HADDR + 4;
        `assertEqual(HMASTER, 0);
        `assertEqual(HGRANT_CPU0, 0);
        `assertEqual(HGRANT_CPU1, 1);

        // 3rd data, part 2 (T6)
        @(posedge HCLK);
        #1 HREADY = 1;
        `assertEqual(HMASTER, 0);
        `assertEqual(HGRANT_CPU0, 0);
        `assertEqual(HGRANT_CPU1, 1);

        // Change of HMASTER (T7)
        @(posedge HCLK);
        // HMASTER should be 1
        #1 HADDR = 32'hbeef0000;
        HBURST = 3'b010; // WRAP4
        `assertEqual(HMASTER, 1);
        `assertEqual(HGRANT_CPU0, 0);
        `assertEqual(HGRANT_CPU1, 1);
        @(posedge HCLK);
    end
    endtask

    task test_handoff_with_lowered_request;
    begin
        HRESETn = 0;
        HBUSREQ_CPU0 = 0;
        HBUSREQ_CPU1 = 0;
        HLOCK_CPU0 = 0;
        HLOCK_CPU1 = 0;
        HADDR = 32'h0;
        HBURST = 3'b0;
        HTRANS = 2'b0;
        HRESP = 2'b0;
        HREADY = 0;
        repeat(5) @(posedge HCLK);
        HRESETn = 1;
        repeat(5) @(posedge HCLK);

        // Make the initial request (T1 in Figure 3-18 of AMBA Rev 2)
        #1 HBUSREQ_CPU0 = 1;
        HREADY = 1;
        #1 `assertEqual(HGRANT_CPU0, 1);

        // Address & Control (T2)
        // Should see HMASTER become 0 this cycle
        @(posedge HCLK);
        #1 HADDR = 32'hdead0000;
        HBURST = 3'b011; // INCR4
        HBUSREQ_CPU0 = 0;
        #1 `assertEqual(HMASTER, 0);
        `assertEqual(HGRANT_CPU0, 1);
        `assertEqual(HGRANT_CPU1, 0);

        // 1st data and CPU1 request (T3)
        @(posedge HCLK);
        #1 HADDR = HADDR + 4;
        HBUSREQ_CPU1 = 1;
        `assertEqual(HMASTER, 0);
        `assertEqual(HGRANT_CPU0, 1);
        `assertEqual(HGRANT_CPU1, 0);

        // 2nd data (T4)
        @(posedge HCLK);
        #1 HADDR = HADDR + 4;
        `assertEqual(HMASTER, 0);
        `assertEqual(HGRANT_CPU0, 1);

        // 3rd data (T5)
        @(posedge HCLK);
        // Grants should change from CPU0 to CPU1
        #1 HREADY = 0;
        HADDR = HADDR + 4;
        `assertEqual(HMASTER, 0);
        `assertEqual(HGRANT_CPU0, 0);
        `assertEqual(HGRANT_CPU1, 1);

        // 3rd data, part 2 (T6)
        @(posedge HCLK);
        #1 HREADY = 1;
        `assertEqual(HMASTER, 0);
        `assertEqual(HGRANT_CPU0, 0);
        `assertEqual(HGRANT_CPU1, 1);

        // Change of HMASTER (T7)
        @(posedge HCLK);
        // HMASTER should be 1
        #1 HADDR = 32'hbeef0000;
        HBURST = 3'b010; // WRAP4
        `assertEqual(HMASTER, 1);
        `assertEqual(HGRANT_CPU0, 0);
        `assertEqual(HGRANT_CPU1, 1);
        @(posedge HCLK);
    end
    endtask

    task test_keep_bus;
    begin
        HRESETn = 0;
        HBUSREQ_CPU0 = 0;
        HBUSREQ_CPU1 = 0;
        HLOCK_CPU0 = 0;
        HLOCK_CPU1 = 0;
        HADDR = 32'h0;
        HBURST = 3'b0;
        HTRANS = 2'b0;
        HRESP = 2'b0;
        HREADY = 0;
        repeat(5) @(posedge HCLK);
        HRESETn = 1;
        repeat(5) @(posedge HCLK);

        // Make the initial request (T1 in Figure 3-18 of AMBA Rev 2)
        #1 HBUSREQ_CPU0 = 1;
        HREADY = 1;
        #1 `assertEqual(HGRANT_CPU0, 1);

        // Address & Control (T2)
        // Should see HMASTER become 0 this cycle
        @(posedge HCLK);
        #1 HADDR = 32'hdead0000;
        HBURST = 3'b011; // INCR4
        #1 `assertEqual(HMASTER, 0);
        `assertEqual(HGRANT_CPU0, 1);
        `assertEqual(HGRANT_CPU1, 0);

        // 1st data
        @(posedge HCLK);
        #1 HADDR = HADDR + 4;
        `assertEqual(HMASTER, 0);
        `assertEqual(HGRANT_CPU0, 1);
        `assertEqual(HGRANT_CPU1, 0);

        // 2nd data
        @(posedge HCLK);
        #1 HADDR = HADDR + 4;
        `assertEqual(HMASTER, 0);
        `assertEqual(HGRANT_CPU0, 1);
        `assertEqual(HGRANT_CPU1, 0);

        // 3rd data
        @(posedge HCLK);
        #1 HREADY = 0;
        HADDR = HADDR + 4;
        `assertEqual(HMASTER, 0);
        `assertEqual(HGRANT_CPU0, 1);
        `assertEqual(HGRANT_CPU1, 0);

        // 3rd data, part 2
        @(posedge HCLK);
        #1 HREADY = 1;
        `assertEqual(HMASTER, 0);
        `assertEqual(HGRANT_CPU0, 1);
        `assertEqual(HGRANT_CPU1, 0);

        // Second transaction address & control
        @(posedge HCLK);
        // HMASTER should be 1
        #1 HADDR = 32'hbeef0000;
        HBURST = 3'b010; // WRAP4
        `assertEqual(HMASTER, 0);
        `assertEqual(HGRANT_CPU0, 1);
        `assertEqual(HGRANT_CPU1, 0);

        // 1st data and CPU1 request (T3)
        @(posedge HCLK);
        #1 HADDR = HADDR + 4;
        HBUSREQ_CPU1 = 1;
        `assertEqual(HMASTER, 0);
        `assertEqual(HGRANT_CPU0, 1);
        `assertEqual(HGRANT_CPU1, 0);

        // 2nd data (T4)
        @(posedge HCLK);
        #1 HADDR = HADDR + 4;
        `assertEqual(HMASTER, 0);
        `assertEqual(HGRANT_CPU0, 1);

        // 3rd data (T5)
        @(posedge HCLK);
        // Grants should change from CPU0 to CPU1
        #1 HREADY = 0;
        HADDR = HADDR + 4;
        `assertEqual(HMASTER, 0);
        `assertEqual(HGRANT_CPU0, 0);
        `assertEqual(HGRANT_CPU1, 1);

        // 3rd data, part 2 (T6)
        @(posedge HCLK);
        #1 HREADY = 1;
        `assertEqual(HMASTER, 0);
        `assertEqual(HGRANT_CPU0, 0);
        `assertEqual(HGRANT_CPU1, 1);

        // Change of HMASTER (T7)
        @(posedge HCLK);
        // HMASTER should be 1
        #1 HADDR = 32'hbeef0000;
        HBURST = 3'b010; // WRAP4
        `assertEqual(HMASTER, 1);
        `assertEqual(HGRANT_CPU0, 0);
        `assertEqual(HGRANT_CPU1, 1);
        @(posedge HCLK);
    end
    endtask

    task test_handoff_single;
    begin
        HRESETn = 0;
        HBUSREQ_CPU0 = 0;
        HBUSREQ_CPU1 = 0;
        HLOCK_CPU0 = 0;
        HLOCK_CPU1 = 0;
        HADDR = 32'h0;
        HBURST = 3'b0;
        HTRANS = 2'b0;
        HRESP = 2'b0;
        HREADY = 0;
        repeat(5) @(posedge HCLK);
        HRESETn = 1;
        repeat(5) @(posedge HCLK);

        // Make the initial request (T1 in Figure 3-18 of AMBA Rev 2)
        #1 HBUSREQ_CPU0 = 1;
        HREADY = 1;
        #1 `assertEqual(HGRANT_CPU0, 1);
        `assertEqual(HGRANT_CPU1, 0);

        // Address & Control (T2)
        // Should see HMASTER become 0 this cycle
        @(posedge HCLK);
        #1 HADDR = 32'hdead0000;
        HBURST = 3'b000; // Single
        HBUSREQ_CPU1 = 1;
        `assertEqual(HMASTER, 0);
        #1 `assertEqual(HGRANT_CPU0, 0);
        `assertEqual(HGRANT_CPU1, 1);

        // Should see HMASTER become 1 this cycle
        @(posedge HCLK);
        #1 HADDR = 32'hbeef0000;
        `assertEqual(HMASTER, 1);

        @(posedge HCLK);
    end
    endtask

    task test_lock_prevents_handoff;
    begin
        HRESETn = 0;
        HBUSREQ_CPU0 = 0;
        HBUSREQ_CPU1 = 0;
        HLOCK_CPU0 = 0;
        HLOCK_CPU1 = 0;
        HADDR = 32'h0;
        HBURST = 3'b0;
        HTRANS = 2'b0;
        HRESP = 2'b0;
        HREADY = 0;
        repeat(5) @(posedge HCLK);
        HRESETn = 1;
        repeat(5) @(posedge HCLK);

        // Make the initial request (T1 in Figure 3-18 of AMBA Rev 2)
        #1 HBUSREQ_CPU0 = 1;
        HLOCK_CPU0 = 1;
        HREADY = 1;
        #1 `assertEqual(HGRANT_CPU0, 1);
        `assertEqual(HGRANT_CPU1, 0);
        `assertEqual(HMASTLOCK, 0);

        // Address & Control (T2)
        // Should see HMASTER become 0 this cycle
        @(posedge HCLK);
        #1 HADDR = 32'hdead0000;
        HBURST = 3'b000; // Single
        HBUSREQ_CPU1 = 1;
        `assertEqual(HMASTER, 0);
        #1 `assertEqual(HGRANT_CPU0, 1);
        `assertEqual(HGRANT_CPU1, 0);
        `assertEqual(HMASTLOCK, 1);

        // Because of the lock, the master should remain 0
        @(posedge HCLK);
        #1 HADDR = 32'hbeef0000;
        `assertEqual(HMASTER, 0);

        @(posedge HCLK);
    end
    endtask

    task test_incr_handoff;
    begin
        HRESETn = 0;
        HBUSREQ_CPU0 = 0;
        HBUSREQ_CPU1 = 0;
        HLOCK_CPU0 = 0;
        HLOCK_CPU1 = 0;
        HADDR = 32'h0;
        HBURST = 3'b0;
        HTRANS = 2'b0;
        HRESP = 2'b0;
        HREADY = 0;
        repeat(5) @(posedge HCLK);
        HRESETn = 1;
        repeat(5) @(posedge HCLK);

        // Make the initial request (T1 in Figure 3-18 of AMBA Rev 2)
        #1 HBUSREQ_CPU0 = 1;
        HREADY = 1;
        #1 `assertEqual(HGRANT_CPU0, 1);
        `assertEqual(HGRANT_CPU1, 0);
        `assertEqual(HMASTLOCK, 0);

        // Address & Control (T2)
        // Should see HMASTER become 0 this cycle
        @(posedge HCLK);
        #1 HADDR = 32'hdead0000;
        HBURST = 3'b001; // INCR
        HBUSREQ_CPU1 = 1;
        `assertEqual(HMASTER, 0);
        #1 `assertEqual(HGRANT_CPU0, 1);
        `assertEqual(HGRANT_CPU1, 0);

        // Because of the lock, the master should remain 0
        @(posedge HCLK);
        #1 HADDR = 32'hdead0004;
        `assertEqual(HMASTER, 0);
        `assertEqual(HGRANT_CPU0, 1);
        `assertEqual(HGRANT_CPU1, 0);

        // Simulate a lot of clock cycles
        // The master or grants shouldn't change
        repeat (16) begin
            @(posedge HCLK);
            #1 HADDR = HADDR + 32'h4;
            `assertEqual(HMASTER, 0);
            `assertEqual(HGRANT_CPU0, 1);
            `assertEqual(HGRANT_CPU1, 0);
        end

        // Drop the CPU 0 bus request
        @(posedge HCLK);
        #1 HADDR = HADDR + 32'h4;
        HBUSREQ_CPU0 = 0;
        #1 `assertEqual(HGRANT_CPU0, 0);
        `assertEqual(HGRANT_CPU1, 1);

        @(posedge HCLK);
        #1 `assertEqual(HMASTER, 1);
        HADDR = 32'hbeef0000;

        @(posedge HCLK);
    end
    endtask
    initial
    begin
        HCLK = 0;
        `initTest;

        test_handoff();
        test_handoff_with_lowered_request();
        test_keep_bus();
        test_handoff_single();
        test_lock_prevents_handoff();
        test_incr_handoff();

        `finishTest;
    end

    always
        #5  HCLK = ~HCLK;

endmodule

