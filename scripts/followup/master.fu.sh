#!/bin/bash

qsub -q batch -t 1-10 -m n -v SIMNO=2000,NJOBS=10 runsim.fu.sh
