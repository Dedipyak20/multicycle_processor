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
echo "xvlog -m64 --relax -prj tb_multicycle_vlog.prj"
ExecStep $xv_path/bin/xvlog -m64 --relax -prj tb_multicycle_vlog.prj 2>&1 | tee compile.log
