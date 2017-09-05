#!/bin/bash

# runs burnin model
qsub -q batch -t 1-16 -v SIMNO=1000,NJOBS=16 runsim.burn.sh
