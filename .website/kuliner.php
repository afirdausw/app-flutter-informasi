<?php
    $page = 'Tempat';

    include 'php/atas.php';
?>

<a class="button-top" href="kuliner-tambah.php" data-toggle="tooltip" title="Tambah Data"> <ion-icon name="add-outline"></ion-icon> </a>

<h1 class="title">Data Kuliner</h1>

<?php include 'pesan.php' ?>

<div class="gallery">
    <?php
        $query = mysqli_query($connect, "SELECT * FROM kuliner ORDER BY id_kuliner DESC");
        while ($value = mysqli_fetch_array($query)) {
    ?>
    <a class="media" href="kuliner-detail.php?link=<?= $value['link'] ?>">
        <div class="wrap-img">
            <img src="uploads/kuliner/<?= $value['gambar'] ?>" alt="<?= $value['nama_kuliner'] ?>">
            <span>
                <ion-icon name="time-outline"></ion-icon>
                <?= tanggal(date('d M Y, H:i', strtotime($value['update_pada']))) ?>
            </span>
        </div>
        <h3><?= $value['nama_kuliner'] ?></h3>
        <h4><?= $value['alamat'] ?></h4>
    </a>
    <?php } ?>
</div>

<?php include 'php/bawah.php'; ?>