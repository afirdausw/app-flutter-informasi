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
                $query = mysqli_query($connect, "INSERT INTO hotel SET
                                                nama_hotel='$nama', alamat='$alamat', telepon='$telepon',
                                                gambar='$foto_file', google_maps='$maps',
                                                update_pada=NOW(), link='$link' ");
                copy($temp, "uploads/hotel/". $foto_file);

                $_SESSION['info-pesan']  = '<b>Informasi</b> data hotel berhasil ditambahkan!';
                $_SESSION['info-status'] = 'success';
                header('location: hotel.php');
            }
            else {
                $_SESSION['info-pesan']  = '<b>Kesalahan</b> silahkan isi data dengan benar!';
                $_SESSION['info-status'] = 'danger';
                header('location: hotel-tambah.php');
            }
        }
        
        else if ($_POST['action'] == 'ubah') {
            if (!empty($foto)) {
                $query = mysqli_query($connect, "UPDATE hotel SET
                                                nama_hotel='$nama', alamat='$alamat', telepon='$telepon',
                                                gambar='$foto_file', google_maps='$maps', update_pada=NOW(), link='$link'
                                                WHERE id_hotel='$id' ");
                copy($temp, "uploads/hotel/". $foto_file);
            }
            else {
                $query = mysqli_query($connect, "UPDATE hotel SET
                                                nama_hotel='$nama', alamat='$alamat', telepon='$telepon',
                                                google_maps='$maps', update_pada=NOW(), link='$link'
                                                WHERE id_hotel='$id' ");
            }
            
            if ($query) {
                $_SESSION['info-pesan']  = '<b>Informasi</b> data hotel berhasil diperbaharui';
                $_SESSION['info-status'] = 'success';
                header('location: hotel.php');
            }
            else {
                $_SESSION['info-pesan']  = '<b>Kesalahan</b> data gagal untuk diperbaharui!';
                $_SESSION['info-status'] = 'danger';
                header('location: hotel.php');
            }
        }
    }
    else if (isset($_GET['action'])) {
        if ($_GET['action'] == 'hapus') {
            $link   = $_GET['link'];
            $id     = $_GET['hotel'];
            
            $query  = mysqli_query($connect, "DELETE FROM hotel WHERE id_hotel='$id' AND link='$link' ");
            
            if ($query) {
                $_SESSION['info-pesan']  = '<b>Informasi</b> data hotel berhasil dihapus';
                $_SESSION['info-status'] = 'success';
                header('location: hotel.php');
            }
            else {
                $_SESSION['info-pesan']  = '<b>Kesalahan</b> data gagal untuk dihapus!';
                $_SESSION['info-status'] = 'danger';
                header('location: hotel.php');
            }
        }
    }