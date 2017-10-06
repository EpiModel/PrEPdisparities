
## PrEP Race Figure 2

rm(list = ls())
library("EpiModelHIV")
library("EpiModelHPC")
library("dplyr")
source("analysis/fx.R")


# Process Data --------------------------------------------------------

load("data/t1/sim.n2000.rda")
sim.base <- sim

sims <- 2132:2162
length(sims)
vals <- seq(0.5, 2, 0.05)

for (i in seq_along(sims)) {
  fn <- list.files("data/f1", pattern = as.character(sims[i]), full.names = TRUE)
  load(fn)

  haz.W <- as.numeric(colMeans(tail(sim$epi$ir100.W, 52)))
  haz.B <- as.numeric(colMeans(tail(sim$epi$ir100.B, 52)))
  disp.ind <- haz.B - haz.W

  num.W <- unname(colMeans(tail(sim$epi$ir100.W, 52)))
  denom.W <- unname(colMeans(tail(sim.base$epi$ir100.W, 52)))
  vec.hr.W <- num.W/denom.W

  num.B <- unname(colMeans(tail(sim$epi$ir100.B, 52)))
  denom.B <- unname(colMeans(tail(sim.base$epi$ir100.B, 52)))
  vec.hr.B <- num.B/denom.B

  prev.ind <- vec.hr.B - vec.hr.W

  new.df <- data.frame(scenario = sims[i],
                       simno = 1:sim$control$nsims,
                       param = vals[i],
                       inc.B = haz.B, inc.W = haz.W,
                       disp.ind = disp.ind, prev.ind = prev.ind)

  if (i == 1) {
    df <- new.df
  } else {
    df <- rbind(df, new.df)
  }

  cat("*")
}

table(df$scenario)
table(df$param)
hist(df$prev.ind)

dfb <- group_by(df, param)
dfo <- as.data.frame(summarise(dfb,
                               disp = mean(disp.ind),
                               disp.lcl = quantile(disp.ind, 0.025),
                               disp.ucl = quantile(disp.ind, 0.975),
                               prev = mean(prev.ind),
                               prev.lcl = quantile(prev.ind, 0.025),
                               prev.ucl = quantile(prev.ind, 0.975)))

dfo$disp <- lowess(dfo$disp)$y
dfo$disp.lcl <- lowess(dfo$disp.lcl)$y
dfo$disp.ucl <- lowess(dfo$disp.ucl)$y

dfo$prev <- lowess(dfo$prev)$y
dfo$prev.lcl <- lowess(dfo$prev.lcl)$y
dfo$prev.ucl <- lowess(dfo$prev.ucl)$y

library(viridis)
pal1 <- viridis(5)
pal2 <- adjustcolor(pal1, alpha.f = 0.25)

library(ggplot2)
df$prev.ind.1 <- ifelse(df$prev.ind >= 0, ">= 0", "< 0")

pdf(file = "analysis/Fig2.pdf", height = 7, width = 10)
ggplot(df, aes(param, disp.ind)) +
  geom_jitter(aes(fill = prev.ind.1), shape = 21, color = "white",
              size = 2.5, alpha = 0.25, width = 0.05) +
  stat_smooth(col = "black", lwd = 0.5, se = FALSE, method = "loess") +
  scale_fill_brewer(palette = "Set1") +
  labs(fill = "Prevention\nIndex", size = "BMSM\nIR",
       y = "Disparity Index", x = "Relative BMSM Continuum") +
  geom_vline(xintercept = 1, lwd = 0.5, lty = 3) +
  geom_hline(yintercept = 6.08, lwd = 0.5, lty = 2) +
  theme_minimal()
dev.off()



# alternate ---------------------------------------------------------------

# pdf(file = "analysis/Fig1.pdf", height = 8, width = 16)
par(mar = c(3,3,2,1), mgp = c(2,1,0), mfrow = c(1,2))
plot(dfo$param, dfo$disp, type = "n", ylim = c(0, 12),
     ylab = "Disparity Index", xlab = "Relative BMSM Continuum Values",
     main = "A. Disparity Index by BMSM Continuum")
lines(dfo$param, dfo$disp, lwd = 2, col = pal1[1])
polygon(c(dfo$param, rev(dfo$param)), c(dfo$disp.lcl, rev(dfo$disp.ucl)),
        col = pal2[1], border = "grey70")
abline(h = 1, lty = 2)
points(1, dfo[which(dfo$param == 1),]$disp, col = pal1[4], bg = pal1[5], cex = 1.5, pch = 21)
legend("topright", legend = c("Predictions", "Observed Continuum"), lty = c(1, NA), pch = c(NA, 21),
       col = c(pal1[1], pal1[4]), pt.bg = c(NA, pal1[5]), lwd = c(2, NA), cex = 0.9, bty = "n")

plot(dfo$param, dfo$prev, type = "n", ylim = c(0, 3),
     ylab = "Prevention Index", xlab = "Relative BMSM Continuum Values",
     main = "B. Prevention Index by BMSM Continuum")
lines(dfo$param, dfo$prev, lwd = 2, col = pal1[2])
polygon(c(dfo$param, rev(dfo$param)), c(dfo$prev.lcl, rev(dfo$prev.ucl)),
        col = pal2[2], border = "grey70")
abline(h = 1, lty = 2)
points(1, dfo[which(dfo$param == 1),]$prev, col = pal1[4], bg = pal1[5], cex = 1.5, pch = 21)
legend("topright", legend = c("Predictions", "Observed Continuum"), lty = c(1, NA), pch = c(NA, 21),
       col = c(pal1[2], pal1[4]), pt.bg = c(NA, pal1[5]), lwd = c(2, NA), cex = 0.9, bty = "n")
# dev.off()
