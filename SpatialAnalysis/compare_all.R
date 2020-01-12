setwd('~/Research_Projects/PlaceTypeAlignment/SpatialAnalysis')

ann <- read.csv('comparison_ANN.csv',header=T)
sd <- read.csv('comparison_SD.csv',header=T)
rl <- read.csv('comparison_RL.csv',header=T)
rownames(ann) <- ann[,1]
rownames(sd) <- sd[,1]
rownames(rl) <- rl[,1]

mm <- matrix(,nrow=532, ncol=102)
rownames(mm) <- rownames(ann)
colnames(mm) <- colnames(ann)

for (z in 2:102) {
	print(z)
	ann[,102] <- seq(1,532)
	a <- ann[order(ann[,z]),c(1,z,102)]
	a[,4] <- seq(1,532)

	sd[,102] <- seq(1,532)
	b <- sd[order(sd[,z]),c(1,z,102)]
	b[,4] <- seq(1,532)

	rl[,102] <- seq(1,532)
	c <- rl[order(-rl[,z]),c(1,z,102)]
	c[,4] <- seq(1,532)

	#k <- 1
	m <- matrix(,nrow=532,ncol=4)
	cnt <- 1
	for(i in 1:nrow(a)) {
		#for(j in 1:nrow(b)) {
		for(k in 1:nrow(c)) {
			if (as.character(a[i,1]) == as.character(c[k,1])) {
				#print(paste(cnt,' : ',a[i,1],' - ',a[i,4],',',c[k,4],' - ',(a[i,4]+c[k,4])/2))

				m[cnt,1] <- as.character(a[i,1])
				m[cnt,2] <- a[i,4]
				m[cnt,3] <- c[k,4]
				m[cnt,4] <- as.numeric((a[i,4] + c[k,4]) / 2)
				cnt<- cnt + 1
			}
		}
		#}
	}
	dfg <- data.frame(m)
	dfg[,4] <- as.numeric(as.character(dfg[,4]))
	asdf <- dfg[order(dfg[,1]),c(4)]
	mm[,z-1] <- asdf
}

write.table(mm,file='comparison_ALL.csv', sep=',', quote=FALSE, row.names = TRUE, col.names = NA)


