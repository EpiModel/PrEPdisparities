# Addressing PrEP Care Gaps to Reduce HIV Disparities

This repository holds the source to code to reproduce the analysis featured in our HIV transmission model among men who have sex with men in the United States. This study investigated how race-based gaps along a PrEP care "continuum" -- from awareness to access to prescription to adherence to retention -- could impact HIV incidence overall among MSM and the disparities in HIV incidence between black and white MSM.

## Citation

> Jenness SM, Maloney K, Smith SK, Hoover KW, Rosenberg ES, Goodreau SM, Weiss KM, Liu AY, Rao D, Sullivan PS. Addressing Gaps in HIV Preexposure Prophylaxis Care to Reduce Racial Disparities in HIV Incidence in the United States. _American Journal of Epidemiology._ Epub DOI: 10.1093/aje/kwy230. 


<img src="https://github.com/EpiModel/PrEPdisparities/raw/master/analysis/Fig1.png">

## Abstract

The potential for HIV preexposure prophylaxis (PrEP) to reduce the racial disparities in HIV incidence in the United States may be limited by racial gaps in PrEP care. We used a network-based mathematical model of HIV transmission for younger black and white men who have sex with men (B/WMSM) in the Atlanta area to evaluate how race-stratified transitions through the PrEP care continuum from initiation to adherence and retention could impact HIV incidence overall and disparities in incidence between races, using current empirical estimates of BMSM continuum parameters. Relative to a no-PrEP scenario, implementing PrEP according to observed BMSM parameters was projected to yield a 23% decline in HIV incidence (HR = 0.77) among BMSM at year 10. The racial disparity in incidence in this observed scenario was 4.95 per 100 person-years at risk (PYAR), a 19% decline from the 6.08 per 100 PYAR disparity in the no-PrEP scenario. If BMSM parameters were increased to WMSM values, incidence would decline by 47% (HR = 0.53), with an associated disparity of 3.30 per 100 PYAR (a 46% decline in the disparity). PrEP could simultaneously lower HIV incidence overall and reduce racial disparities despite current gaps in PrEP care. Interventions addressing these gaps will be needed to substantially decrease disparities.

<img src="https://github.com/EpiModel/PrEPdisparities/raw/master/analysis/Fig3.png">

## Model Code

These models are written and executed in the R statistical software language. To run these files, it is necessary to first install our epidemic modeling software, [EpiModel](http://epimodel.org/), and our extension package specifically for modeling HIV and STI transmission dynamics among MSM, [EpiModelHIV](http://github.com/statnet/EpiModelHIV).

In R:
```
install.packages("EpiModel", dep = TRUE)

# install remotes if necessary, install.packages("remotes")
remotes::install_github("statnet/tergmLite")
remotes::install_github("statnet/EpiModelHPC")
remotes::install_github("statnet/EpiModelHIV", ref = "p4")
```
