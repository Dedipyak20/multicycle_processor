#!/bin/bash -f
xv_path="/home/Xilinx_2017/Vivado/2017.1"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim tb_multicycle_behav -key {Behavioral:sim_1:Functional:tb_multicycle} -tclbatch tb_multicycle.tcl -log simulate.log
