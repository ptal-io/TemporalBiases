


library(raster)
setwd('~/Research_Projects/PlaceTypeAlignment/SpatialAnalysis')
data <- read.csv('foursquare_sa.csv',header=F)

# unique places and matrix for storing ann values
places <- unique(data[,3])
standard_distance <- matrix(nrow=length(places), ncol=7)

# loop through all place types and calculate standard distance
for (i in 1:length(places)) {
	place <- as.vector(places[i])
	focus <- data[data[,3] == place,]
	standard_distance[i,1] <- place
	if (length(focus[,1]) > 9 & place != 'establishment' & place != 'point_of_interest') {
		xy <- coordinates(focus[1:2])
		mc <- apply(xy, 2, mean)
		md <- apply(xy, 2, median)
		sd <- sqrt(sum((xy[,1] - mc[1])^2 + (xy[,2] - mc[2])^2) / nrow(xy))
		#print(sd)
		
		standard_distance[i,2] <- mc[1]
		standard_distance[i,3] <- mc[2]
		standard_distance[i,4] <- sd
		standard_distance[i,5] <- md[1]
		standard_distance[i,6] <- md[2]
		standard_distance[i,7] <- length(focus[,1])
	}
}

# write out CSV containing ngram, mean lat, mean lng, standard distance
colnames(standard_distance) <- c('type','mean_lat','mean_lng','standard_distance','median_lat','median_lng','count')
write.table(standard_distance,file='standard_distance_foursquare.csv', sep=',',row.names=FALSE, quote=FALSE)


#plot(xy[,2],xy[,1])
#bearing <- 1:360 * pi/180
#cx <- mc[2] + sd * cos(bearing)
#cy <- mc[1] + sd * sin(bearing)
#circle <- cbind(cx, cy)
#lines(circle, col='red', lwd=2)