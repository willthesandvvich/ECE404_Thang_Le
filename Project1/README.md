Dual Processor MIPSfpga
=======================

A dual-processor system based on MIPSfpga

Design
------

The MIPSfpga is a system with a M14Kc processor connected to I/O and memory
through an AHB-Lite interconnect. This extends the system by adding a second
processor and upgrading the AHB-Lite interconnect to AHB.

Organization
------------

- All verilog RTL files are in the **verilog** directory.
- Scripts and tools for compiling/assembling files and simulation are in the
  **bin** directory.
- Example programs are in the **programs** directory.
- Boot code (used by the assembler) is located in the **boot** directory.
- Documentation can be found in the **doc** directory.

Setup
-----

The following need to be installed to simulate the system:

- [Icarus Verilog](http://iverilog.icarus.com) to simulate
- [GTKWave](http://gtkwave.sourceforge.net) to view waveforms
    - If after installing, there is no `gtkwave` executable in your path,
      you may need to create a script to invoke GTKWave (see **bin/simulate**
      for how it will be called).
- [Python 3.5+](https://www.python.org) to assemble programs
    - You should be able to call `python3 --version` and see a version higher
      than 3.5 for the assembler to work.
- [GCC MIPS](https://gcc.gnu.org) to compile programs
    - Use the gcc-mips-linux-gnu target

Simulation
----------

### Assembling a Program

To assemble a program to be executed by the processor, invoke `bin/assemble`.

For example, to assemble the **onoff** program, invoke:

```bash
$ bin/assemble programs/onoff.S
```

This will generate the **ram_reset_init.txt** and **ram_program_init.txt**
that will be loaded into main memory.

By default, programs will be loaded into uncached memory. To load programs
into cacheable memory, pass the `--cached` flag to `bin/assemble`.

```bash
$ bin/assemble --cached programs/onoff.S
```

When simulated, it will take about 5-6K cycles for caches to be fully
initialized.

### Compiling a Program

To compile a program to be executed by the processor, invoke `bin/compile`.

For example, to compile the **onoff** program, invoke:

```bash
$ bin/compile programs/onoff.c
```

Besides **ram_reset_init.txt** and **ram_program_init.txt**, this also
generates the **disasm.S** that is the disassembly of your program.

Use the `--cached` flag to load the programs into cacheable memory.

### Simulating the Program

Once a program has been assembled or compiled, call

```bash
$ make simulate
```

This will compile a model (if necessary) and simulate it for about 10K cycles.
Provided GTKWave is set up, it will open and load the waveforms from the
simulation.

