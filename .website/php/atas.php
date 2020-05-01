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

                <a <?= isset($page) && $page == 'Galeri' ? "class='active'" : '' ?> href="galeri.php"> <ion-icon name="image-outline"></ion-icon> Galeri</a>
                <a <?= isset($page) && $page == 'Berita' ? "class='active'" : '' ?> href="berita.php"> <ion-icon name="newspaper-outline"></ion-icon> Berita</a>
                <a <?= isset($page) && $page == 'Pengumuman' ? "class='active'" : '' ?> href="pengumuman.php"> <ion-icon name="chatbox-ellipses-outline"></ion-icon> Pengumuman</a>

                <div class="divider"></div>

                <a <?= isset($page) && $page == 'Tentang' ? "class='active'" : '' ?> href="tentang.php"> <ion-icon name="information-circle-outline"></ion-icon> Tentang</a>
                <a <?= isset($page) && $page == 'Pengguna' ? "class='active'" : '' ?> href="pengguna.php"> <ion-icon name="people-outline"></ion-icon> Pengguna</a>

                <div class="divider"></div>

                <a href="keluar.php"> <ion-icon name="log-out-outline"></ion-icon> Logout</a>
            </div>
        </div>

        <div class="wrap-right">
            <nav>
                <form action="#" method="get">
                    <ion-icon name="search-outline"></ion-icon>
                    <input type="text" placeholder="Cari apapun disini...">
                </form>

                <ul>
                    <a href="#"> <li> <ion-icon name="notifications-outline"></ion-icon> </li> </a>
                    <a href="#"> <li> <ion-icon name="cog-outline"></ion-icon> </li> </a>
                    <a href="#"> <li> <img class="default" src="img/user-img.png" alt="User image"> </li> </a>
                </ul>
            </nav>
