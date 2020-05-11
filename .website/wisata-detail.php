<?php
    $page = 'Tempat';

    include 'php/atas.php';

    $link  = $_GET['link'];

    $query = mysqli_query($connect, "SELECT * FROM wisata WHERE link='$link'");
    $value = mysqli_fetch_array($query);
?>

<a class="button-top small-icon" href="wisata.php" data-toggle="tooltip" title="Kembali"> <ion-icon name="arrow-back-outline"></ion-icon> </a>
<a class="button-top small-icon edit" href="wisata-ubah.php?link=<?= $value['link'] ?>&wisata=<?= $value['id_wisata'] ?>" data-toggle="tooltip" title="Ubah Data"> <ion-icon name="pencil-outline"></ion-icon> </a>
<a class="button-top small-icon delete" href="action-wisata.php?action=hapus&link=<?= $value['link'] ?>&wisata=<?= $value['id_wisata'] ?>" data-toggle="tooltip" title="Hapus Data" onClick="return confirm('Yakin ingin menghapus data? \nData tersebut tidak bisa di kembalikan lagi.')"> <ion-icon name="trash-outline"></ion-icon> </a>

<h1 class="title"><?= $value['nama_wisata'] ?></h1>

<div class="back-content">
    <div class="row data-detail pb-3">
        <div class="col-12 col-sm-7">
            <img id="img-berita" src="uploads/wisata/<?= $value['gambar'] ?>" alt="<?= $value['nama_wisata'] ?>" title="<?= $value['nama_wisata'] ?>">

            <small class="d-block mb-1 text-center text-secondary">File gambar : <?= $value['gambar'] ?></small>
        </div>
        <div class="col-12 col-sm-5">
            <small class="d-block mb-1 text-secondary"><ion-icon name="tv-outline"></ion-icon> Nama Wisata :</small>
            <h5><?= $value['nama_wisata'] ?></h5>
            
            <small class="d-block mb-1 mt-4 text-secondary"><ion-icon name="compass-outline"></ion-icon> Alamat :</small>
            <h5><?= $value['alamat'] != '' ? $value['alamat'] : '-' ?></h5>
            
            <small class="d-block mb-1 mt-4 text-secondary"><ion-icon name="call-outline"></ion-icon> Telepon :</small>
            <h5><?= $value['telepon'] != '' ? $value['telepon'] : '-' ?></h5>
            
            <small class="d-block mb-1 mt-4 text-secondary"><ion-icon name="map-outline"></ion-icon> Link Google Maps :</small>
            <h5><?= $value['google_maps'] != '' ? "<a href='$value[google_maps]' target='_blank'>$value[google_maps]</a>" : '-' ?></h5>
            
            <small class="d-block mb-1 mt-4 text-secondary"><ion-icon name="time-outline"></ion-icon> Update terakhir :</small>
            <h5><?= tanggal(date('D, d M Y, H:i', strtotime($value['update_pada']))) ?></h5>
        </div>
    </div>
</div>

<?php include 'php/bawah.php'; ?>