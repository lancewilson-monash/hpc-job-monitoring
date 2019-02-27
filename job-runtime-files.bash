#!/bin/bash
# Script to take a directory and find how long it took to create
# First file 
# ls --full-time -t |tail -n1
# First file 
FIRST=$(date "+%s" -d "$( ls --full-time -t $1 |tail -n1 |awk '{print $6,$7,$8}' )")
#echo $FIRST
# Last file 
# ls --full-time -rt |tail -n1
LAST=$(date "+%s" -d "$( ls --full-time -rt $1 |tail -n1 |awk '{print $6,$7,$8}' )")
#echo $LAST
JOBTIME=$(expr $LAST - $FIRST)
JOBNAME=$( echo $1 | rev | cut -d"/" -f1 |rev) 
JOBTYPE=$( echo $1 | rev | cut -d"/" -f2 |rev) 
echo "$JOBNAME,$JOBTYPE,$JOBTIME"
#echo "$JOBNAME Total Job Time = $JOBTIME"
#echo $JOBTIME | awk '{printf("%d:%02d:%02d:%02d\n",($1/60/60/24),($1/60/60%24),($1/60%60),($1%60))}' 
