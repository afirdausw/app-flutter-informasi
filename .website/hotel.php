<?php
    $page = 'Tempat';

    include 'php/atas.php';
?>

<a class="button-top" href="hotel-tambah.php" data-toggle="tooltip" title="Tambah Data"> <ion-icon name="add-outline"></ion-icon> </a>

<h1 class="title">Data Hotel</h1>

<?php include 'pesan.php' ?>

<div class="gallery">
    <?php
        $query = mysqli_query($connect, "SELECT * FROM hotel ORDER BY id_hotel DESC");
        while ($value = mysqli_fetch_array($query)) {
    ?>
    <a class="media" href="hotel-detail.php?link=<?= $value['link'] ?>">
        <div class="wrap-img">
            <img src="uploads/hotel/<?= $value['gambar'] ?>" alt="<?= $value['nama_hotel'] ?>">
            <span>
                <ion-icon name="time-outline"></ion-icon>
                <?= tanggal(date('d M Y, H:i', strtotime($value['update_pada']))) ?>
            </span>
        </div>
        <h3><?= $value['nama_hotel'] ?></h3>
        <h4><?= $value['alamat'] ?></h4>
    </a>
    <?php } ?>
</div>

<?php include 'php/bawah.php'; ?>