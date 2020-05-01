<?php
    include 'php/koneksi.php';

    if (!isset($_SESSION['onlenkan_info_id'])) {
        header('location: login.php');
    }
    
    $check = array(
        " " => "-",
        ":" => "",
        "," => "",
        "." => "",
        "/" => ""
    );

    if (isset($_POST['action'])) {
        $judul      = addslashes($_POST['judul']);
        $konten     = addslashes($_POST['konten']);
        $tag        = addslashes($_POST['tag']);

        $foto       = $_FILES['gambar']['name'];
        $temp       = $_FILES['gambar']['tmp_name'];

        $foto_file  = strtolower(strtr($judul, $check)).".jpg";
        $link       = strtolower(strtr($judul, $check));

        if ($_POST['action'] == 'tambah') {
            if (!empty($judul) || !empty($konten) || !empty($tag) || !empty($foto)) {
                $query = mysqli_query($connect, "INSERT INTO berita SET
                                                judul='$judul', konten='$konten', tag='$tag', gambar='$foto_file',
                                                tanggal_pos=NOW(), link='$link' ");
                copy($temp, "uploads/berita/". $foto_file);

                $_SESSION['info-pesan'] = '<b>Informasi</b> berita berhasil ditambahkan!';
                $_SESSION['info-status'] = 'success';
                header('location: berita.php');
            }
            else {
                $_SESSION['info-pesan'] = '<b>Kesalahan!</b> silahkan isi data dengan benar!';
                $_SESSION['info-status'] = 'danger';
                header('location: berita-tambah.php');
            }
        }

        else if ($_POST['action'] == 'tambah') {
            
        }
    }
    else if (isset($_GET['action'])) {

    }