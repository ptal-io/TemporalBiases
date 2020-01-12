library(lsa)
#setwd('~/Research_Projects/SpatialAnalysis/')

f_sd <- read.csv('ripleysL_foursquare.csv',header=F)
g_sd <- read.csv('ripleysL_google.csv',header=F)

rownames(f_sd) <- f_sd[,1]
rownames(g_sd) <- g_sd[,1]
f_sd <- na.omit(f_sd)
g_sd <- na.omit(g_sd)

m <- matrix(,nrow=nrow(f_sd), ncol=nrow(g_sd))
rownames(m) <- rownames(f_sd)
colnames(m) <- rownames(g_sd)

for(i in 1:nrow(g_sd)) {
	for(j in 1:nrow(f_sd)) {
		#if (!is.na(f_sd[j,2]) & !is.na(g_sd[i,2])) {
			ft <- as.numeric(f_sd[j,2:102])
			gt <- as.numeric(g_sd[i,2:102])
			m[j,i] <- cosine(ft,gt)
		#}
	}
}

ripley <- data.frame(m)

data.frame(ripley[order(-ripley$light_rail_station),c(1:2)])[1:10,]

write.table(m,file='comparison_RL.csv', sep=',', quote=FALSE, row.names = TRUE, col.names = NA)
