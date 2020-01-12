<?php

	$gpcats = array();
	$fscats = array();
	$matches = array();

	$cntdirect = 0;

	// GET LIST OF ALL POSSIBLE GOOGLE AND FOURSQUARE CATS IN OUR DATASET
	$handle = fopen("matches_full.csv","r");
	if ($handle) {
	    while (($line = fgets($handle)) !== false) {
	    	$l = explode("|",$line);

	    	if (count($l) > 7) {
		        $fcat = explode(",",trim($l[6]));
		        foreach($fcat as $f) {
		        	if(!array_key_exists($f, $fscats) && strlen($f) > 0) {
		        		$fscats[$f] = 0;
		        	} 
		        }
		        $gcat = explode(",",trim($l[7]));
		        foreach($gcat as $g) {
		        	if(!array_key_exists($g, $gpcats) && strlen($g) > 0) {
		        		$gpcats[$g] = 0;
		        	} 
		        }
		    }
	    }
	    fclose($handle);
	}




	ksort($gpcats);
	ksort($fscats);
	// var_dump($googlecats);

	$handle = fopen("matches_full.csv","r");
	if ($handle) {
	    while (($line = fgets($handle)) !== false) {
	    	$l = explode("|",$line);
	    	if (count($l) > 7) {
		        $fname = $l[2];
		        $gname = $l[3];
		        $fcat = explode(",",trim($l[6]));
		        $gcat = explode(",",trim($l[7]));
		        $f = $fcat[(count($fcat)-1)];
		        $g = $gcat[0];
		        //foreach($fcat as $f) {
			        if(!array_key_exists($f,$matches)) {
			        	$matches[$f] = $gpcats;
			        	//foreach($gcat as $g) {
			        		$matches[$f][$g] = 1;
			        	//}	
			        } else {
			        	//foreach($gcat as $g) {
			        		$matches[$f][$g] += 1;
			        	//}
			        }
			    //}
		    }
	    }
	    fclose($handle);
	}

	//var_dump($matches);

	//var_dump($matches['CoffeeShop']);

	$file = fopen('sim_matrix_single.csv','w');
	fwrite($file, "");
	foreach($gpcats as $k=>$a) {
		fwrite($file, ",".$k);
	}
	fwrite($file,"\n");
	foreach($matches as $k=>$v) {
		fwrite($file, $k);
		foreach($v as $a) {
			fwrite($file, ",".$a);
		}
		fwrite($file,"\n");
	}
	fclose($file); 

	//$poi = array("convience_store","bank","atm","gas_station","bakery","meal_delivery","meal_takeaway","place_of_worship","church");
	/* $poi = array("Gas Station");

	$file = fopen('vis/sankey.csv','w');
	fwrite($file,"source,target,value\n");
	foreach($matches as $k=>$v) {
		foreach($v as $key=>$val) {
			if ($val > 0 && $key != 'point_of_interest' && $key != 'establishment') {
			//echo $key . "\n";
				if ($val > 0 && in_array($k,$poi)) {
					if (!is_numeric($k)) {
						fwrite($file, $k);
						fwrite($file, ",".$key . ",".$val."\n");
					}
				}
			}
		}
	}
	fclose($file);
	*/
?>