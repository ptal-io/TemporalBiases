
f_sd <- read.csv('standard_distance_foursquare.csv',header=T)
g_sd <- read.csv('standard_distance_google.csv',header=T)
#f_sd <- na.omit(f_sd)
#g_sd <- na.omit(g_sd)
rownames(f_sd) <- f_sd[,1]
rownames(g_sd) <- g_sd[,1]

m <- matrix(,ncol=nrow(f_sd), nrow=nrow(g_sd))
rownames(m) <- rownames(g_sd)
colnames(m) <- rownames(f_sd)

for(i in 1:nrow(f_sd)) {
	#print("===============")
	#print(as.vector(f_sd[i,1]))
	#min <- 10
	#mintype <- ""
	for(j in 1:nrow(g_sd)) {
		if (!is.null(f_sd$standard_distance[i]) & !is.null(g_sd$standard_distance[j]))
			m[j,i] <- abs(f_sd$standard_distance[i] - g_sd$standard_distance[j])
		#if (abs(f_sd$standard_distance[i] - g_sd$standard_distance[j]) < min & !is.null(g_sd[j,1])) {
			#min = abs(f_sd$standard_distance[i] - g_sd$standard_distance[j])
			#mintype = as.vector(g_sd[j,1])
		
		#}
	}
	#print(mintype)
}

write.table(m,file='comparison_standard_distance.csv', sep=',',row.names=FALSE, quote=FALSE)
