
# devtools::install_github("statnet/tergm")
library(EpiModelHIV)
sessionInfo()

# post-processing of data
fn <- list.files("scripts/burnin/data/", pattern = "sim", full.names = TRUE)

load(fn[1])
for (j in 1:length(sim)) {
  sim[[j]] <- do.call("c", sim[[j]])
}
fsim <- sim
for (i in 2:length(fn)) {
  load(fn[i])
  for (j in 1:length(sim)) {
    sim[[j]] <- do.call("c", sim[[j]])
  }
  fsim <- rbind(fsim, sim)
}
dim(fsim)



# rejection algorithm, weighted threshold
rejection <- function(sim,
                      target.stat,
                      threshold) {

  p <- sim[, 1:18]
  dat <- sim[, 19:24]

  diffs <- list()
  for (jj in 1:length(target.stat)) {
    diffs[[jj]] <- abs(dat[, jj] - target.stat[jj])
  }
  diffs <- as.data.frame(diffs)
  names(diffs) <- paste0("v", 1:length(target.stats))

  rdiff <- rowSums(diffs)
  cutoff <- quantile(rdiff, threshold)

  in.threshold <- which(rdiff <= cutoff)

  post <- sim[in.threshold, ]
  out <- list()
  out$param <- post[, 1:18]
  out$stats <- post[, 19:24]
  return(out)
}

post <- rejection(fsim, target.stats, threshold = 0.01)
str(post)

# Accepted adjusted coefficients
selected.param <- colMeans(post$param)
selected.stats <- colMeans(post$stats)

cbind(target.stats, selected.stats)

post$param
a <- sapply(post$param, range)
