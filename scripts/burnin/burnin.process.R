
## Process burn-in
library("EpiModelHIV")

list.files("data/")
# unlink("data/sim.n1000.rda")

load("data/sim.n1000.rda")
sim$control$nsims

df <- as.data.frame(sim)
names(df)

par(mar = c(3,3,1,1), mgp = c(2,1,0))

plot(sim, y = c("i.prev.W", "i.prev.B"), qnts = 0.5,
     mean.smooth = FALSE, mean.lwd = 1, legend = TRUE)

plot(sim, y = c("ir100.gc", "ir100.ct"), qnts = 0.5,
     mean.smooth = FALSE, mean.lwd = 1, legend = TRUE)

plot(sim, y = c("prev.gc", "prev.ct"), qnts = 0.5,
     mean.smooth = FALSE, mean.lwd = 1, legend = TRUE)
