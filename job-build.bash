#!/bin/bash
# Script to build the bash scripts for testing different job parameters
# Parameter 1 = filename of base job template 

# Extract job number
JOB_NUMBER=$(echo $1 | cut -c 1-6)

# Copy original template using the $1 
cp $1 $JOB_NUMBER-preread-off.bash
cp $1 $JOB_NUMBER-paralledisc-off.bash
cp $1 $JOB_NUMBER-mpicombine-off.bash
cp $1 $JOB_NUMBER-localscratch-on.bash

# Remove preread flag
sed -i 's/--preread_images//g' $JOB_NUMBER-preread-off.bash
# Add no parallel disk reads
sed -i 's/--scale/--scale --no_parallel_disc_io/g' $JOB_NUMBER-paralledisc-off.bash
# Remove the mpi combine steps
sed -i 's/--dont_combine_weights_via_disc//g' $JOB_NUMBER-mpicombine-off.bash
# Add local scratch dir
sed -i 's/--scale/--scale --scratch_dir \/mnt\/local_scratch/g' $JOB_NUMBER-localscratch-on.bash

# Make a new copy of the sbatch template
cp 1xm3g-template.sbatch 1xm3g-$JOB_NUMBER-multistep.sbatch
# Put script names into template
echo ./$1 >> 1xm3g-$JOB_NUMBER-multistep.sbatch
echo ./$JOB_NUMBER-preread-off.bash >> 1xm3g-$JOB_NUMBER-multistep.sbatch
echo ./$JOB_NUMBER-paralledisc-off.bash >> 1xm3g-$JOB_NUMBER-multistep.sbatch
echo ./$JOB_NUMBER-mpicombine-off.bash >> 1xm3g-$JOB_NUMBER-multistep.sbatch
echo ./$JOB_NUMBER-localscratch-on.bash >> 1xm3g-$JOB_NUMBER-multistep.sbatch


# Create copies of single node template
cp 1xm3g-$JOB_NUMBER-multistep.sbatch 2xm3g-$JOB_NUMBER-multistep.sbatch
cp 1xm3g-$JOB_NUMBER-multistep.sbatch 3xm3g-$JOB_NUMBER-multistep.sbatch
cp 1xm3g-$JOB_NUMBER-multistep.sbatch 4xm3g-$JOB_NUMBER-multistep.sbatch
# Modify templates to match nodes
sed -i 's/--ntasks=34/--ntasks=67/g' 2xm3g-$JOB_NUMBER-multistep.sbatch
sed -i 's/--nodes=1/--nodes=2/g' 2xm3g-$JOB_NUMBER-multistep.sbatch
sed -i 's/--ntasks=34/--ntasks=100/g' 3xm3g-$JOB_NUMBER-multistep.sbatch
sed -i 's/--nodes=1/--nodes=3/g' 3xm3g-$JOB_NUMBER-multistep.sbatch
sed -i 's/--ntasks=34/--ntasks=133/g' 4xm3g-$JOB_NUMBER-multistep.sbatch
sed -i 's/--nodes=1/--nodes=4/g' 4xm3g-$JOB_NUMBER-multistep.sbatch 

# Make a sbatch submission script
echo '#!/bin/bash' > $JOB_NUMBER-submission.bash
echo sbatch 1xm3g-$JOB_NUMBER-multistep.sbatch >> $JOB_NUMBER-submission.bash
echo sbatch 2xm3g-$JOB_NUMBER-multistep.sbatch >> $JOB_NUMBER-submission.bash
echo sbatch 3xm3g-$JOB_NUMBER-multistep.sbatch >> $JOB_NUMBER-submission.bash
echo sbatch 4xm3g-$JOB_NUMBER-multistep.sbatch >> $JOB_NUMBER-submission.bash
chmod +x $JOB_NUMBER-submission.bash



