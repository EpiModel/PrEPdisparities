
library(ggplot2)
library(ggjoy)
library(viridis)

ggplot(diamonds, aes(x = price, y = cut, fill = cut)) +
  geom_joy(scale = 4) + theme_joy() +
  scale_fill_viridis(discrete = TRUE, alpha = 0.5) +
  scale_y_discrete(expand = c(0.01, 0)) +   # will generally have to set the `expand` option
  scale_x_continuous(expand = c(0, 0))      # for both axes to remove unneeded padding

ggplot(diamonds, aes(x = price, y = cut)) +
  geom_joy(scale = 4, fill = "steelblue", alpha = 0.5) + theme_joy() +
  scale_y_discrete(expand = c(0.01, 0)) +   # will generally have to set the `expand` option
  scale_x_continuous(expand = c(0, 0))      # for both axes to remove unneeded padding

ggplot(iris, aes(x = Sepal.Length, y = Species)) +
  geom_joy() +
  theme_joy(grid = FALSE) +
  scale_x_continuous(expand = c(0.01, 0)) +
  scale_y_discrete(expand = c(0.01, 0))

iris_num <- transform(iris, Species_num = as.numeric(Species))
ggplot(iris_num, aes(x = Sepal.Length, y = Species_num, group = Species_num)) +
  geom_joy(fill = "seagreen", alpha = 0.5) + theme_minimal()

library(viridis)
ggplot(d, aes(x=value, y=parameter, height=..density.., fill = parameter)) +
  scale_fill_viridis(discrete = TRUE) +
  geom_vline(xintercept = 0, col = "grey70") +
  geom_joy(col = "grey70", scale = 2.4, show.legend = F) +
  darktheme


library(dplyr)
set.seed(123)
joy <- data.frame('label'=rep(letters[1:10], each=100),
                  'value'=as.vector(mapply(rnorm, rep(100, 10), rnorm(10), SIMPLIFY=TRUE)),
                  'rank'=rep(1:5, each=100, times=20))
joy <- group_by(joy, label) %>%
  mutate(m=mean(value)) %>%
  arrange(m) %>%
  ungroup() %>%
  mutate(label=factor(label, unique(label)))

ggplot(joy, aes(x=value, y=label, fill=label)) +
  geom_joy(scale=2, rel_min_height=0.01, alpha = 0.6) +
  scale_fill_manual(values=rep(c('gray', 'lightblue'), length(unique(joy$label))/2)) +
  scale_y_discrete(expand = c(0.01, 0)) +
  xlab('Value') +
  theme_joy() +
  theme(axis.title.y = element_blank(),
        legend.position='none')


# set the `rel_min_height` argument to remove tails
ggplot(iris, aes(x = Sepal.Length, y = Species)) +
  geom_joy(rel_min_height = 0.005) +
  scale_y_discrete(expand = c(0.01, 0)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  theme_joy()

# set the `scale` to determine how much overlap there is among the plots
ggplot(diamonds, aes(x = price, y = cut)) +
  geom_joy(scale = 4) +
  scale_y_discrete(expand=c(0.01, 0)) +
  scale_x_continuous(expand=c(0.01, 0)) +
  theme_joy()

# the same figure with colors, and using the ggplot2 density stat
ggplot(diamonds, aes(x = price, y = cut, fill = cut, height = ..density..)) +
  geom_joy(scale = 4, stat = "density") +
  scale_y_discrete(expand = c(0.01, 0)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  scale_fill_brewer(palette = 4) +
  theme_joy() + theme(legend.position = "none")

# use geom_joy2() instead of geom_joy() for solid polygons
ggplot(iris, aes(x = Sepal.Length, y = Species)) +
  geom_joy2() +
  scale_y_discrete(expand = c(0.01, 0)) +
  scale_x_continuous(expand = c(0.01, 0)) +
  theme_joy()


library(tidyverse)
library(forcats)

ce <- mutate(Catalan_elections, YearFct = fct_rev(as.factor(Year)))

ggplot(ce, aes(y = YearFct)) +
geom_joy(aes(x = Percent, fill = paste(YearFct, Option)),
         alpha = .8, color = "white", from = 0, to = 100) +
labs(x = "Vote (%)",
     y = "Election Year") +
scale_y_discrete(expand = c(0.01, 0)) +
scale_x_continuous(expand = c(0.01, 0)) +
scale_fill_cyclical(breaks = c("1980 Indy", "1980 Unionist"),
                    labels = c(`1980 Indy` = "Indy", `1980 Unionist` = "Unionist"),
                    values = c("#ff0000", "#0000ff", "#ff8080", "#8080ff"),
                    name = "Option", guide = "legend") +
theme_joy(grid = FALSE)

