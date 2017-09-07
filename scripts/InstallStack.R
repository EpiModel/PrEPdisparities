
## 0. Update PrEP Race

devtools::install_github("statnet/tergmLite")
devtools::install_github("statnet/EpiModelHIV", ref = "prep-race")

## 1. Fitting on libra
system("scp scripts/estimation/01.setup.R libra:~/prace")
system("scp scripts/estimation/02.estim.R libra:~/prace")

system("scp libra:~/prace/est/*.rda est/")


## 2. Reestimation ABC

system("scp est/*.rda hyak:/gscratch/csde/sjenness/prace/est")
system("scp scripts/estimation/*.reestim.* hyak:/gscratch/csde/sjenness/prace/")

system("scp hyak:/gscratch/csde/sjenness/prace/data/*.rda data/")
system("scp est/*.rda hyak:/gscratch/csde/sjenness/prace/est")


## 3. Burnin

system("scp est/*.rda hyak:/gscratch/csde/sjenness/prace/est")
system("scp scripts/burnin/*.burn.* hyak:/gscratch/csde/sjenness/prace/")
system("scp hyak:/gscratch/csde/sjenness/prace/data/*.n*.rda data/")


## 4. Intervention

system("scp scripts/followup/*.fu.* hyak:/gscratch/csde/sjenness/prace/")

system("scp hyak:/gscratch/csde/sjenness/prace/data/*.n*.rda data/")
