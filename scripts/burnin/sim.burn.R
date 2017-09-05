
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
                   rgc.tprob = 0.428,
                   ugc.tprob = 0.350,
                   rct.tprob = 0.231,
                   uct.tprob = 0.205,
                   rgc.asympt.int = 205.8, # -10
                   ugc.asympt.int = 205.8, # -10
                   rct.asympt.int = 265.1, # -10
                   uct.asympt.int = 265.1, # -10
                   hiv.rgc.rr = 2.78,
                   hiv.ugc.rr = 1.73,
                   hiv.rct.rr = 2.78,
                   hiv.uct.rr = 1.73,
                   hiv.dual.rr = 0.2,

                   base.ai.main.BB.rate = 0.22,
                   base.ai.main.BW.rate = 0.22,
                   base.ai.main.WW.rate = 0.22,
                   base.ai.pers.BB.rate = 0.14,
                   base.ai.pers.BW.rate = 0.14,
                   base.ai.pers.WW.rate = 0.14,
                   ai.scale.BB = 1.31, ## 0.84 - 1.19
                   ai.scale.BW = 1, ## 0.65 - 1.54
                   ai.scale.WW = 0.77, ## 0.77 - 1.29

                   cond.eff = 0.95,
                   cond.fail.B = 0.39, ## 0.3 - 0.5
                   cond.fail.W = 0.21, ## 0.1 - 0.3

                   cond.main.BB.prob = 0.21,
                   cond.main.BW.prob = 0.21,
                   cond.main.WW.prob = 0.21,
                   cond.rr.BB = 0.71, ## 0.71 - 1.34
                   cond.rr.BW = 1, ## 0.4 - 2.4
                   cond.rr.WW = 1.6, ## 0.4 - 1.6

                   gc.sympt.prob.tx.B = 0.86, # 0.80 - 0.95
                   gc.sympt.prob.tx.W = 0.96, # 0.80 - 0.95
                   ct.sympt.prob.tx.B = 0.72, # 0.70 - 0.90
                   ct.sympt.prob.tx.W = 0.85, # 0.70 - 0.90
                   gc.asympt.prob.tx.B = 0.10, # 0.01 - 0.25
                   gc.asympt.prob.tx.W = 0.19, # 0.01 - 0.25
                   ct.asympt.prob.tx.B = 0.05, # 0.01 - 0.25
                   ct.asympt.prob.tx.W = 0.10, # 0.01 - 0.25

                   sti.cond.fail.B = 0.39, ## 0.3 - 0.5
                   sti.cond.fail.W = 0.21) ## 0.1 - 0.3
init <- init_msm(nwstats = st,
                 prev.B = 0.434,
                 prev.W = 0.132)
control <- control_msm(simno = fsimno,
                       nsteps = 52 * 50,
                       nsims = 16, ncores = 16,
                       verbose = FALSE)

## Simulation
# netsim_hpc("est/fit.prace.rda", param, init, control, verbose = FALSE)
# process_simfiles(simno = simno, min.n = njobs, compress = TRUE,
#                  outdir = "data/", verbose = FALSE)

netsim_hpc("est/fit.prace.rda", param, init, control, save.max = TRUE, verbose = FALSE)
