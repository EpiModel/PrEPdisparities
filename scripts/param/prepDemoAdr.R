
reallocate_pcp(in.pcp = c(0.244, 0.2, 0.556), reall = 0.1)

bvec <- c(0.1144, 0.1604, 0.4089)
bvec/sum(bvec)
dput(round(bvec/sum(bvec), 3))

wvec <- c(0.025, 0.0394, 0.830)
wvec/sum(wvec)
dput(round(bvec/sum(bvec), 3))
