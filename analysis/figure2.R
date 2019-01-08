
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
  disp.ind.abs <- haz.B - haz.W
  disp.ind.rel <- haz.B / haz.W

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
                       disp.ind.abs = disp.ind.abs,
                       disp.ind.rel = disp.ind.rel,
                       prev.ind = prev.ind)

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

library(viridis)
pal1 <- viridis(5)
pal2 <- adjustcolor(pal1, alpha.f = 0.25)

library(ggplot2)
df$prev.ind.1 <- ifelse(df$prev.ind >= 0, ">0", "<0")

p1 <- ggplot(df, aes(param, disp.ind.abs)) +
  geom_jitter(aes(fill = prev.ind.1), shape = 21, color = "white",
              size = 2.5, alpha = 0.25, width = 0.05, show.legend = TRUE) +
  stat_smooth(col = "black", lwd = 0.5, se = FALSE, method = "loess") +
  scale_fill_brewer(palette = "Set1") +
  labs(fill = "Prevention Index", size = "BMSM\nIR",
       y = "Disparity Index", x = "Relative BMSM Continuum") +
  geom_vline(xintercept = 1, lwd = 0.5, lty = 3) +
  geom_hline(yintercept = 6.08, lwd = 0.5, lty = 2) +
  theme_classic() +
  ylim(0, 10) +
  theme(legend.position = c(0.85, 0.9),
        legend.background = element_rect(color = "black",
                                         size = 0.5,
                                         linetype = "solid"),
        axis.text = element_text(size = 12, colour = "black"),
        axis.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        legend.title = element_text(size = 12),
        axis.ticks.length = unit(0.25, "cm"),
        axis.ticks = element_line(color = "black"))
p1

pdf(file = "analysis/Figure2.pdf", height = 5.5, width = 5.5)
p1
dev.off()
