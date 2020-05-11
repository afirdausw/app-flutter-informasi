<?php
    $page = 'Berita';

    include 'php/atas.php';
?>

<a class="button-top" href="berita-tambah.php" data-toggle="tooltip" title="Tambah Data"> <ion-icon name="add-outline"></ion-icon> </a>

<h1 class="title">Daftar Berita</h1>

<?php include 'pesan.php' ?>

<div class="back-content">
    <?php
        $query = mysqli_query($connect, "SELECT * FROM berita ORDER BY tanggal_pos DESC");
        while ($value = mysqli_fetch_array($query)) {
    ?>
    <div class="list-media">
        <img src="uploads/berita/<?= $value['gambar'] ?>" alt="<?= $value['judul'] ?>" title="<?= $value['judul'] ?>">
        <a class="list-body" href="berita-detail.php?judul=<?= $value['link'] ?>">
            <h5><?= $value['judul'] ?></h5>
            <p><?= $value['konten'] ?></p>
            <div class="d-flex justify-content-between align-items-end" style="margin-top: 10px">
                <small>
                    <ion-icon name="time-outline"></ion-icon>
                    <?= tanggal(date('D, d M Y, H:i', strtotime($value['tanggal_pos']))) ?>
                    
                    <ion-icon name="compass-outline" class="ml-4"></ion-icon>
                    <?= $value['kategori'] ?>
                    
                    <ion-icon name="eye-outline" class="ml-4"></ion-icon>
                    13 kali
                </small>
            </div>
        </a>
        <div class="wrap">
            <a class="button-top small-icon edit" href="berita-ubah.php?judul=<?= $value['link'] ?>&berita=<?= $value['id_berita'] ?>"> <ion-icon name="pencil-outline"></ion-icon> </a>
            <a class="button-top small-icon delete" href="action-berita.php?action=hapus&judul=<?= $value['link'] ?>&berita=<?= $value['id_berita'] ?>" onClick="return confirm('Yakin ingin menghapus data? \nData tersebut tidak bisa di kembalikan lagi.')"> <ion-icon name="trash-outline"></ion-icon> </a>
        </div>
    </div>
    <?php } ?>

</div>

<?php include 'php/bawah.php'; ?>