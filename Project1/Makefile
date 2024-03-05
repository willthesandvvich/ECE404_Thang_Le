VERILOG_FILES := $(wildcard verilog/*.v)
VFLAGS := -Wimplicit -Wportbind
TESTS := arbiter_testbench

# Targets
testbench: ${VERILOG_FILES}
	@echo IVERILOG $@
	cd verilog && iverilog $(VFLAGS) -o $@ -s $@ $(^:verilog/%=%)
	mv verilog/$@ ./

arbiter_testbench: verilog/mipsfpga_ahb_arbiter.v verilog/mipsfpga_ahb_arbiter_testbench.v
	@echo IVERILOG $@
	cd verilog && iverilog $(VFLAGS) -o $@ -s mipsfpga_ahb_arbiter_testbench $(^:verilog/%=%)
	mv verilog/$@ ./

# Commands
.PHONY: simulate test

simulate: dump.fst
	@echo GTKWAVE $<
	gtkwave $<

dump.fst: testbench ram_reset_init.txt ram_program_init.txt
	@echo VVP $<
	vvp testbench -fst-space

clean:
	rm -f testbench $(TESTS) ram_reset_init.txt ram_program_init.txt dump.fst

test: $(TESTS:%=test_%)

# Test Infrastructure

test_%: %
	@/bin/echo -n "TEST $^ ... "
	bin/test $^

# LLVM Toolchain

.PHONY: install-toolchain

install-toolchain: cross/bin/clang

cross/bin/clang:
	cd cross && $(MAKE)

$(V).SILENT:

