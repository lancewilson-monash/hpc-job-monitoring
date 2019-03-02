#!/bin/bash
# Script to extract Class3D job 

# Find Class3D jobs and extract command
JOB_FOLDER=$(find ./Class2D -type d -iname "job01*" |head -n1 |rev| cut --characters=1-6 |rev)
# Create a copy of the job template script and name it after the job
cp blank-template.bash $JOB_FOLDER-template.bash
# Extract command and insert into template
JOB_COMMAND=$(grep --color=never -i relion $(find ./Class2D -type d -iname "job01*" |head -n1)/note.txt)
sed -i "s~REPLACECOMMAND~mpirun $JOB_COMMAND \&~g" $JOB_FOLDER-template.bash
# Check job template script/run creates folders in the correct location
sed -i "s~REPLACEFOLDER~Class2D/$JOB_FOLDER~g" $JOB_FOLDER-template.bash
sed -i 's~/run ~-$LOGDATE/run ~g' $JOB_FOLDER-template.bash
# Remove gpu assignation if they exist
sed -i 's~--gpu "[0-9:]*"~--gpu ""~g' $JOB_FOLDER-template.bash
# Remove any thread settings
sed -i 's~--j [0-9].~--j 1 ~g' $JOB_FOLDER-template.bash
