<?php
    $page = 'Berita';

    include 'php/atas.php';

    $link  = $_GET['judul'];

    $query = mysqli_query($connect, "SELECT * FROM berita WHERE link='$link'");
    $value = mysqli_fetch_array($query);
?>

<a class="button-top small-icon" href="berita.php"> <ion-icon name="arrow-back-outline"></ion-icon> </a>
<a class="button-top small-icon edit" href="berita-ubah.php?judul=<?= $value['link'] ?>&berita=<?= $value['id_berita'] ?>"> <ion-icon name="pencil-outline"></ion-icon> </a>
<a class="button-top small-icon delete" href="action-berita.php?action=hapus&judul=<?= $value['link'] ?>&berita=<?= $value['id_berita'] ?>" onClick="return confirm('Yakin ingin menghapus data? \nData tersebut tidak bisa di kembalikan lagi.')"> <ion-icon name="trash-outline"></ion-icon> </a>

<h1 class="title"><?= $value['judul'] ?></h1>

<div class="back-content">
    <div class="row berita-detail pb-3">
        <div class="col-12 col-sm-4">
            <img id="img-berita" src="uploads/berita/<?= $value['gambar'] ?>" alt="<?= $value['judul'] ?>" title="<?= $value['judul'] ?>">

            <small class="d-block mb-1 text-secondary">Waktu posting :</small>
            <span>
                <ion-icon name="time-outline"></ion-icon>
                <?= tanggal(date('D, d M Y, H:i', strtotime($value['tanggal_pos']))) ?>
            </span>

            <small class="d-block mb-1 mt-3 text-secondary">Oleh :</small>
            <span>
                <ion-icon name="person-outline"></ion-icon>
                Mas Admin
            </span>

            <small class="d-block mb-1 mt-3 text-secondary">Dilihat :</small>
            <span>
                <ion-icon name="eye-outline"></ion-icon>
                13 kali
            </span>
        </div>
        <div class="col-12 col-sm-8">
            <p><?= $value['konten'] ?></p>
            <div class="mt-3 d-block">&nbsp;</div>
            <?php
                $list = explode(',', $value['tag']);

                foreach($list as $value) {
                    echo "<span class='tags'>$value</span>";
                }
            ?>
        </div>

    </div>
</div>

<?php include 'php/bawah.php'; ?>