
## Test PrEP adherence sim

sim <- function(med.dur = 365, cov = 0.25) {
  do.rate <- 1-(2^(-1/med.dur))

  pstat <- rbinom(1000, 1, cov)
  nprep <- sum(pstat == 1)

  nsteps <- 365 * 10

  for (i in 2:nsteps) {

    elig.stop <- which(pstat == 1)
    vec.stop <- rbinom(length(elig.stop), 1, do.rate)
    ids.stop <- elig.stop[which(vec.stop == 1)]
    if (length(ids.stop) > 0) {
      pstat[ids.stop] <- 0
    }
    nprep[i] <- sum(pstat == 1)
  }
  nprep <- nprep/(1000*cov)
  return(nprep)
}

med.dur <- 365
cov <- 0.40
sims <- replicate(100, sim(med.dur = med.dur, cov = cov))

plot(nprep, type = "n", ylim = c(0, 1))
for (j in 1:ncol(sims)) {
  lines(sims[, j], lwd = 0.3, type = "s", col = adjustcolor("seagreen", alpha.f = 0.2))
}
abline(h = 0.5, v = med.dur, lty = 2)
text(1, 0.1, round(rowMeans(sims)[med.dur], 3))
