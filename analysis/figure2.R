
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

library(ggplot2)
library(ggjoy)

pal <- viridis::viridis(5)
pal <- RColorBrewer::brewer.pal(11, "PRGn")

p1 <- ggplot(ndf, aes(y = param)) +
  geom_joy(aes(x = prev, fill = paste(param, race)),
           alpha = 0.95, scale = 4, rel_min_height = 0.001, col = "white", lwd = 0.5) +
  theme_joy(grid = TRUE) +
  xlab("HIV Prevalence") +
  ylab("BMSM Relative Continuum") +
  scale_y_discrete(expand = c(0.01, 0), breaks = seq(0.5, 2.0, 0.1)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  scale_fill_cyclical(breaks = c("2 B", "2 W"),
                      labels = c(`2 B` = "B", `2 W` = "W"),
                      values = c(pal[2], pal[9], pal[3], pal[10]),
                      name = "Race", guide = "legend")

p2 <- ggplot(ndf, aes(y = param)) +
  geom_joy(aes(x = inc, fill = paste(param, race)),
           alpha = 0.9, scale = 4, rel_min_height = 0.02, col = "white", lwd = 0.5) +
  theme_joy(grid = TRUE) +
  xlab("HIV Incidence") +
  ylab("BMSM Relative Continuum") +
  scale_y_discrete(expand = c(0.01, 0), breaks = seq(0.5, 2.0, 0.1)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  scale_fill_cyclical(breaks = c("2 B", "2 W"),
                      labels = c(`2 B` = "B", `2 W` = "W"),
                      values = c(pal[2], pal[9], pal[3], pal[10]),
                      name = "Race", guide = "legend")

library(gridExtra)
pdf(file = "analysis/Fig2.pdf", h = 8, w = 16)
grid.arrange(p1, p2, ncol = 2)
dev.off()


# alternates --------------------------------------------------------------

ggplot(df, aes(x = prev.B, y = param, fill = param)) +
  geom_joy(scale = 2, rel_min_height = 0.01, alpha = 0.6, col = "black") +
  scale_fill_cyclical(values = c("gray", "lightblue")) +
  scale_y_discrete(expand = c(0.01, 0)) +
  xlab("HIV Prevalence") +
  theme_joy(grid = TRUE) +
  theme(axis.title.y = element_blank(),
        legend.position = "none")

ggplot(df, aes(x = prev.W, y = param, fill = param)) +
  geom_joy(scale = 2, rel_min_height = 0.01, alpha = 0.6, col = "white") +
  scale_fill_viridis(discrete = TRUE, alpha = 0.5) +
  scale_y_discrete(expand = c(0.01, 0)) +
  scale_y_discrete(expand = c(0.01, 0), breaks = seq(0.5, 2, 0.1)) +
  xlab("HIV Prevalence") +
  theme_joy() +
  theme(axis.title.y = element_blank(),
        legend.position = "none")
