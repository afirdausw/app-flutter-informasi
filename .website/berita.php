<?php
    $page = 'Berita';

    include 'php/atas.php';
?>

<a class="button-top" href="berita-tambah.php"> <ion-icon name="add-outline"></ion-icon> </a>

<h1 class="title">Daftar Berita</h1>

<?php include 'pesan.php' ?>

<div class="back-content">
    <?php
        $query = mysqli_query($connect, "SELECT * FROM berita ORDER BY id_berita DESC");
        while ($value = mysqli_fetch_array($query)) {
    ?>
    <div class="list-media">
        <img src="uploads/berita/<?= $value['gambar'] ?>" alt="<?= $value['judul'] ?>" title="<?= $value['judul'] ?>">
        <div class="list-body">
            <h5><?= $value['judul'] ?></h5>
            <p><?= $value['konten'] ?></p>
            <div class="d-flex justify-content-between align-items-end" style="margin-top: 10px">
                <small>
                    <ion-icon name="time-outline"></ion-icon>
                    <?= tanggal(date('D, d M Y, H:i', strtotime($value['tanggal_pos']))) ?>
                </small>
                <a href="berita-detail.php?judul=<?= $value['link'] ?>"> Selengkapnya <ion-icon name="arrow-forward-outline"></ion-icon> </a>
            </div>
        </div>
    </div>
    <?php } ?>

</div>

<?php include 'php/bawah.php'; ?>