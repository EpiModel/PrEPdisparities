#!/bin/bash

qsub -q batch -t 1-10 -m n -v SIMNO=1999,NJOBS=10,RXB=0,RXW=0 runsim.fu.sh
qsub -q batch -t 1-10 -m n -v SIMNO=2000,NJOBS=10,RXB=0.63,RXW=0.73 runsim.fu.sh
