<?php

	$ftypes = array();
	$gtypes = array();
	$handle = fopen("google_types.csv","r");

	if ($handle) {
	    while (($line = fgets($handle)) !== false) {
	    	$t = explode(",",trim($line));
	    	for($i=1;$i<count($t);$i++) {
	    		if(!isset($gtypes[$t[$i]]) && $t[$i] != 'establishment' && $t[$i] != 'point_of_interest') {
	    			$gtypes[$t[$i]] = 0;
	    		}
	    	}
	    }
	    fclose($handle);
	}

	ksort($gtypes);

	//var_dump($gtypes);
	//exit;


	$handle = fopen("google_types.csv","r");
	if ($handle) {
	    while (($line = fgets($handle)) !== false) {
	    	$t = explode(",",trim($line));
	    	/*foreach($t as $k=>&$v) {
	    		if ($v == 'establishment' || $v == 'point_of_interest')
	    			$v = null;
	    	} */
	    	for($i=1;$i<count($t);$i++) {

	    		if(!isset($ftypes[$t[$i]])) {
	    			if ($t[$i] != 'establishment' && $t[$i] != 'point_of_interest')
	    				$ftypes[$t[$i]] = $gtypes;
	    		}
	    		for($j=1;$j<count($t);$j++) {
	    			if ($t[$i] != 'establishment' && $t[$i] != 'point_of_interest' && $t[$j] != 'establishment' && $t[$j] != 'point_of_interest')
		    			$ftypes[$t[$i]][$t[$j]]++;
		    	}
	    	}
	    }
	    fclose($handle);
	}

	ksort($ftypes);

	$file = fopen('google_types_dist.csv','w');
	foreach($gtypes as $k1=>$v1) {
		fwrite($file, ",".$k1);
	}
	fwrite($file,"\n");
	foreach($ftypes as $k1=>$v1) {
		fwrite($file, $k1);
		$max = max($v1);
		foreach($v1 as $k2=>$v2) {
			fwrite($file, ",".$v2/$max);
		}
		fwrite($file,"\n");
	}

	//var_dump($ftypes);


	/* 

	mydata <- read.csv('google_types_dist.csv', header=T)
	rownames(mydata) <- mydata[,1]
	d <- dist(mydata, method = "euclidean")
	fit <- isoMDS(d, k=2) # euclidean distances between the rows
	fit <- cmdscale(d,eig=TRUE, k=2) # k is the number of dim
	fit # view results

	# plot solution
	x <- fit$points[,1]
	y <- fit$points[,2]
	plot(x, y, xlab="Coordinate 1", ylab="Coordinate 2", main="Metric MDS", type="n", xlim=range(-0.5,0), ylim=range(-0.2,0.2))
	text(x, y, labels = row.names(mydata), cex=.7)

	# WARDS
	mydata <- read.csv('google_types_dist.csv', header=T)
	rownames(mydata) <- mydata[,1]
	d <- dist(mydata, method = "euclidean")
	fit <- hclust(d, method="ward") 
	plot(fit)

	*/
?>
