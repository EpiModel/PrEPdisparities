#!/bin/bash

qsub -q batch -t 1-100 runsim.reestim.casl.abc.sh
qsub -q bf -t 101-200 runsim.reestim.casl.abc.sh
