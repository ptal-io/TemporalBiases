
library(circular)

setwd('~/Research_Projects/PlaceTypeAlignment/TemporalAnalysis')

fs <- read.csv('fs_signatures.csv',header=T,sep='\t')
rownames(fs) <- fs[,1]

gp <- read.csv('gp_signatures.csv',header=F)
rownames(gp) <- gp[,1]

m <- matrix(,ncol=nrow(gp), nrow=nrow(fs))
rownames(m) <- rownames(fs)
colnames(m) <- rownames(gp)


watson.two.test(x, y, alpha=0)

