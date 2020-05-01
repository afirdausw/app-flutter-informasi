<?php
    date_default_timezone_set('Asia/Jakarta');
    
    session_start();
    
    $host = 'localhost';
    $user = 'root';
    $pass = '';
    $db   = 'onlenkan_informasi';

    $connect = mysqli_connect($host, $user, $pass, $db) or die ("Error establishing to database!");

    function tanggal($str) {
        $tr   = trim($str);
        $str  = str_replace(
                    array('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'),
                    array('Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jum\'at', 'Sabtu', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'),
                    $tr
                );
        return $str;
    }
?>