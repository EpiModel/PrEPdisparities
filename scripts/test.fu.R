
rm(list = ls())
suppressMessages(library("EpiModelHIV"))
devtools::load_all("~/Dropbox/Dev/EpiModelHIV/EpiModelHIV")

# Main Test Script ----------------------------------------------------

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

                   prep.aware.B = 0.50,
                   prep.aware.W = 0.50,
                   prep.access.B = 0.76,
                   prep.access.W = 0.95,
                   prep.rx.B = 0.63,
                   prep.rx.W = 0.73,
                   prep.adhr.dist.B = reallocate_pcp(reall = 0.51 - 0.784),
                   prep.adhr.dist.W = reallocate_pcp(reall = 0.51 - 0.784),
                   prep.class.hr = c(0.69, 0.19, 0.05),
                   prep.discont.rate.B = 1-(2^(-1/406)),
                   prep.discont.rate.W = 1-(2^(-1/1155)),

                   prep.tst.int = 90,
                   prep.risk.int = 182,
                   prep.risk.reassess.method = "none",

                   rcomp.prob = 0,
                   rcomp.adh.groups = 1:3,
                   rcomp.main.only = FALSE,
                   rcomp.discl.only = FALSE)

init <- init_msm(st)

control <- control_msm(simno = 1,
                       start = 2601,
                       nsteps = 2700,
                       nsims = 1,
                       ncores = 1,
                       initialize.FUN = reinit_msm,
                       verbose = TRUE)

load("est/pracemod.burnin.rda")
sim <- netsim(sim, param, init, control)

df <- as.data.frame(sim)



# Testing/Timing ------------------------------------------------------

debug(deaths_msm)
debug(prevalence_msm)

dat <- reinit_msm(sim, param, init, control, s = 1)

for (at in 2601:2700) {
  dat <- aging_msm(dat, at)
  dat <- deaths_msm(dat, at)
  dat <- births_msm(dat, at)
  dat <- test_msm(dat, at)
  dat <- tx_msm(dat, at)
  dat <- progress_msm(dat, at)
  dat <- vl_msm(dat, at)
  dat <- simnet_msm(dat, at)
  dat <- disclose_msm(dat, at)
  dat <- acts_msm(dat, at)
  dat <- condoms_msm(dat, at)
  dat <- position_msm(dat, at)
  dat <- prep_msm(dat, at)
  dat <- trans_msm(dat, at)
  dat <- sti_trans(dat, at)
  dat <- sti_recov(dat, at)
  dat <- sti_tx(dat, at)
  dat <- prevalence_msm(dat, at)
  cat(at, ".", sep = "")
}
