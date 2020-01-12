


library(spatstat)
setwd('~/Research_Projects/PlaceTypeAlignment/SpatialAnalysis')
data <- read.csv('google_sa.csv',header=F)

# unique places and matrix for storing ann values
places <- unique(data[,3])
ann <- matrix(nrow=length(places), ncol=9)

# loop through all place types and calculate ANN
for (i in 1:length(places)) {
	place <- as.vector(places[i])
	#print(place)
	focus <- data[data[,3] == place,]
	ann[i,1] <- place
	if (length(focus[,1]) > 9 & place != 'establishment' & place != 'point_of_interest') {
		nn1 <- nndist(focus[,1:2], k=1)
		nn2 <- nndist(focus[,1:2], k=2)
		nn3 <- nndist(focus[,1:2], k=3)
		pair <- pairdist(focus[,1:2])
		
		
		ann[i,2] <- mean(nn1)
		ann[i,3] <- mean(nn2)
		ann[i,4] <- mean(nn3)
		ann[i,5] <- median(nn1)
		ann[i,6] <- median(nn2)
		ann[i,7] <- median(nn3)
		ann[i,8] <- mean(pair)
		ann[i,9] <- median(pair)
	}
}

# write out CSV containing ngram, mean lat, mean lng, standard distance
colnames(ann) <- c('type','mean_nn1','mean_nn2','mean_nn3','median_nn1','median_nn2','median_nn3','mean_pair','median_pair')
write.table(ann,file='ANN_google.csv', sep=',',row.names = F, quote=FALSE)


#plot(xy[,2],xy[,1])
#bearing <- 1:360 * pi/180
#cx <- mc[2] + sd * cos(bearing)
#cy <- mc[1] + sd * sin(bearing)
#circle <- cbind(cx, cy)
#lines(circle, col='red', lwd=2)