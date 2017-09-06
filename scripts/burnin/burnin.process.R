
## Process burn-in
library("EpiModelHIV")


# Simulation Analysis -----------------------------------------------------

list.files("data/")
# unlink("data/sim.n1000.rda")

system("scp hyak:/gscratch/csde/sjenness/prace/data/*.n*.rda data/")

load("data/sim.n1000.rda")
sim$control$nsims
sim$control$nsteps

df <- as.data.frame(sim)
names(df)

par(mar = c(3,3,1,1), mgp = c(2,1,0))

plot(sim, y = c("i.prev.W", "i.prev.B"), qnts = 0.5, ylim = c(0, 0.5),
     mean.smooth = FALSE, mean.lwd = 1, legend = FALSE)

b <- prop.test(197, 454, conf.level = 0.95, correct = FALSE)
w <- prop.test(46, 349, conf.level = 0.95, correct = FALSE)

# Involvement
ts <- 2500
points(x = c(ts, ts), y = c(b$estimate, w$estimate), pch = 20,
       col = c("firebrick", "steelblue"))
arrows(ts, b$conf.int[1], ts, b$conf.int[2], angle = 90,
       code = 3, length = 0.1, col = "firebrick")
arrows(ts, w$conf.int[1], ts, w$conf.int[2], angle = 90,
       code = 3, length = 0.1, col = "steelblue")

# NHBS
ts <- 2550
points(x = c(ts, ts), y = c(0.3604, 0.1483), pch = 20,
       col = c("firebrick", "steelblue"))
arrows(ts, 0.3412, ts, 0.3799, angle = 90,
       code = 3, length = 0.1, col = "firebrick")
arrows(ts, 0.1363, ts, 0.1610, angle = 90,
       code = 3, length = 0.1, col = "steelblue")


plot(sim, y = c("ir100.gc", "ir100.ct"), qnts = 0.5,
     mean.smooth = FALSE, mean.lwd = 1, legend = TRUE)


gc.b <- prop.test(17+8, 361+366.7, conf.level = 0.95, correct = FALSE)
gc.w <- prop.test(14+1, 466+473.8, conf.level = 0.95, correct = FALSE)

ct.b <- prop.test(34+30, 313.7+319.3, conf.level = 0.95, correct = FALSE)
ct.w <- prop.test(22+15, 402.3+407.3, conf.level = 0.95, correct = FALSE)

# std surveillance report
# ct = 5.9 rr
# ng = 9.6 rr

ct.sr <- ct.w$estimate * 100 * 5.9
gc.sr <- gc.w$estimate * 100 * 9.6


plot(sim, y = c("ir100.gc.W", "ir100.gc.B"), qnts = 0.5,
     mean.smooth = FALSE, mean.lwd = 1, legend = TRUE)
ts <- 2500
points(x = c(ts, ts), y = c(gc.b$estimate*100, gc.w$estimate*100), pch = 20,
       col = c("firebrick", "steelblue"))
arrows(ts, gc.b$conf.int[1]*100, ts, gc.b$conf.int[2]*100, angle = 90,
       code = 3, length = 0.1, col = "firebrick")
arrows(ts, gc.w$conf.int[1]*100, ts, gc.w$conf.int[2]*100, angle = 90,
       code = 3, length = 0.1, col = "steelblue")
points(x = ts, y = gc.sr, pch = 2, col = "firebrick", cex = 2)



plot(sim, y = c("ir100.ct.W", "ir100.ct.B"), qnts = 0.5,
     mean.smooth = FALSE, mean.lwd = 1, legend = TRUE)
ts <- 2500
points(x = c(ts, ts), y = c(ct.b$estimate*100, ct.w$estimate*100), pch = 20,
       col = c("firebrick", "steelblue"))
arrows(ts, ct.b$conf.int[1]*100, ts, ct.b$conf.int[2]*100, angle = 90,
       code = 3, length = 0.1, col = "firebrick")
arrows(ts, ct.w$conf.int[1]*100, ts, ct.w$conf.int[2]*100, angle = 90,
       code = 3, length = 0.1, col = "steelblue")
points(x = ts, y = ct.sr, pch = 2, col = "firebrick", cex = 2)


system("scp scripts/burnin/*.burn.* hyak:/gscratch/csde/sjenness/prace/")


# Simulation Selection ----------------------------------------------------

system("scp hyak:/gscratch/csde/sjenness/prace/data/*.n*.rda data/")

library(EpiModelHPC)

# Merge sim files
sim <- merge_simfiles(simno = 1000, indir = "data/", ftype = "max")

# Create function for selecting sim closest to target
mean_sim <- function(sim, targets) {

  nsims <- sim$control$nsims

  # Initialize distance vector
  dist <- rep(NA, nsims)

  # Obtain statistics and perform multivariable Euclidean distance calculation
  for (i in 1:nsims) {

      # Create data frame to draw statistics from
      df <- as.data.frame(x = sim, out = "vals", sim = i)

      # Create a vector of statistics
      calib <- c(mean(tail(df$i.prev.B, 52)), mean(tail(df$i.prev.W, 52)))

      wts <- c(1, 1)

      # Iteratively calculate distance
      dist[i] <- sqrt(sum(((calib - targets)*wts)^2))
  }

  # Which sim minimizes distance
  meansim <- which.min(dist)
  return(meansim)
}

b <- prop.test(197, 454, conf.level = 0.95, correct = FALSE)
w <- prop.test(46, 349, conf.level = 0.95, correct = FALSE)

selected.sim <- mean_sim(sim, targets = c(b$estimate, w$estimate))
selected.sim

# Save burn-in file for FU sims
sim <- get_sims(sim, sims = selected.sim)
tail(as.data.frame(sim)$i.prev.B)
tail(as.data.frame(sim)$i.prev.W)

c(b$estimate, w$estimate)

save(sim, file = "est/pracemod.burnin.rda")
system("scp est/pracemod.burnin.rda hyak:/gscratch/csde/sjenness/prace/est/")
