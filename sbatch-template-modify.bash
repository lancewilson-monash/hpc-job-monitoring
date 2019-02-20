#!/bin/bash
# Create copies of single node template
cp 1xm3g-multistep.sbatch 2xm3g-multistep.sbatch
cp 1xm3g-multistep.sbatch 3xm3g-multistep.sbatch
cp 1xm3g-multistep.sbatch 4xm3g-multistep.sbatch
# Modify templates to match nodes
sed -i 's/--ntasks=34/--ntasks=67/g' 2xm3g-multistep.sbatch
sed -i 's/--nodes=1/--nodes=2/g' 2xm3g-multistep.sbatch
sed -i 's/--ntasks=34/--ntasks=100/g' 3xm3g-multistep.sbatch
sed -i 's/--nodes=1/--nodes=3/g' 3xm3g-multistep.sbatch
sed -i 's/--ntasks=34/--ntasks=133/g' 4xm3g-multistep.sbatch
sed -i 's/--nodes=1/--nodes=4/g' 4xm3g-multistep.sbatch
