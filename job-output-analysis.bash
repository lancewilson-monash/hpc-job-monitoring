#!/bin/bash
# Script to take output files and extract information
# Parameter 1 = Slurm JOBID
INITIALDIR=`pwd`
JOBID=$1
ANALYSISFOLDER=loganalysis/$JOBID
# Make a single directory for all files for a job
mkdir -p $ANALYSISFOLDER

# Move job logs to folder
mv $JOBID.* $ANALYSISFOLDER/ 
# Move performance logs to folder


# Find environment logs for slurm JOBID and move all files
grep -l "JOBID=$JOBID" *.log
FILEDATES=`grep -l "JOBID=$JOBID" *.log | cut -d'-' -f2 | cut -d'.' -f1`
for DATE in $FILEDATES; do mv -v *-$DATE.log $ANALYSISFOLDER/ ;done

# Filter log files to remove unwanted data
cd $ANALYSISFOLDER
for DATE in $FILEDATES; do cat nividia-$DATE.log | grep -v 'gpu\|Idx' > nividia-$DATE-filtered.log; done

# Change back to original folder
cd "$INITIALDIR"
