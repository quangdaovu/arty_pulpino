#!/usr/bin/bash 

if [ $# != 1 ]; then
    echo "Usage:"
    echo "    $0 APPS"
    echo "APPS is a case name can be found in ../../sw/build/apps"
    exit 1
fi

simfile=../../sw/build/apps/$1/slm_files/spi_stim.txt

if [ ! -f $simfile ]; then
    echo "please run $1 simulation first:"
    echo "    cd ../../sw/build"
    echo "    make vcompile"
    echo "    make $1.vsimc"
    exit 1
fi

coefile=$1.coe

echo "; $1" >$coefile
echo "; inputfile : $simfile" >> $coefile
echo "; depth = 8192 " >> $coefile
echo "; width = 32" >> $coefile
echo "memory_initialization_radix = 16; " >> $coefile
echo "memory_initialization_vector =   " >> $coefile

sed -e 's/^.*_//g' $simfile | sed -e 's/$/,/g' >> $coefile

# add 0s 
echo "00000000" >> $coefile

linkfile=../ips/arty_mem_8192x32/xilinx_mem_8192x32.coe

if [ -L $linkfile ]; then
    rm -f $linkfile
fi

ln -s ../../common/$coefile $linkfile 

ll=`cat $simfile | wc -l`

echo "Input file       : $simfile" 
echo "Total lines      : $ll" 
echo "Output .coe file : $coefile" 
echo "Create link file : $linkfile" 
