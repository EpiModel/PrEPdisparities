
## Packages
library("methods")
suppressMessages(library("EpiModelHIV"))

## Environmental Arguments
simno <- Sys.getenv("SIMNO")
jobno <- Sys.getenv("PBS_ARRAYID")
fsimno <- paste(simno, jobno, sep = ".")
njobs <- as.numeric(Sys.getenv("NJOBS"))

## Parameters
load("est/nwstats.prace.rda")

param <- param_msm(nwstats = st,
                   race.method = 2,
                   rgc.tprob = 0.458,
                   ugc.tprob = 0.370,
                   rct.tprob = 0.221,
                   uct.tprob = 0.205,
                   rct.asympt.int = 254.1,
                   uct.asympt.int = 254.1,
                   rgc.asympt.int = 245.8,
                   ugc.asympt.int = 245.8,
                   hiv.rgc.rr = 2.78,
                   hiv.ugc.rr = 1.73,
                   hiv.rct.rr = 2.78,
                   hiv.uct.rr = 1.73,
                   hiv.dual.rr = 0.2)
init <- init_msm(nwstats = st,
                 prev.B = 0.46,
                 prev.W = 0.15)
control <- control_msm(simno = fsimno,
                       nsteps = 52 * 50,
                       nsims = 16, ncores = 16,
                       verbose = FALSE)

## Simulation
netsim_hpc("est/fit.prace.rda", param, init, control, verbose = FALSE)
process_simfiles(simno = simno, min.n = njobs, compress = TRUE,
                 outdir = "data/", verbose = FALSE)
