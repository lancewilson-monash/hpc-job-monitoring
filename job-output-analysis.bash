#!/bin/bash
# Script to take output files and extract information
# Parameter 1 = Slurm JOBID

# Find environment logs for slurm JOBID
grep -l "JOBID=$1" *.log

