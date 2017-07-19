#!/bin/bash

# runs burnin model
qsub -q batch -t 1-13 -v SIMNO=1000,NJOBS=13 runsim.burn.sh
