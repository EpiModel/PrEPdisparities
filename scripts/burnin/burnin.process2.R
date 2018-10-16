
# Base scenario
load("data/t1/sim.n2000.rda")
sim.base <- sim
epi_stats(sim.base, at = 520, qnt.low = 0.025, qnt.high = 0.975)

df <- as.data.frame(sim)
names(df)

prop.test(197, 454, conf.level = 0.95, correct = FALSE)
prop.test(46, 349, conf.level = 0.95, correct = FALSE)


names(sim)
names(sim$attr[[1]])

age <- sim$attr[[1]]$age
status <- sim$attr[[1]]$status
race <- sim$attr[[1]]$race

mean(status)
mean(status[race == "B"])
mean(status[race == "W"])

age.cat <- rep(NA, length(age))
age.cat[age >= 18 & age < 20] <- 1
age.cat[age >= 20 & age < 25] <- 2
age.cat[age >= 25 & age < 30] <- 3
age.cat[age >= 30 & age < 40] <- 4

mean(status[race == "B" & age.cat == 1])
prop.test(2, 27, conf.level = 0.95, correct = FALSE)

mean(status[race == "B" & age.cat == 2])
prop.test(53, 156, conf.level = 0.95, correct = FALSE)

mean(status[race == "B" & age.cat == 3])
prop.test(62, 137, conf.level = 0.95, correct = FALSE)

mean(status[race == "B" & age.cat == 4])
prop.test(75, 125, conf.level = 0.95, correct = FALSE)

mean(status[race == "W" & age.cat == 1])
prop.test(1, 16, conf.level = 0.95, correct = FALSE)

mean(status[race == "W" & age.cat == 2])
prop.test(5, 91, conf.level = 0.95, correct = FALSE)

mean(status[race == "W" & age.cat == 3])
prop.test(15, 105, conf.level = 0.95, correct = FALSE)

mean(status[race == "W" & age.cat == 4])
prop.test(19, 121, conf.level = 0.95, correct = FALSE)
