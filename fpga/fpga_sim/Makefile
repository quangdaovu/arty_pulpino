PROJECT:=arty_top

new:
	vivado -mode gui -source tcl/run.tcl &

open:
	vivado -mode gui arty_top.xpr &

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
	rm -rf ${PROJECT}.ip_user_files
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

