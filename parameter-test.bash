#!/bin/bash
# Script to find what relion parameters are set
# $1 is the script name
if  grep -q no_parallel_disc_io $1
then
   echo no_parallel_disc_io=Yes
else  
   echo no_parallel_disc_io=No
fi

if grep -q dont_combine_weights_via_disc $1
then
   echo dont_combine_weights_via_disc=Yes
else  
   echo dont_combine_weights_via_disc=No
fi

if grep -q preread_images $1
then
   echo preread_images=Yes
else  
   echo preread_images=No
fi

if grep -q scratch_dir $1
then
   echo scratch_dir=Yes
else  
   echo scratch_dir=No
fi

