
## Process burn-in
library("EpiModelHPC")
library("EpiModelHIV")

system("scp scripts/burnin/*.burn.[Rs]* hyak:/gscratch/csde/sjenness/stia")

list.files("data/")
unlink("data/sim.n100.rda")

system("scp hyak:/gscratch/csde/sjenness/stia/data/*.rda data/")
load("data/sim.n100.rda")

df <- as.data.frame(sim)

par(mar = c(3,3,1,1), mgp = c(2,1,0))
plot(sim, y = "i.prev", ylim = c(0.1, 0.5), qnts = 0.5, mean.lwd = 1)
abline(h = 0.26, lty = 2)
text(x = 0, y = 0.28, round(mean(tail(df$i.prev, 100)), 3))

plot(sim, y = "ir100.gc", mean.smooth = FALSE, mean.lwd = 1)
abline(h = 4.2, lty = 2)
text(0, 1, round(mean(tail(df$ir100.gc, 520)), 2))

plot(sim, y = "ir100.ct", mean.smooth = FALSE, mean.lwd = 1)
abline(h = 6.6, lty = 2)
text(0, 1, round(mean(tail(df$ir100.ct, 520)), 2))
