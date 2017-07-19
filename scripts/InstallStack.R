
## 0. Update PrEP Race

devtools::install_github("statnet/tergmLite")
devtools::install_github("statnet/EpiModelHIV", ref = "prep-race")


## 1. Estimation/Reestimation ABC
system("scp est/*.rda hyak:/gscratch/csde/sjenness/race/est")
system("scp scripts/estimation/*.reestim.* hyak:/gscratch/csde/sjenness/race/")

system("scp hyak:/gscratch/csde/sjenness/race/data/*.rda data/")
system("scp est/*.rda hyak:/gscratch/csde/sjenness/race/est")


## 2. Burnin testing

system("scp est/*.rda hyak:/gscratch/csde/sjenness/race/est")
system("scp scripts/burnin/*.burn.* hyak:/gscratch/csde/sjenness/race/")

system("scp hyak:/gscratch/csde/sjenness/race/data/*.rda data/")

