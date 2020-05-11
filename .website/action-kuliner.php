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
        "-" => "",
        "/" => ""
    );

    if (isset($_POST['action'])) {
        $id         = $_POST['id'];
        $nama       = addslashes($_POST['nama']);
        $alamat     = addslashes($_POST['alamat']);
        $telepon    = addslashes($_POST['telepon']);
        $maps       = addslashes($_POST['google_maps']);

        $foto       = $_FILES['gambar']['name'];
        $temp       = $_FILES['gambar']['tmp_name'];

        $foto_file  = strtolower(strtr($nama, $check)).".jpg";
        $link       = strtolower(strtr($nama, $check));

        if ($_POST['action'] == 'tambah') {
            if (!empty($nama) || !empty($alamat) || !empty($tag) || !empty($foto)) {
                $query = mysqli_query($connect, "INSERT INTO kuliner SET
                                                nama_kuliner='$nama', alamat='$alamat', telepon='$telepon',
                                                gambar='$foto_file', google_maps='$maps',
                                                update_pada=NOW(), link='$link' ");
                copy($temp, "uploads/kuliner/". $foto_file);

                $_SESSION['info-pesan']  = '<b>Informasi</b> data kuliner berhasil ditambahkan!';
                $_SESSION['info-status'] = 'success';
                header('location: kuliner.php');
            }
            else {
                $_SESSION['info-pesan']  = '<b>Kesalahan</b> silahkan isi data dengan benar!';
                $_SESSION['info-status'] = 'danger';
                header('location: kuliner-tambah.php');
            }
        }
        
        else if ($_POST['action'] == 'ubah') {
            if (!empty($foto)) {
                $query = mysqli_query($connect, "UPDATE kuliner SET
                                                nama_kuliner='$nama', alamat='$alamat', telepon='$telepon',
                                                gambar='$foto_file', google_maps='$maps', update_pada=NOW(), link='$link'
                                                WHERE id_kuliner='$id' ");
                copy($temp, "uploads/kuliner/". $foto_file);
            }
            else {
                $query = mysqli_query($connect, "UPDATE kuliner SET
                                                nama_kuliner='$nama', alamat='$alamat', telepon='$telepon',
                                                google_maps='$maps', update_pada=NOW(), link='$link'
                                                WHERE id_kuliner='$id' ");
            }
            
            if ($query) {
                $_SESSION['info-pesan']  = '<b>Informasi</b> data kuliner berhasil diperbaharui';
                $_SESSION['info-status'] = 'success';
                header('location: kuliner.php');
            }
            else {
                $_SESSION['info-pesan']  = '<b>Kesalahan</b> data gagal untuk diperbaharui!';
                $_SESSION['info-status'] = 'danger';
                header('location: kuliner.php');
            }
        }
    }
    else if (isset($_GET['action'])) {
        if ($_GET['action'] == 'hapus') {
            $link   = $_GET['link'];
            $id     = $_GET['kuliner'];
            
            $query  = mysqli_query($connect, "DELETE FROM kuliner WHERE id_kuliner='$id' AND link='$link' ");
            
            if ($query) {
                $_SESSION['info-pesan']  = '<b>Informasi</b> data kuliner berhasil dihapus';
                $_SESSION['info-status'] = 'success';
                header('location: kuliner.php');
            }
            else {
                $_SESSION['info-pesan']  = '<b>Kesalahan</b> data gagal untuk dihapus!';
                $_SESSION['info-status'] = 'danger';
                header('location: kuliner.php');
            }
        }
    }