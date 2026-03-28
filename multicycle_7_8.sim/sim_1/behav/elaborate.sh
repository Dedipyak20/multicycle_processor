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
ExecStep $xv_path/bin/xelab -wto 33398569f78649cf90a6346990c7a48d -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot tb_multicycle_behav xil_defaultlib.tb_multicycle xil_defaultlib.glbl -log elaborate.log
