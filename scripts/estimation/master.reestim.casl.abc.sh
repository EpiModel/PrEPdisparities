#!/bin/bash

qsub -q batch -t 1 runsim.reestim.casl.abc.sh
qsub -q batch -t 2-50 runsim.reestim.casl.abc.sh
qsub -q bf -t 51-200 runsim.reestim.casl.abc.sh
