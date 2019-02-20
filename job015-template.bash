#!/bin/bash
# A script to monitor gpu and cpu usage for arbitrary commands

# Define BASH functions for monitoring

outputcputime () {
   while true
   do
      getcputime | ts %.s >> cputime-$LOGDATE.log
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


# Setup environment and variables
module load motioncor2/2.1.10-cuda8
module load relion/3.0-uow-20190115
LOGDATE=`date +%s`
# Make an output folder for the job
mkdir Class2D/job015-$LOGDATE

# Export environment to file for determining running parameters
env > environment-$LOGDATE.log

# Insert commmand you want to monitor here
# ########################################
mpirun `which relion_refine_mpi` --o Class2D/job015-$LOGDATE/run --i Select/job014/particles.star --dont_combine_weights_via_disc --preread_images  --pool 30 --pad 2  --ctf  --iter 25 --tau2_fudge 2 --particle_diameter 200 --K 100 --flatten_solvent  --zero_mask  --oversampling 1 --psi_step 12 --offset_range 5 --offset_step 2 --norm --scale  --j 1 --gpu "" | sed 's/\r/\n/g' | ts %.s | tee job-$LOGDATE.log &
# ########################################
PID1=$!
#echo $PID1
#echo Running program PID: $PID1; 

# Find PID for relion
# Wait for Relion to start
sleep 3
until pids=$(pgrep relion)
do 
   sleep 1
   echo Waiting for Relion
done

RELIONPID=`pgrep relion |sed 's/ /,/g'`
printf "RelionPIDs=",$RELIONPID\\n
# Record gpu usage for node
nvidia-smi dmon -s umtp -i 0 -d 5 | ts %.s > nividia-$LOGDATE.log &
# Loop to record user and sys cpu times from proc
outputcputime &

#ps aux |grep $PID1
# Wait for initial process to finish then continue script
wait $PID1
# Kill all remaining processes after initial one is complete
pkill -P $$
echo Job Complete


