
library("methods")
suppressMessages(library("EpiModelHIV"))
suppressMessages(library("doParallel"))
suppressMessages(library("foreach"))
suppressMessages(library("EasyABC"))

f <- function(x) {

  set.seed(x[1])

  suppressMessages(library("EpiModelHIV"))

  load("est/nwstats.prace.rda")
  load("est/fit.prace.rda")

  param <- param_msm(nwstats = st,
                     race.method = 2,

                     base.ai.main.BB.rate = 0.22,
                     base.ai.main.BW.rate = 0.22,
                     base.ai.main.WW.rate = 0.22,
                     base.ai.pers.BB.rate = 0.14,
                     base.ai.pers.BW.rate = 0.14,
                     base.ai.pers.WW.rate = 0.14,
                     ai.scale.BB = x[2],
                     ai.scale.BW = x[3],
                     ai.scale.WW = x[4],

                     cond.eff = 0.95,
                     cond.fail.B = x[5],
                     cond.fail.W = x[6],

                     cond.main.BB.prob = 0.21,
                     cond.main.BW.prob = 0.21,
                     cond.main.WW.prob = 0.21,
                     cond.rr.BB = x[7],
                     cond.rr.BW = x[8],
                     cond.rr.WW = x[9],

                     gc.sympt.prob.tx.B = x[10],
                     gc.sympt.prob.tx.W = x[11],
                     ct.sympt.prob.tx.B = x[12],
                     ct.sympt.prob.tx.W = x[13],
                     gc.asympt.prob.tx.B = x[14],
                     gc.asympt.prob.tx.W = x[15],
                     ct.asympt.prob.tx.B = x[16],
                     ct.asympt.prob.tx.W = x[17],

                     sti.cond.fail.B = x[5],
                     sti.cond.fail.W = x[6])
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

  out <- c(i.prev.B = mean(dft$i.prev.B),
             i.prev.W = mean(dft$i.prev.W),
             ir100.gc.B = mean(dft$ir100.gc.B),
             ir100.gc.W = mean(dft$ir100.gc.W),
             ir100.ct.B = mean(dft$ir100.ct.B),
             ir100.ct.W = mean(dft$ir100.ct.W))
  # out <- c(i.prev.B = mean(dft$i.prev.B),
  #          i.prev.W = mean(dft$i.prev.W))

  return(out)
}

priors <- list(c("unif", 0.7, 1.3),
               c("unif", 0.7, 1.3),
               c("unif", 0.7, 1.3),
               c("unif", 0.3, 0.5),
               c("unif", 0.1, 0.3),
               c("unif", 0.75, 1.25),
               c("unif", 0.75, 1.25),
               c("unif", 0.75, 1.25),
               c("unif", 0.75, 0.95),
               c("unif", 0.75, 0.95),
               c("unif", 0.75, 0.95),
               c("unif", 0.75, 0.95),
               c("unif", 0.01, 0.20),
               c("unif", 0.01, 0.20),
               c("unif", 0.01, 0.20),
               c("unif", 0.01, 0.20))

gc.b.ts <- ((17+8)/(361+366.7))*100
gc.w.ts <- ((14+1)/(466+473.8))*100
ct.b.ts <- ((34+30)/(313.7+319.3))*100
ct.w.ts <- ((22+15)/(402.3+407.3))*100

target.stats <- c(0.434, 0.132, gc.b.ts, gc.w.ts, ct.b.ts, ct.w.ts)
# target.stats <- c(0.434, 0.132)

a <- ABC_sequential(method = "Lenormand",
                    model = f,
                    prior = priors,
                    nb_simul = 100,
                    summary_stat_target = target.stats,
                    p_acc_min = 0.1,
                    progress_bar = TRUE,
                    n_cluster = 16,
                    use_seed = TRUE,
                    verbose = FALSE)

fn <- paste0("data/abcsmc.sim4.rda")
save(a, file = fn)
