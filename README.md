<img src="https://raw.githubusercontent.com/pulp-platform/pulpino/master/doc/datasheet/figures/pulpino_logo_inline1.png" width="400px" />

# Introduction

PULPino is an open-source single-core microcontroller system, based on 32-bit
RISC-V cores developed at ETH Zurich. PULPino is configurable to use either 
the RISCY or the zero-riscy core.

RISCY is an in-order, single-issue core with 4 pipeline stages and it has
an IPC close to 1, full support for the base integer instruction set (RV32I),
compressed instructions (RV32C) and multiplication instruction set
extension (RV32M). It can be configured to have single-precision floating-point
instruction set extension (RV32F). It implements several ISA extensions such as:
hardware loops, post-incrementing load and store instructions, bit-manipulation
instructions, MAC operations, support fixed-point operations, packed-SIMD instructions
and the dot product. It has been designed to increase the energy efficiency of
in ultra-low-power signal processing applications.
RISCY implementes a subset of the 1.9 privileged specification.
Further informations can be found in http://ieeexplore.ieee.org/abstract/document/7864441/.

zero-riscy is an in-order, single-issue core with 2 pipeline stages and it has
full support for the base integer instruction set (RV32I) and 
compressed instructions (RV32C). It can be configured to have multiplication instruction set
extension (RV32M) and the reduced number of registers extension (RV32E).
It has been designed to target ultra-low-power and ultra-low-area constraints.
zero-riscy implementes a subset of the 1.9 privileged specification.

When the core is idle, the platform can be put into a low power mode, 
where only a simple event unit is active and everything else is clock-gated and consumes minimal power (leakage).
A specialized event unit wakes up the core in case an event/interrupt arrives.

For communication with the outside world, PULPino contains a broad set of
peripherals, including I2S, I2C, SPI and UART. The platform internal devices
can be accessed from outside via JTAG and SPI which allows pre-loading
RAMs with executable code. In standalone mode, the platform boots from an
internal boot ROM and loads its program from an external SPI flash.

The PULPino platform is available for RTL simulation as well FPGA.
PULPino has been taped-out as an ASIC in UMC 65nm in January 2016. It has full
debug support on all targets. In addition we support extended profiling with
source code annotated execution times through KCacheGrind in RTL simulations.


## Requirements

PULPino has the following requirements

- ModelSim in reasonably recent version (we tested it with versions >= 10.2c)
- CMake >= 2.8.0, versions greater than 3.1.0 recommended due to support for ninja
- riscv-toolchain, specifically you need riscv32-unknown-elf-gcc compiler and
  friends. There are two choices for this toolchain: Either using the official
  RISC-V toolchain supported by Berkeley or the custom RISC-V toolchain from
  ETH. The ETH versions supports all the ISA extensions that were incorporated
  into the RI5CY core as well as the reduced base instruction set for zero-riscy.
  Please make sure you are using the newlib version of the toolchain.
- python2 >= 2.6
- verilator 3.884 only necessary if you want to use Verilator to evaluate PULPino.

## ISA Support

PULPino can run either with RISCY or zero-riscy.
The software included in this repository is compatible with both the cores
and automatically targets the correct ISA based on the flags used.
The simulator (modelsim) must be explicitely told which edition you want to build.
Use the environment variable `USE_ZERO_RISCY` and set it to either `1` for zero-riscy or 
`0` for RISCY.

## Version Control

PULPino uses multiple git subrepositories

To clone those subrepositores and update them, use

    ./update-ips.py

This script will read the `ips_lists.txt` file and update to the versions
specified in there. You can choose specific commits, tags or branches.


## Documentation

There is a preliminary datasheet available that includes a block diagram and a memory map of PULPino.
See docs/datasheet/ in this repository.

It is written in LaTeX and there is no pdf included in the repository. Simply type

    make all

inside the folder to generate the pdf. Note that you need a working version of latex for this step.


## Running simulations

The software is built using CMake.
Create a build folder somewhere, e.g. in the sw folder

    mkdir build

Copy the cmake-configure.{*}.gcc.sh bash script to the build folder.
This script can be found in the sw subfolder of the git repository.

Modify the cmake-configure script to your needs and execute it inside the build folder.
This will setup everything to perform simulations using ModelSim.

Four cmake-configure bash scripts have been already configured:

1) cmake_configure.riscv.gcc.sh

It automatically selects the RISCY cores and compiles SW with all the PULP-extensions 
and the RV32IM support.
The GCC ETH compiler is needed and the GCC march flag set to "IMXpulpv2".

2) cmake_configure.riscvfloat.gcc.sh

It automatically selects the RISCY cores and compiles SW with all the PULP-extensions 
and the RV32IMF support.
The GCC ETH compiler is needed and he GCC march flag set to "IMFXpulpv2".

3) cmake_configure.zeroriscy.gcc.sh

It automatically selects the zero-riscy cores and compiles SW with the RV32IM support
(march flag set to RV32IM).

