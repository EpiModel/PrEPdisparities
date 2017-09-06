
## Test PrEP adherence sim

sim <- function() {
  med.dur <- 365
  do.rate <- 1-(2^(-1/med.dur))

  pstat <- rbinom(1000, 1, 0.25)
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
  return(nprep)
}

sims <- replicate(100, sim())

sims
plot(nprep, type = "n", ylim = c(0, 300))
for (j in 1:ncol(sims)) {
  lines(sims[, j], lwd = 0.2, type = "s")
}
abline(h = 125, v = 365)

rowMeans(sims)[365]/250
