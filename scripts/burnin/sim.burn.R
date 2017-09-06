
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
                   rgc.asympt.int = 205.8,
                   ugc.asympt.int = 205.8,
                   rct.asympt.int = 265.1,
                   uct.asympt.int = 265.1,
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
                   ai.scale.BB = 1.31,
                   ai.scale.BW = 1,
                   ai.scale.WW = 0.77,

                   cond.eff = 0.95,
                   cond.fail.B = 0.39,
                   cond.fail.W = 0.21,

                   cond.main.BB.prob = 0.21,
                   cond.main.BW.prob = 0.21,
                   cond.main.WW.prob = 0.21,
                   cond.rr.BB = 0.71,
                   cond.rr.BW = 1,
                   cond.rr.WW = 1.6,

                   gc.sympt.prob.tx.B = 0.86,
                   gc.sympt.prob.tx.W = 0.96,
                   ct.sympt.prob.tx.B = 0.72,
                   ct.sympt.prob.tx.W = 0.85,
                   gc.asympt.prob.tx.B = 0.10,
                   gc.asympt.prob.tx.W = 0.19,
                   ct.asympt.prob.tx.B = 0.05,
                   ct.asympt.prob.tx.W = 0.10,

                   sti.cond.fail.B = 0.39,
                   sti.cond.fail.W = 0.21,

                   prep.start = 2601,

                   prep.aware.B = 0.5,
                   prep.aware.W = 0.5,
                   prep.access.B = 0.5,
                   prep.access.W = 0.5,
                   prep.rx.B = 0.5,
                   prep.rx.W = 0.5,
                   prep.adhr.dist.B = c(0.089, 0.127, 0.784),
                   prep.adhr.dist.W = c(0.089, 0.127, 0.784),
                   prep.class.hr = c(0.69, 0.19, 0.05),
                   prep.discont.rate.B = 1-(2^(-1/365)),
                   prep.discont.rate.W = 1-(2^(-1/365)),

                   prep.tst.int = 90,
                   prep.risk.int = 182,
                   prep.risk.reassess.method = "inst", # inst, year

                   rcomp.prob = 0,
                   rcomp.adh.groups = 1:3,
                   rcomp.main.only = FALSE,
                   rcomp.discl.only = FALSE)

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
