#!/bin/bash
# Script to extract Class3D job 

# Find Class3D jobs and extract command
JOB_FOLDER=$(find ./Class3D -type d -iname "job*" |head -n1 |rev| cut --characters=1-6 |rev)
# Create a copy of the job template script and name it after the job
cp blank-template.bash $JOB_FOLDER-template.bash
# Extract command and insert into template
JOB_COMMAND=$(grep --color=never -i relion $(find ./Class3D -type d -iname "job*" |head -n1)/note.txt)
sed -i "s~REPLACECOMMAND~$JOB_COMMAND~g" $JOB_FOLDER-template.bash
# Check job template scrip/runt creates folders in the correct location
sed -i "s~REPLACEFOLDER~Class3D/$JOB_FOLDER~g" $JOB_FOLDER-template.bash
sed -i 's~/run~-$LOGDATE/run~g' $JOB_FOLDER-template.bash
# Remove gpu assignation if they exist
sed -i 's~--gpu "[0-9:]*"~--gpu ""~g' $JOB_FOLDER-template.bash
# Remove any thread settings
sed -i 's~--j [0-9].~--j 1~g' $JOB_FOLDER-template.bash
