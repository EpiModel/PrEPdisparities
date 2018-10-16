
ggplot(ndf, aes(y = param)) +
  geom_vline(xintercept = 7.73, lty = 2) +
  geom_density_ridges(aes(x = inc, fill = paste(param, race)),
                      alpha = 0.9, scale = 4, rel_min_height = 0.02, col = "white", lwd = 0.5) +
  theme_ridges(grid = TRUE) +
  labs(x = "HIV Incidence per 100 PYAR",
       y = "BMSM Relative Continuum",
       main = "B. Race-Stratified HIV Incidence by BMSM Continuum") +
  scale_y_discrete(expand = c(0.01, 0), breaks = seq(0.5, 2.0, 0.1)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  scale_fill_cyclical(breaks = c("2 B", "2 W"),
                      labels = c(`2 B` = "B", `2 W` = "W"),
                      values = c(pal[2], pal[9], pal[3], pal[10]),
                      name = "Race", guide = "legend")


library(gganimate)

ndf$param <- as.numeric(as.character(ndf$param))

pal <- viridis::viridis(5)
pal <- RColorBrewer::brewer.pal(11, "PRGn")
ggplot(ndf) +
  geom_density_ridges(aes(x = inc, y = race, fill = race),
                      alpha = 0.9, scale = 4, rel_min_height = 0.02, col = "grey10", lwd = 0.5) +
  transition_time(param) +
  ease_aes('linear') +
  theme_ridges(grid = TRUE) +
  scale_y_discrete(expand = c(0.01, 0), breaks = seq(0.5, 2.0, 0.1)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  labs(title = "BMSM PrEP Continuum: {frame_time}", x = "HIV Incidence Rate") +
  scale_fill_manual(values = c(pal[2], pal[9]))
