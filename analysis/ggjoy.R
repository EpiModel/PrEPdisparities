
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
