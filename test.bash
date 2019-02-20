#!/bin/bash
LOGDATE=`date +%s`

outputcputime () {
   while true
   do
      getcputime | ts %.s |tee cputime-$LOGDATE.log
      sleep 1
   done
}

getcputime () {
    local proc="relion"
    local clk_tck=$(getconf CLK_TCK)
    local usercputime=0
    local syscputime=0
    local pids=$(pgrep $proc)
    for pid in $pids;
    do
        local stats=$(cat "/proc/$pid/stat")
        local statarr=($stats)
        local utime=${statarr[13]}
        local stime=${statarr[14]}
        usercputime=$(bc <<< "scale=3; $usercputime + $utime / $clk_tck")
        syscputime=$(bc <<< "scale=3; $syscputime + $stime / $clk_tck")
    done
    echo $usercputime $syscputime
}

outputcputime 
echo This comes after the output
