# Temporal Signatures Similarity comparison (Cosine Similarity)

library(lsa)

setwd('~/Research_Projects/PlaceTypeAlignment/TemporalAnalysis')

fs <- read.csv('fs_signatures.csv',header=T,sep='\t')
rownames(fs) <- fs[,1]

gp <- read.csv('gp_signatures.csv',header=F)
rownames(gp) <- gp[,1]

m <- matrix(,ncol=nrow(gp), nrow=nrow(fs))
rownames(m) <- rownames(fs)
colnames(m) <- rownames(gp)

for (i in 1:nrow(fs)) {
	for (j in 1:nrow(gp)) {
		# move google data to have Sunday first (to align with Foursquare data)
		a <- as.numeric(gp[j,147:170])
		b <- as.numeric(gp[j,3:146])
		gt <- c(a,b)
		ft <- as.numeric(fs[i,2:169])
		cs <- cosine(ft,gt)
		m[i,j] <- cs
	}
}

write.table(m, file='fs2gp.csv',sep=',',quote = FALSE, row.names = TRUE, col.names = NA)