4) cmake_configure.microriscy.gcc.sh

It automatically selects the zero-riscy cores and compiles SW with the RV32E support.
The slim GCC ETH compiler is needed and he GCC march flag set to "RV32I" and the "-m16r"
is passed to the compiler to use only the RV32E ISA support.


Activate the RVC flag in the cmake file if compressed instructions are desired.


Inside the build folder, execute

    make vcompile

to compile the RTL libraries using ModelSim.

To run a simulation in the modelsim GUI use

    make helloworld.vsim


To run simulations in the modelsim console use

    make helloworld.vsimc

This will output a summary at the end of the simulation.
This is intended for batch processing of a large number of tests.

Replace helloworld with the test/application you want to run.


### Using ninja instead of make

You can use ninja instead make to build software for PULPino, just replace all
occurrences of make with ninja.
The same targets are supported on both make and ninja.



## Interactive debug

To interactively debug software via gdb, you need the jtag bridge as well as a
working version of gdb for the ISA you want to debug. The debug bridge depends
on the `jtag_dpi` package that emulates a JTAG port and provides a TCP socket
to which the jtag bridge can connect to.


## Utilities

We additionally provide some utilitiy targets that are supposed to make
development for PULPino easier.

For disassembling a program call

    make helloworld.read

To regenerate the bootcode and copy it to the `rtl` folder use

    make boot_code.install

## FPGA

PULPino can be synthesized and run on a ZedBoard.
Take a look at the `fpga` subfolder for more information.

## Creating a tarball of the PULPino sources

If for some reason you don't want to use the git sub-repository approach, you
can create a tarball of the whole design by executing `./create-tarball.py`.
This will download the latest PULPino sources, including all IPS, remove the
git internal folders and create a tar gz.


## Arduino compatible libraries

Most of official Arduino libraries are supported by PULPino software, they can
be compiled, simulated and uploded the same way as traditional software programs
using the available PULPino utilities. You only need to include main.cpp at the
beginning of the program:

	#include "main.cpp"

Take a look at the `sw/libs/Arduino_libs` subfolder for more information about the status of the currently supported libraries.

---
# Modification History

## run `update-ips.py` in this way:
```shell
./update-ips.py https://github.com
```

## run PULPino on Arty board

1. Update FPGA build environment
- Define environment variables : `XILINX_PART` and `XILINX_BOARD` by adding `fpga/common/set_board.sh`, you can put it in the end of `~/.bashrc`.
- add new makefile `fpga/Makefile.arty` 
- add `fpga/arty_top`: new FPGA top wrapper
- add `fpga/ips/arty_mmcm` : handles clocks (Arty board uses 100MHz xtal)
- add `fpga/ips/arty_mem_8192x32` : instruction memory ,keep the same name of xilinx_mem_8192x32 to avoid RTL change.

2. Create new fpga top wrapper 
- add `fpga/rtl/arty_top.v`

### 2.1 Helloworld
- connect UART on arty fpga top
- rename data memory to xilinx_dmem_8192x32 in `rtl/core_region.sv`
- generate memory init file(.coe) from rtl simulation
- add `fpga/rtl/tb.sv` for simulation, whereas `tb/uart.sv` is reused.

```shell
#1 build helloworld apps : `sw/build/apps/helloworld/slm_files`
    cd sw/build
    make vcompile
    make helloworld.vsimc

#2 generate memory init file
    cd fpga/common
    ./gen_imem_coe.sh helloworld   -> ips/arty_mem_8192x32/xilinx_mem_8192x32.coe
    ./gen_dmem_coe.sh helloworld   -> ips/arty_dmem_8192x32/xilinx_dmem_8192x32.coe
    
#3 generate bit stream
    cd fpga
    make -f Makefile.arty all

```

### 2.2 Boot from SPI-NOR-Flash
- connect spi master IOs : rtl update for `apb_spi_master` 
    1. add `output [3:0] spi_master_oen` to control QSPI flash IO direction
    2. support extended-spi mode : use sdo0 as tx while `sdi1` as rx.

- download flash model of N25Q128A13E(Flash on Arty) from [Micron's website](https://www.micron.com/~/media/documents/products/sim-model/nor-flash/serial/bfm/n25q/n25q128a13e_3v_micronxip_vg12,-d-,tar.gz)

- modify `sw/apps/boot_code/boot_code.c`
    1. disable `check_spi_flash()` : N25Q128A13E has ID values of 0x20BA18
    2. enable QSPI by CMD=0x61, value=0x5F 
    3. set flash start address = 0x400000
    4. rewrite function `jump_and_start()` : the original function cause rtl
       simulation hang-up. From the deassembler output , it
       will get `jr a5` which is not good, the new function will get `jalr a5`.
       Don't know the root cause for now.

- build the new boot_code file: `rtl/boot_code.sv`
    ```shell
    cd fpga/common
    ./build_bootrom.sh
    ```

Take a look at the `sw/libs/Arduino_libs` subfolder for more information about
the status of the currently supported libraries.