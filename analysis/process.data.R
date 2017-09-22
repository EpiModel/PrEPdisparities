
## Process STI PrEP Data

rm(list = ls())
library("EpiModelHIV")


# Table 1 data

system("scp hyak:/gscratch/csde/sjenness/prace/data/t1/sim.n213[0-1].rda data/t1")

(fn <- list.files("data/t1", pattern = "213[0-1]", full.names = TRUE))

# Truncate, reduce
for (i in fn) {
  load(i)
  sim <- truncate_sim(sim, at = 2600)
  vars.needed <- c("i.prev.W", "i.prev.B",
                   "num.W", "num.B",
                   "ir100.W", "ir100.B",
                   "incid.W", "incid.B",
                   "prepCurr.W", "prepCurr.B")
  i.vars <- which(names(sim$epi) %in% vars.needed)
  sim$epi <- sim$epi[i.vars]
  save(sim, file = i, compress = "xz")
  cat("\n", i)
}


# Figure 1 data

(fn <- list.files(".", pattern = "sim", full.names = TRUE))

# Truncate, reduce
for (i in fn) {
  load(i)
  sim <- truncate_sim(sim, at = 2600)
  vars.needed <- c("i.prev.W", "i.prev.B",
                   "num.W", "num.B",
                   "ir100.W", "ir100.B",
                   "incid.W", "incid.B",
                   "prepCurr.W", "prepCurr.B")
  i.vars <- which(names(sim$epi) %in% vars.needed)
  sim$epi <- sim$epi[i.vars]
  save(sim, file = i, compress = "xz")
  cat("\n", i)
}

system("scp hyak:/gscratch/csde/sjenness/prace/data/*.rda data/f1")

# Figure 3 data

(fn <- list.files(".", pattern = "sim", full.names = TRUE))

# Truncate, reduce
for (i in fn) {
  load(i)
  sim <- truncate_sim(sim, at = 2600)
  vars.needed <-   vars.needed <- c("i.prev.W", "i.prev.B",
                                    "num.W", "num.B",
                                    "ir100.W", "ir100.B",
                                    "incid.W", "incid.B",
                                    "prepCurr.W", "prepCurr.B")
  i.vars <- which(names(sim$epi) %in% vars.needed)
  sim$epi <- sim$epi[i.vars]
  save(sim, file = i, compress = "xz")
  cat("\n", i)
}

system("scp hyak:/gscratch/csde/sjenness/prace/data/*.rda data/f3")



