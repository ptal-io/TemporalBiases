
f_sd <- read.csv('ANN_foursquare.csv',header=T)
g_sd <- read.csv('ANN_google.csv',header=T)

rownames(f_sd) <- f_sd[,1]
rownames(g_sd) <- g_sd[,1]
f_sd <- na.omit(f_sd)
g_sd <- na.omit(g_sd)

m <- matrix(,nrow=nrow(f_sd), ncol=nrow(g_sd))
rownames(m) <- rownames(f_sd)
colnames(m) <- rownames(g_sd)

for(i in 1:nrow(g_sd)) {
	for(j in 1:nrow(f_sd)) {
		if (!is.na(f_sd$mean_nn1[j]) & !is.na(g_sd$mean_nn1[i])) {
			a <- f_sd$mean_nn1[j] - g_sd$mean_nn1[i]
			m[j,i] <- abs(a)
		}
	}
}

ann <- data.frame(m)

data.frame(ann[order(ann$light_rail_station),c(1:2)])[1:10,]

write.table(m,file='comparison_ANN.csv', sep=',', quote=FALSE, row.names = TRUE, col.names = NA)
