#!/bin/bash

# runs burnin model
qsub -q batch -t 1-5 -v SIMNO=1000,NJOBS=5 runsim.burn.sh
