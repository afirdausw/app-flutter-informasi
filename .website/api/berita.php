<?php 
	include "../php/koneksi.php";

	if (isset($_POST['limit']) && $_POST['limit'] != '0') {
		$query = mysqli_query($connect, "SELECT * FROM berita ORDER BY tanggal_pos DESC LIMIT 0, $limit ");
	}
	else {
		$query = mysqli_query($connect, "SELECT * FROM berita ORDER BY tanggal_pos DESC");
	}

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