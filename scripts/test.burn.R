
rm(list = ls())
suppressMessages(library("EpiModelHIV"))
devtools::load_all("~/Dropbox/Dev/EpiModelHIV/EpiModelHIV")

# Main Test Script ----------------------------------------------------

load("est/nwstats.prace.rda")

param <- param_msm(nwstats = st,
                   race.method = 2,
                   rgc.tprob = 0.428,
                   ugc.tprob = 0.350,
                   rct.tprob = 0.231,
                   uct.tprob = 0.205,
                   rct.asympt.int = 254.1,
                   uct.asympt.int = 254.1,
                   rgc.asympt.int = 245.8,
                   ugc.asympt.int = 245.8,
                   hiv.rgc.rr = 2.78,
                   hiv.ugc.rr = 1.73,
                   hiv.rct.rr = 2.78,
                   hiv.uct.rr = 1.73,
                   hiv.dual.rr = 0.2,
                   cond.eff = 0.95,
                   cond.fail.B = 0.35,
                   cond.fail.W = 0.15)
init <- init_msm(nwstats = st,
                 prev.B = 0.46,
                 prev.W = 0.15)
control <- control_msm(simno = 1,
                       nsteps = 52 * 60,
                       nsims = 1,
                       ncores = 1)

load("est/fit.prace.rda")
sim <- netsim(est, param, init, control)



# Testing/Timing ------------------------------------------------------


dat <- initialize_msm(est, param, init, control, s = 1)

for (at in 2:520) {
  dat <- aging_msm(dat, at)
  dat <- deaths_msm(dat, at)
  dat <- births_msm(dat, at)
  dat <- test_msm(dat, at)
  dat <- tx_msm(dat, at)
  dat <- prep_msm(dat, at)
  dat <- progress_msm(dat, at)
  dat <- vl_msm(dat, at)
  dat <- simnet_msm(dat, at)
  dat <- disclose_msm(dat, at)
  dat <- acts_msm(dat, at)
  dat <- condoms_msm(dat, at)
  dat <- position_msm(dat, at)
  dat <- trans_msm(dat, at)
  dat <- sti_trans(dat, at)
  dat <- sti_recov(dat, at)
  dat <- sti_tx(dat, at)
  dat <- prevalence_msm(dat, at)
  cat(at, ".", sep = "")
}
