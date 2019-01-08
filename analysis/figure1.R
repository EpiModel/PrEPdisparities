
## PrEP Race Figure 1

rm(list = ls())
library("EpiModelHIV")
library("EpiModelHPC")
library("dplyr")
source("analysis/fx.R")

library(ggplot2)
library(ggridges)
library(gridExtra)

# Process Data --------------------------------------------------------

load("data/t1/sim.n2000.rda")
sim.base <- sim

sims <- 2132:2162
length(sims)
vals <- seq(0.5, 2, 0.05)

for (i in seq_along(sims)) {
  fn <- list.files("data/f1", pattern = as.character(sims[i]), full.names = TRUE)
  load(fn)

  i.prev.W <- as.numeric(sim$epi$i.prev.W[520, ])
  i.prev.B <- as.numeric(sim$epi$i.prev.B[520, ])

  haz.W <- as.numeric(colMeans(tail(sim$epi$ir100.W, 52)))
  haz.B <- as.numeric(colMeans(tail(sim$epi$ir100.B, 52)))

  new.df <- data.frame(scenario = sims[i],
                       simno = 1:sim$control$nsims,
                       param = vals[i],
                       prev.B = i.prev.B,
                       prev.W = i.prev.W,
                       inc.B = haz.B,
                       inc.W = haz.W)

  if (i == 1) {
    df <- new.df
  } else {
    df <- rbind(df, new.df)
  }

  cat("*")
}

table(df$scenario)
table(df$param)
hist(df$prev.B)
hist(df$prev.W)


df <- mutate(df, param = factor(param, unique(param)))

dfb <- df
dfw <- df
dfb$race <- "B"
dfw$race <- "W"
dfb$prev <- dfb$prev.B
dfw$prev <- dfb$prev.W
dfb$inc <- dfb$inc.B
dfw$inc <- dfw$inc.W
dfb <- dfb[, c(3, 8:10)]
dfw <- dfw[, c(3, 8:10)]

ndf <- rbind(dfb, dfw)


pal <- viridis::viridis(5)
pal <- RColorBrewer::brewer.pal(11, "PRGn")

scaleFUN <- function(x) sprintf("%.1f", x)
breaks = seq(0.5, 2.0, 0.1)


p1 <- ggplot(ndf, aes(y = param)) +
  geom_vline(xintercept = 0.452, lty = 2) +
  geom_density_ridges(aes(x = prev, fill = paste(param, race)),
                      alpha = 0.95, scale = 4, rel_min_height = 0.01, col = "white", lwd = 0.5) +
  # theme_ridges(grid = FALSE) +
  theme_classic() +
  labs(x = "HIV Prevalence",
       y = "BMSM Relative Continuum",
       main = "A. Race-Stratified HIV Incidence by BMSM Continuum") +
  scale_y_discrete(expand = c(0.01, 0), breaks = seq(0.5, 2.0, 0.1), labels = scaleFUN(breaks)) +
  scale_x_continuous(breaks = seq(0, 0.5, 0.1)) +
  scale_fill_cyclical(breaks = c("2 B", "2 W"),
                      labels = c(`2 B` = "B", `2 W` = "W"),
                      values = c(pal[2], pal[9], pal[3], pal[10]),
                      name = "Race", guide = "legend") +
  theme(legend.position = "none",
        axis.text = element_text(size = 12, colour = "black"),
        axis.title = element_text(size = 12),
        axis.ticks.length = unit(0.25, "cm"),
        axis.ticks = element_line(color = "black"))

p2 <- ggplot(ndf, aes(y = param)) +
  geom_vline(xintercept = 7.73, lty = 2) +
  geom_density_ridges(aes(x = inc, fill = paste(param, race)),
           alpha = 0.9, scale = 4, rel_min_height = 0.02, col = "white", lwd = 0.5) +
  # theme_ridges(grid = FALSE) +
  theme_classic() +
  labs(x = "HIV Incidence per 100 PYAR",
       y = "BMSM Relative Continuum",
       main = "B. Race-Stratified HIV Incidence by BMSM Continuum") +
  scale_y_discrete(expand = c(0.01, 0), breaks = seq(0.5, 2.0, 0.1), labels = scaleFUN(breaks)) +
  scale_x_continuous(breaks = seq(0, 10, 2.5)) +
  scale_fill_cyclical(breaks = c("2 B", "2 W"),
                      labels = c(`2 B` = "Black", `2 W` = "White"),
                      values = c(pal[2], pal[9], pal[3], pal[10]),
                      name = "Race", guide = "legend") +
  theme(legend.position = c(0.9, 0.9),
        legend.background = element_rect(color = "black",
                                         size = 0.5,
                                         linetype = "solid"),
        axis.text = element_text(size = 12, colour = "black"),
        axis.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        legend.title = element_text(size = 12),
        axis.ticks.length = unit(0.25, "cm"),
        axis.ticks = element_line(color = "black"))

grid.arrange(p1, p2, ncol = 2)

pdf(file = "analysis/Figure1.pdf", height = 5.5, width = 11)
grid.arrange(p1, p2, ncol = 2)
dev.off()

pdf(file = "analysis/Figure1A.pdf", height = 5.5, width = 5.5)
p1
dev.off()

pdf(file = "analysis/Figure1B.pdf", height = 5.5, width = 5.5)
p2
dev.off()
