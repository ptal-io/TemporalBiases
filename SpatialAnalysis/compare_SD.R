
setwd('~/Research_Projects/PlaceTypeAlignment/SpatialAnalysis')

f_sd <- read.csv('standard_distance_foursquare.csv',header=T)
g_sd <- read.csv('standard_distance_google.csv',header=T)

rownames(f_sd) <- f_sd[,1]
rownames(g_sd) <- g_sd[,1]
f_sd <- na.omit(f_sd)
g_sd <- na.omit(g_sd)

m <- matrix(,nrow=nrow(f_sd), ncol=nrow(g_sd))
rownames(m) <- rownames(f_sd)
colnames(m) <- rownames(g_sd)

for(i in 1:nrow(g_sd)) {
	for(j in 1:nrow(f_sd)) {
		if (!is.na(f_sd$standard_distance[j]) & !is.na(g_sd$standard_distance[i])) {
			a <- f_sd$standard_distance[j] - g_sd$standard_distance[i]
			m[j,i] <- abs(a)
		}
	}
}

sd <- data.frame(m)

data.frame(sd[order(sd$light_rail_station),c(1:2)])[1:10,]

#x <- na.omit(m)
write.table(m,file='comparison_SD.csv', sep=',', quote=FALSE, row.names = TRUE, col.names = NA)
