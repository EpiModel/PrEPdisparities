
## Update PrEP Race

devtools::install_github("statnet/tergmLite")
devtools::install_github("statnet/EpiModelHIV", ref = "prep-race")


# Estimation/Reestimation ABC
system("scp est/*.rda hyak:/gscratch/csde/sjenness/race/est")
system("scp scripts/estimation/*.reestim.* hyak:/gscratch/csde/sjenness/race/")

system("scp hyak:/gscratch/csde/sjenness/race/data/*.rda data/")
