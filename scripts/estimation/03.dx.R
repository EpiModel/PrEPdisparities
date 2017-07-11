
# PrEP Race Diagnostics

suppressMessages(library("EpiModelHIV"))
rm(list = ls())

load("est/fit.prace.rda")

# Main model diagnostics

fit.m <- est[[1]]
dx.m <- netdx(fit.m, nsims = 10, nsteps = 500, dynamic = TRUE,
              set.control.ergm = control.simulate.ergm(MCMC.burnin = 1e6))

print(dx.m)
plot(dx.m, qnts.alpha = 0.9)


# Casual model diagnostics

fit.c <- est[[2]]
dx.c <- netdx(fit.c, nsims = 10, nsteps = 500, dynamic = TRUE,
              set.control.ergm = control.simulate.ergm(MCMC.burnin = 1e6))

print(dx.c)
plot(dx.c, qnts.alpha = 0.9)


# One-off model diagnostics

fit.i <- est[[3]]
dx.i <- netdx(fit.i, nsims = 1000, dynamic = FALSE)

print(dx.i)
plot(dx.i)
