# copy (select b.lat,b.lng,regexp_replace(a.name, '[^a-zA-Z0-9]+', '','g') as cat from md b, f_cats a where (b.state = 'MD' or b.state = 'D.C.' or b.state = 'Washington, D.C.' or b.state = 'Maryland') and a.id = b.categories) to '/home/grantdmckenzie/Research_Projects/PlaceTypeAlignment/SpatialAnalysis/foursquare_sa.csv' with csv;

library(spatstat)
library(e1071)
setwd('~/Research_Projects/PlaceTypeAlignment/SpatialAnalysis')
data <- read.csv('foursquare_sa_3857.csv',header=T)
data2 <- read.csv('google_sa_3857.csv',header=T)

# unique ngrams and matrix for storing standard_distance values
words <- unique(data[,5])
ripley <- matrix(nrow=length(words), ncol=514)

# EXTENT
w <- owin(c(-79.49,-75.049),c(37.92,39.73))	# Maryland

#w <- owin(c(111936.9842411539866589,495555.6911823216942139), c(4198330.9233981892466545,4407628.1748293256387115))

#focus <- data[data[,5] == 'post_office',]
#xy <- focus[,2:1]
#pp <- as.ppp(xy, w)
#L <- Lest(pp,correction="Ripley")
#K1 <- Kest(pp,correction="Ripley")
#a <- L$iso-L$r

#focus <- data[data[,5] == 'restaurant',]
#xy <- focus[,2:1]
#pp <- as.ppp(xy, w)
#L <- Lest(pp,correction="Ripley")
#K2 <- Kest(pp,correction="Ripley")
#b <- L$iso-L$r

#focus <- data[data[,5] == 'bar',]
#xy <- focus[,2:1]
#pp <- as.ppp(xy, w)
#L <- Lest(pp,correction="Ripley")
#K3 <- Kest(pp,correction="Ripley")
#c <- L$iso-L$r

#plot(K1$iso, type='l', col='blue')
#lines(K2$iso, col='red')
#lines(K3$iso, col='green')

w <- owin(c(-77.1,-76.5),c(38.9,39.5))
#w <- owin(c(111936.9842411539866589,495555.6911823216942139), c(4198330.9233981892466545,4407628.1748293256387115))

w <- owin(c(-8593756.7,-8488372.5),c(4691965.5,4754364.1))


pdf('~/Dropbox/Multidimensional_Place_Type_Alignment/paper/figures/ripley.pdf', width=10, height=4)
par( mar = c(4,4,0,0),family="serif")

word="Caf"
focus <- data[data[,5] == word,]
xy <- focus[,2:1]
pp <- as.ppp(xy, w)
L <- Lest(pp)
plot(L$iso, col='#2c9db7', type='l', ylim=range(0,30000), yaxt='n', xaxt='n', xlab='r (km)', ylab="L(r)", lwd=2, cex.lab=1.3)

axis(1,c(0,171,342,513), c(0,5,10,15))
axis(2,c(0,10000,20000,30000), c(0,10,20,30))

word="cafe"
focus <- data2[data2[,5] == word,]
xy <- focus[,2:1]
pp <- as.ppp(xy, w)
L <- Lest(pp)
lines(L$iso, col='#cc3434', lwd=2)

word="Airport"
focus <- data[data[,5] == word,]
xy <- focus[,2:1]
pp <- as.ppp(xy, w)
L <- Lest(pp)
lines(L$iso, col='#2c9db7', lwd=2, lty=2)

word="airport"
focus <- data2[data2[,5] == word,]
xy <- focus[,2:1]
pp <- as.ppp(xy, w)
L <- Lest(pp)
lines(L$iso, col='#cc3434', lwd=2, lty=2)
lines(L$r, lty=3, col='#333333')
legend('bottomright',c("Café (Google)","Café (Foursquare)","Airport (Google)","Airport (Foursquare)","r"), lwd=c(2,2,2,2,1), col=c("#cc3434","#2c9db7","#cc3434","#2c9db7","#333333"), lty=c(1,1,2,2,3))
dev.off()

word="PetStore"
focus <- data[data[,5] == word,]
xy <- focus[,2:1]
pp <- as.ppp(xy, w)
L <- Lest(pp)
lines(L$iso, col='green')


# loop through all ngrams and calculate Ripley's L values
for (i in 1:length(words)) {
	word <- as.vector(words[i])

	ripley[i,1] <- word
	focus <- data[data[,3] == word,]
	if (length(focus[,1]) > 9) {
		xy <- focus[,2:1]
		pp <- as.ppp(xy, w)
		K <- Kest(pp,correction="Ripley")

		ripley[i,2:514] <- as.numeric(L$iso-L$r)
		#prev <- 1
		#curr <- f
		#for (j in 1:10) {
		#	ripley[i,j+1] <- mean(L[prev:curr]$iso-L[prev:curr]$r)
		#	prev <- curr
		#	curr <- curr + f
		#}
		#ripley[i,12] <- kurtosis(L$iso-L$r)
		#ripley[i,13] <- skewness(L$iso-L$r)
	}
}

# write out CSV containing ngram, mean lat, mean lng, standard distance
#colnames(ripley) <- c('type','ripley1','ripley2','ripley3','ripley4','ripley5','ripley6','ripley7','ripley8','ripley9','ripley10','kurtosis','skewness')
write.table(ripley,file='ripleysL_foursquare.csv', sep=',',quote=FALSE, row.names = FALSE, col.names = FALSE)



############################# EXPLORE AND VISUALIZE ################################33

fs <- read.csv('ripleysL_foursquare.csv', header=T)
gp <- read.csv('ripleysL_google.csv', header=T)
fs <- na.omit(fs)
gp <- na.omit(gp)
plot(as.numeric(fs[fs$type == "Bar",2:11]), type="l", lwd=2, col='#660000', ylim=range(0,0.7))
lines(as.numeric(gp[gp$type == "bar",2:11]), type="l", lwd=2, col='#990000')

lines(as.numeric(fs[fs$type == "MovieTheater",2:11]), lwd=2, col='#006600')
lines(as.numeric(gp[gp$type == "movie_theater",2:11]), lwd=2, col='#009900')

as.numeric(fs[fs$type == "Bar",12:13])
as.numeric(gp[gp$type == "bar",12:13])

as.numeric(fs[fs$type == "MovieTheater",12:13])
as.numeric(gp[gp$type == "movie_theater",12:13])