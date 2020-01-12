
library(lsa)

# working directory
setwd('~/Research_Projects/PlaceTypeAlignment/SpatialAnalysis')

# load datasets
ann <- read.csv('comparison_ANN.csv',header=T, row.names=1)
ripley <- read.csv('comparison_ripleysL.csv',header=T, row.names=1)
sdist <- read.csv('comparison_standard_distance.csv',header=T, row.names=1)

# Empty matrix for results
m <- matrix(,ncol=ncol(ann), nrow=nrow(ann))
rownames(m) <- rownames(ann)
colnames(m) <- colnames(ann)


for(i in 1:ncol(ann)) {
	a <- ann[,i]
	b <- 1 - ripley[,i]
	c <- sdist[,i]
	f_name <- colnames(ann)[i]
	for(j in 1:nrow(ann)) {
		if (!is.null(a[j]) & !is.null(b[j]) & !is.null(c[j])) {
			g_name <- rownames(ann)[j]
			a_n <- (a[j]-min(na.omit(a)))/(max(na.omit(a))-min(na.omit(a)))
			b_n <- (b[j]-min(na.omit(b)))/(max(na.omit(b))-min(na.omit(b)))
			c_n <- (c[j]-min(na.omit(c)))/(max(na.omit(c))-min(na.omit(c)))

			n <- (a_n + b_n + c_n)/3 
			m[j,i] <- n
			#print(f_name)
			#print(g_name)
			#print(n)
			#print("==============")
		}
	}
}

write.table(m,file='all_compare.csv', sep=',', quote=FALSE, row.names = TRUE, col.names = NA)
