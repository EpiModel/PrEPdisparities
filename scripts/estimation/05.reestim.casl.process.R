
# post-processing of data
fn <- list.files("est/", pattern = "sim", full.names = TRUE)

load(fn[1])
fsim <- sim
for (i in 2:length(fn)) {
  load(fn[i])
  fsim <- rbind(fsim, sim)
}
dim(fsim)

# rejection algorithm, weighted threshold
rejection <- function(sim,
                      target.stat = c(2022.5, 890, 950, 1185),
                      threshold = 0.05) {

  diff1 <- abs(sim$out1 - target.stat[1])
  diff2 <- abs(sim$out2 - target.stat[2])
  diff3 <- abs(sim$out3 - target.stat[3])
  diff4 <- abs(sim$out4 - target.stat[4])

  diff <- (3.5*diff1) + diff2 + (2*diff3) + diff4
  cutoff <- quantile(diff, threshold)

  in.threshold <- which(diff <= cutoff)

  post <- sim[in.threshold, ]
  return(post)
}

post <- rejection(fsim, threshold = 0.001)
post

# Accepted adjusted coefficients
colMeans(post)[5:8]
selection <- colMeans(post)[1:4]
selection # <- c(-13.2053497653944, -0.346004865323799, 1.04989624409589, -0.456503943369997)

# Test it
est2 <- est[[2]]
est2$coef.form[1:4] <- selection

dx <- netdx(est2, nsteps = 300, nsims = 20, ncores = 4, dynamic = TRUE,
            set.control.ergm = control.simulate.ergm(MCMC.burnin = 2e6))
dx
plot(dx)

# Write out to coefficients
load("est/fit.rda")
est[[2]]$coef.form[1:4] <- selection
save(est, file = "est/fit.rda")
