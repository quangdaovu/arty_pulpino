#!/usr/bin/bash 

SW='../../sw'
BUILD="${SW}/build"
RTL='../../rtl'
TARGET='boot_code'

# build 
make -C ${SW}/build/ ${TARGET}

# s19 to boot_code.sv
${SW}/utils/s19toboot.py ${BUILD}/apps/${TARGET}/${TARGET}.s19
diff ${TARGET}.sv $RTL/
cp ${TARGET}.sv $RTL/

# de-assembler
riscv32-unknown-elf-objdump ${BUILD}/apps/${TARGET}/${TARGET}.elf  -d  > ${TARGET}.asm
