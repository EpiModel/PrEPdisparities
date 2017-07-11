#!/bin/bash

# runs burnin model
qsub -q batch -t 1-2 -v SIMNO=1000,NJOBS=2 runsim.burn.sh
qsub -q batch -t 3-10 -v SIMNO=1000,NJOBS=2 runsim.burn.sh
