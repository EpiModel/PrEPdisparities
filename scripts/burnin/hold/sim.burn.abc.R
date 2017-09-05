
## Packages
library(methods)
suppressMessages(library(EpiModelHIV))
suppressMessages(library(doParallel))
suppressMessages(library(foreach))

## Environmental Arguments
simno <-  as.numeric(Sys.getenv("PBS_ARRAYID"))

f <- function() {

  load("est/nwstats.prace.rda")
  load("est/fit.prace.rda")
  load("p.rda")

  fstats <- list(
    ai.scale.BB = runif(1, a[1, 1], a[2, 1]),
    ai.scale.BW = runif(1, a[1, 2], a[2, 2]),
    ai.scale.WW = runif(1, a[1, 3], a[2, 3]),
    cond.fail.B = runif(1, a[1, 4], a[2, 4]),
    cond.fail.W = runif(1, a[1, 5], a[2, 5]),
    cond.rr.BB = runif(1, a[1, 6], a[2, 6]),
    cond.rr.BW = runif(1, a[1, 7], a[2, 7]),
    cond.rr.WW = runif(1, a[1, 8], a[2, 8]),
    gc.sympt.prob.tx.B = runif(1, a[1, 9], a[2, 9]),
    gc.sympt.prob.tx.W = runif(1, a[1, 10], a[2, 10]),
    ct.sympt.prob.tx.B = runif(1, a[1, 11], a[2, 11]),
    ct.sympt.prob.tx.W = runif(1, a[1, 12], a[2, 12]),
    gc.asympt.prob.tx.B = runif(1, a[1, 13], a[2, 13]),
    gc.asympt.prob.tx.W = runif(1, a[1, 14], a[2, 14]),
    ct.asympt.prob.tx.B = runif(1, a[1, 15], a[2, 15]),
    ct.asympt.prob.tx.W = runif(1, a[1, 16], a[2, 16]),
    sti.cond.fail.B = runif(1, a[1, 17], a[2, 17]),
    sti.cond.fail.W = runif(1, a[1, 18], a[2, 18])
  )

  param <- param_msm(nwstats = st,
                     race.method = 2,

                     base.ai.main.BB.rate = 0.22,
                     base.ai.main.BW.rate = 0.22,
                     base.ai.main.WW.rate = 0.22,
                     base.ai.pers.BB.rate = 0.14,
                     base.ai.pers.BW.rate = 0.14,
                     base.ai.pers.WW.rate = 0.14,
                     ai.scale.BB = fstats$ai.scale.BB,
                     ai.scale.BW = fstats$ai.scale.BW,
                     ai.scale.WW = fstats$ai.scale.WW,

                     cond.eff = 0.95,
                     cond.fail.B = fstats$cond.fail.B,
                     cond.fail.W = fstats$cond.fail.W,

                     cond.main.BB.prob = 0.21,
                     cond.main.BW.prob = 0.21,
                     cond.main.WW.prob = 0.21,
                     cond.rr.BB = fstats$cond.rr.BB,
                     cond.rr.BW = fstats$cond.rr.BW,
                     cond.rr.WW = fstats$cond.rr.WW,

                     gc.sympt.prob.tx.B = fstats$gc.sympt.prob.tx.B,
                     gc.sympt.prob.tx.W = fstats$gc.sympt.prob.tx.W,
                     ct.sympt.prob.tx.B = fstats$ct.sympt.prob.tx.B,
                     ct.sympt.prob.tx.W = fstats$ct.sympt.prob.tx.W,
                     gc.asympt.prob.tx.B = fstats$gc.asympt.prob.tx.B,
                     gc.asympt.prob.tx.W = fstats$gc.asympt.prob.tx.W,
                     ct.asympt.prob.tx.B = fstats$ct.asympt.prob.tx.B,
                     ct.asympt.prob.tx.W = fstats$ct.asympt.prob.tx.W,

                     sti.cond.fail.B = fstats$sti.cond.fail.B,
                     sti.cond.fail.W = fstats$sti.cond.fail.W)
  init <- init_msm(nwstats = st,
                   prev.B = 0.434,
                   prev.W = 0.132)
  control <- control_msm(simno = 1,
                         nsteps = 52 * 50,
                         nsims = 1, ncores = 1,
                         verbose = FALSE)


  sim <- netsim(est, param, init, control)

  df <- as.data.frame(sim)
  dft <- tail(df, 100)
  stats <- list(i.prev.B = mean(dft$i.prev.B),
                i.prev.W = mean(dft$i.prev.W),
                ir100.gc.B = mean(dft$ir100.gc.B),
                ir100.gc.W = mean(dft$ir100.gc.W),
                ir100.ct.B = mean(dft$ir100.ct.B),
                ir100.ct.W = mean(dft$ir100.ct.W))

  out <- c(fstats, stats)

  return(out)
}

# Run parallel on each node
registerDoParallel(16)
nsims <- 16
sout <- foreach(s = 1:nsims) %dopar% {
  f()
}

sim <- as.data.frame(do.call("rbind", sout))
save(sim, file = paste0("data/sim.", simno, ".rda"))
