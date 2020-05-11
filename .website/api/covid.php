<?php 
	include "../php/koneksi.php";

	
    $query = mysqli_query($connect, "SELECT * FROM covid_19");

	$json = array();
	
	while($row = mysqli_fetch_assoc($query)){
		$json[] = $row;
	}
	
	$rest = array(
		'error' => false,
		'message' => "message",
		'semua' => $json
	); 
	
	echo json_encode($rest);
	
	mysqli_close($connect);