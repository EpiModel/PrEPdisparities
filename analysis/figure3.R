
## PrEP Race Figure 3
rm(list = ls())
library("EpiModelHIV")
library("dplyr")

library("ggplot2")
library("viridis")
library("gridExtra")

source("analysis/fx.R")


# Process Data --------------------------------------------------------

load("data/t1/sim.n2000.rda")
sim.base <- sim
incid.base.B <- unname(colSums(sim.base$epi$incid.B))

sims <- 2163:2418
# sims <- c(2243, 2248, 2258)

for (i in seq_along(sims)) {
  fn <- list.files("data/f3", pattern = as.character(sims[i]), full.names = TRUE)
  load(fn)

  i.prev.W <- median(as.numeric(sim$epi$i.prev.W[520, ]))
  i.prev.B <- median(as.numeric(sim$epi$i.prev.B[520, ]))

  haz.W <- median(as.numeric(colMeans(tail(sim$epi$ir100.W, 52))))
  haz.B <- median(as.numeric(colMeans(tail(sim$epi$ir100.B, 52))))

  disp.ind <- median(haz.B/haz.W)

  incid.comp.B <- unname(colSums(sim$epi$incid.B))
  vec.nia.B <- incid.base.B[1:112] - incid.comp.B
  vec.pia.B <- vec.nia.B/incid.base.B[1:112]
  pia.B <- median(vec.pia.B)

  py.on.prep.B <- unname(colSums(sim$epi$prepCurr.B))/52
  vec.nnt.B <- py.on.prep.B/(median(incid.base.B) - unname(colSums(sim$epi$incid.B)))
  nnt.B <- median(vec.nnt.B)

  new.df <- data.frame(scenario = sims[i],
                       p1 = sim$param$prep.aware.B/0.5,
                       p2 = sim$param$prep.discont.rate.B,
                       prev.B = i.prev.B,
                       prev.W = i.prev.W,
                       inc.B = haz.B,
                       inc.W = haz.W,
                       disp.ind = disp.ind,
                       pia.B = pia.B,
                       nnt.B = nnt.B)

  if (i == 1) {
    df <- new.df
  } else {
    df <- rbind(df, new.df)
  }

  cat("*")
}

nrow(df)

table(df$p1)
table(df$p2)
table(df$p1, df$p2)

df$p2 <- rep(seq(0.5, 2, 0.1), times = 16)

table(df$p1, df$p2)

## PIA
prev.loess <- loess(pia.B ~ p1 * p2, data = df)
prev.fit2 <- expand.grid(list(p1 = seq(0.5, 2, 0.01),
                              p2 = seq(0.5, 2, 0.01)))
prev.fit2$PIA <- as.numeric(predict(prev.loess, newdata = prev.fit2))

p1 <- ggplot(prev.fit2, aes(p1, p2)) +
  geom_raster(aes(fill = PIA), interpolate = TRUE) +
  geom_contour(aes(z = PIA), col = "white", alpha = 0.5, lwd = 0.5) +
  theme_classic() +
  scale_y_continuous(expand = c(0, 0)) +
  scale_x_continuous(expand = c(0, 0)) +
  labs(y = "Relative PrEP Engagement Continuum", x = "Relative PrEP Initiation Continuum") +
  # scale_fill_viridis(discrete = FALSE, alpha = 1, option = "D", direction = 1) +
  scale_fill_distiller(type = "div", palette = "RdYlGn", direction = 1,
                       breaks = c(0.03,0.2,0.4,0.6), labels = c("0.0",0.2,0.4, 0.6)) +
  theme(legend.position = "right",axis.text = element_text(size = 12, colour = "black"),
        axis.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        legend.title = element_text(size = 12),
        axis.ticks.length = unit(0.25, "cm"),
        axis.ticks = element_line(color = "black"))

## NNT

prev.loess <- loess(nnt.B ~ p1 * p2, data = df)
prev.fit3 <- expand.grid(list(p1 = seq(0.5, 2, 0.01),
                              p2 = seq(0.5, 2, 0.01)))
prev.fit3$NNT <- as.numeric(predict(prev.loess, newdata = prev.fit3))

p2 <- ggplot(prev.fit3, aes(p1, p2)) +
  geom_raster(aes(fill = NNT), interpolate = TRUE) +
  geom_contour(aes(z = NNT), col = "white", alpha = 0.5, lwd = 0.5) +
  theme_classic() +
  scale_y_continuous(expand = c(0, 0)) +
  scale_x_continuous(expand = c(0, 0)) +
  labs(y = "Relative PrEP Engagement Continuum", x = "Relative PrEP Initiation Continuum") +
  scale_fill_distiller(type = "div", palette = "RdYlGn") +
  theme(legend.position = "right",
        axis.text = element_text(size = 12, colour = "black"),
        axis.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        legend.title = element_text(size = 12),
        axis.ticks.length = unit(0.25, "cm"),
        axis.ticks = element_line(color = "black"))

grid.arrange(p1, p2, ncol = 2)

pdf(file = "analysis/Figure3.pdf", height = 5.5, width = 11)
grid.arrange(p1, p2, ncol = 2)
dev.off()

pdf(file = "analysis/Figure3A.pdf", height = 5.5, width = 5.5)
p1
dev.off()

pdf(file = "analysis/Figure3B.pdf", height = 5.5, width = 5.5)
p2
dev.off()
