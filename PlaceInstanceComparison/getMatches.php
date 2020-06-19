<?php

	$dbconn = pg_connect("host=localhost port=5432 dbname=X user=X password=X");
 	$query = "SELECT id from md order by checkins_count desc";
 	$result = pg_query($query) or die(pg_last_error());

 	$cnt = 0;
 	$file = fopen("matches_full.csv","w");
 	fwrite($file, "fid,gid,fname,gname,distm,levp,fcat,gcats\n");
 	while($row = pg_fetch_object($result)) {
 		findMatch($row->id);
 	}
 	fclose($file);

 	function findMatch($id) {
 		global $file;
 		global $cnt;
 		$cnt++;
 		echo round($cnt/967703*100000)/1000 . "%\n";

 		$query = <<<EOD
 		SELECT md.id as fid, md.name as fname, g_md.id as gid, g_md.name as gname, st_distance_sphere(md.geom, g_md.geom) as dist, levenshtein(lower(md.name), lower(g_md.name))::float4/char_length(md.geom)::float as lev, f_catsh.name as fcat, g_md.types as gcats
		FROM md, g_md, f_catsh   
		WHERE md.id = '$id'
			AND md.categories = f_catsh.id
			AND levenshtein(lower(md.name), lower(g_md.name))::float4/char_length(md.geom)::float <= 0.05
			AND st_dwithin(md.geom, g_md.geom, 0.001)   
		ORDER BY lev, st_distance(md.geom, g_md.geom)
		LIMIT 1
EOD;
		$result = pg_query($query) or die(pg_last_error());
		while($row = pg_fetch_object($result)) {
			if ($row->lev == 0)
	 			fwrite($file, $row->fid."|".$row->gid."|".$row->fname."|".$row->gname."|".$row->dist."|".$row->lev."|".$row->fcat."|".$row->gcats."\n");
	 	}
 	}

/*
create table md (
	id varchar(32),
	name varchar(500),
	categories varchar[],
	lat float8,
	lng float8,
	ts timestamp without time zone,
	checkins_count int,
	geom geometry
);
create index md_gidx on md using gist(geom);

create table g_md (
	id varchar(32),
	name varchar(500),
	types varchar(500),
	lat float8,
	lng float8,
	ts timestamp without time zone,
	geom geometry
);
create index g_md_gidx on g_md using gist(geom);


create table f_catsh (
	id varchar(32),
	name varchar(500)
);
*/

?>
