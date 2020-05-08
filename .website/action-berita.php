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
        $id         = $_POST['id'];
        $kategori   = $_POST['kategori'];
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
                                                kategori='$kategori', tanggal_pos=NOW(), link='$link' ");
                copy($temp, "uploads/berita/". $foto_file);

                $_SESSION['info-pesan']  = '<b>Informasi</b> berita berhasil ditambahkan!';
                $_SESSION['info-status'] = 'success';
                header('location: berita.php');
            }
            else {
                $_SESSION['info-pesan']  = '<b>Kesalahan</b> silahkan isi data dengan benar!';
                $_SESSION['info-status'] = 'danger';
                header('location: berita-tambah.php');
            }
        }

        else if ($_POST['action'] == 'ubah') {
            if (!empty($foto)) {
                $query = mysqli_query($connect, "UPDATE berita SET
                                                judul='$judul', konten='$konten', tag='$tag', gambar='$foto_file',
                                                kategori='$kategori', tanggal_pos=NOW(), link='$link' WHERE id_berita='$id' ");
                copy($temp, "uploads/berita/". $foto_file);
            }
            else {
                $query = mysqli_query($connect, "UPDATE berita SET
                                                judul='$judul', konten='$konten', tag='$tag', kategori='$kategori', 
                                                tanggal_pos=NOW(), link='$link' WHERE id_berita='$id' ");
            }
            
            if ($query) {
                $_SESSION['info-pesan']  = '<b>Informasi</b> berita berhasil diperbaharui';
                $_SESSION['info-status'] = 'success';
                header('location: berita.php');
            }
            else {
                $_SESSION['info-pesan']  = '<b>Kesalahan</b> data gagal untuk diperbaharui!';
                $_SESSION['info-status'] = 'danger';
                header('location: berita.php');
            }
        }
    }
    else if (isset($_GET['action'])) {
        if ($_GET['action'] == 'hapus') {
            $id     = $_GET['berita'];
            $link   = $_GET['judul'];
            
            $query  = mysqli_query($connect, "DELETE FROM berita WHERE id_berita='$id' AND link='$link' ");
            
            if ($query) {
                $_SESSION['info-pesan']  = '<b>Informasi</b> berita berhasil dihapus';
                $_SESSION['info-status'] = 'success';
                header('location: berita.php');
            }
            else {
                $_SESSION['info-pesan']  = '<b>Kesalahan</b> data gagal untuk dihapus!';
                $_SESSION['info-status'] = 'danger';
                header('location: berita.php');
            }
        }
    }