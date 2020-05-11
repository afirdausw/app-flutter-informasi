<?php
    include 'koneksi.php';

    if (!isset($_SESSION['onlenkan_info_id'])) {
        header('location: login.php');
    }
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">

    <link rel="icon" href="img/logo.png">

    <link rel="stylesheet" href="plugin/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="css/main.css">

    <title><?= isset($page) ? $page : 'Administrator' ?> | Pusat Informasi x Onlenkan</title>
</head>

<body>
    <section class="wrap">
        <div class="wrap-left">
            <div class="menu-top">
                <img src="img/logo_biru.png" alt="Logo Onlenkan">
                <h4>Pusat Informasi</h4>
                <p>Kabupaten Probolinggo</p>
            </div>
            <div class="menu-bottom">
                <a <?= !isset($page) ? "class='active'" : '' ?> href="."> <ion-icon name="apps-outline"></ion-icon> Dashboard</a>

                <div class="divider"></div>

                <a <?= isset($page) && $page == 'Berita' ? "class='active'" : '' ?> href="berita.php"> <ion-icon name="newspaper-outline"></ion-icon> Berita</a>
                <a <?= isset($page) && $page == 'Video' ? "class='active'" : '' ?> href="video.php"> <ion-icon name="videocam-outline"></ion-icon> Video</a>
                <a <?= isset($page) && $page == 'Pengumuman' ? "class='active'" : '' ?> href="pengumuman.php"> <ion-icon name="chatbox-ellipses-outline"></ion-icon> Pengumuman</a>

                <div class="divider"></div>

                <div class="menu <?= isset($page) && $page == 'Tempat' ? "active" : '' ?>">
                    <ion-icon name="ellipsis-horizontal-outline"></ion-icon> Data Tempat
                    <ul class="menu-dropdown">
                        <a href="wisata.php"><li><ion-icon name="caret-forward-circle-outline"></ion-icon> Destinasi Wisata</li></a>
                        <a href="travel.php"><li><ion-icon name="caret-forward-circle-outline"></ion-icon> Travel</li></a>
                        <a href="hotel.php"><li><ion-icon name="caret-forward-circle-outline"></ion-icon> Hotel</li></a>
                        <a href="kuliner.php"><li><ion-icon name="caret-forward-circle-outline"></ion-icon> Kuliner</li></a>
                    </ul>
                </div>
                <div class="menu <?= isset($page) && $page == 'Info' ? "active" : '' ?>">
                    <ion-icon name="ellipsis-horizontal-outline"></ion-icon> Data Info
                    <ul class="menu-dropdown">
                        <a href="#"><li><ion-icon name="caret-forward-circle-outline"></ion-icon> Rumah Sakit</li></a>
                        <a href="#"><li><ion-icon name="caret-forward-circle-outline"></ion-icon> Sekolah</li></a>
                        <a href="#"><li><ion-icon name="caret-forward-circle-outline"></ion-icon> Pekerjaan</li></a>
                        <a href="#"><li><ion-icon name="caret-forward-circle-outline"></ion-icon> Lowongan</li></a>
                    </ul>
                </div>
                
                <div class="divider"></div>
                
                <a <?= isset($page) && $page == 'Pengaduan' ? "class='active'" : '' ?> href="pengaduan.php"> <ion-icon name="archive-outline"></ion-icon> Pengaduan </a>
                <a <?= isset($page) && $page == 'Tanya Jawab' ? "class='active'" : '' ?> href="tanya.php"> <ion-icon name="chatbubble-ellipses-outline"></ion-icon> Tanya Jawab </a>

                <div class="divider"></div>

                <a <?= isset($page) && $page == 'Pengguna' ? "class='active'" : '' ?> href="pengguna.php"> <ion-icon name="people-outline"></ion-icon> Pengguna</a>
                <a href="keluar.php"> <ion-icon name="log-out-outline"></ion-icon> Logout</a>
            </div>
        </div>

        <div class="wrap-right">
            <nav>
                <form action="cari.php" method="get">
                    <ion-icon name="search-outline"></ion-icon>
                    <input type="text" name="cari" placeholder="Cari apapun disini...">
                    <input type="submit" value="Submit" class="d-none">
                </form>

                <ul>
                    <a href="#"> <li> <ion-icon name="notifications-outline"></ion-icon> </li> </a>
                    <a href="#" data-toggle="tooltip" title="Pengaturan"> <li> <ion-icon name="cog-outline"></ion-icon> </li> </a>
                    <a href="#" data-toggle="tooltip" title="Akun Profil"> <li> <img class="default" src="img/user-img.png" alt="User image"> </li> </a>
                </ul>
            </nav>
