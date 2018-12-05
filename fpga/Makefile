#all: ips pulpino pulpemu sw
all: ips pulpino arty_top

.PHONY: ips
ips: clk mem

.PHONY: clk
clk: ips/arty_mmcm/ip/arty_mmcm.dcp

ips/arty_mmcm/ip/arty_mmcm.dcp:
	make -C ips/arty_mmcm/ clean all

.PHONY: mem
mem: ips/arty_mem_8192x32/ip/xilinx_mem_8192x32.dcp ips/arty_dmem_8192x32/ip/xilinx_dmem_8192x32.dcp

ips/arty_mem_8192x32/ip/xilinx_mem_8192x32.dcp:
	make -C ips/arty_mem_8192x32/ clean all

ips/arty_dmem_8192x32/ip/xilinx_dmem_8192x32.dcp:
	make -C ips/arty_dmem_8192x32/ clean all

.PHONY: pulpino
pulpino: arty_pulpino/pulpino.edf

arty_pulpino/pulpino.edf:
	make -C arty_pulpino clean all

.PHONY: arty_top 
arty_top: arty_top/arty_top.bit

arty_top/arty_top.bit:
	make -C arty_top clean all

#.PHONY: sw
#sw:
#	make -C sw all

.PHONY: veryclean
veryclean: clean
	make -C fpga_sim clean
	rm -f common/boot_code.asm
	rm -f common/boot_code.cde
	rm -f common/boot_code.sv

.PHONY: clean
clean:
	make -C ips/arty_mmcm/ clean
	make -C ips/arty_mem_8192x32/ clean
	make -C ips/arty_dmem_8192x32/ clean
	make -C ips/xilinx_fp_fma/ clean
	make -C arty_pulpino clean
	make -C arty_top clean
