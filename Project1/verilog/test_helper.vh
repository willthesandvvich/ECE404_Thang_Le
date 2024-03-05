`define assertEqual(lhs, rhs) \
    if (lhs != rhs) \
    begin \
        $display("ASSERTION FAILED: %s (%0d) != %0d (%s:%0d)", `"lhs`", lhs, rhs, `__FILE__, `__LINE__); \
        FAILURES = FAILURES + 1; \
    end

`define finishTest \
    if (FAILURES != 0) \
    begin \
        $display("%0d ASSERTIONS FAILED\n", FAILURES); \
        $stop; \
    end \
    else \
        $display("ok"); \
    $finish;

`define initTest FAILURES = 0;
`define testDefines integer FAILURES

