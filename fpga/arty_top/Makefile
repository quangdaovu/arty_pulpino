PROJECT:=arty_top

all: synth

synth:
	vivado -mode batch -source tcl/run.tcl
	cp arty_top.runs/impl_1/arty_top.bit arty_top.bit

#impl:
#	rm -rf .Xil
#	vivado -mode batch -source tcl/impl.tcl
#	cp arty_top.runs/impl_1/arty_top.bit .
#	cp arty_top.runs/impl_1/*.dcp .

gui:
	vivado -mode gui -source tcl/run.tcl &

#gui-impl:
#	vivado -mode gui -source tcl/impl.tcl &

continue:
	vivado -mode gui arty_top.xpr &

sim:
	vivado -mode gui -source tcl/sim_behav.tcl &

#clean-impl:
#	rm -rf arty_top*

clean:
	rm -rf ${PROJECT}.hw
	rm -rf ${PROJECT}.xpr
	rm -rf ${PROJECT}.data
	rm -rf ${PROJECT}.runs
	rm -rf ${PROJECT}.srcs
	rm -rf ${PROJECT}.sim
	rm -rf ${PROJECT}.sdk
	rm -rf ${PROJECT}.cache
	rm -rf ${PROJECT}.ioplanning
	rm -rf ${PROJECT}.hwdef
	rm -rf *.log
	rm -rf ulpsoc.txt
	rm -rf ulpcluster.txt
	rm -rf component.xml
	rm -rf vivado*
	rm -rf xgui
	rm -rf .Xil
	rm -rf ps_clock*
	rm -rf arty_top*
	rm -rf arty_top.edf
	rm -rf *.edn

