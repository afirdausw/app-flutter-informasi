<?php
    $page = 'Tempat';

    include 'php/atas.php';

    $link  = $_GET['link'];
    $id    = $_GET['wisata'];

    $query = mysqli_query($connect, "SELECT * FROM wisata WHERE link='$link' AND id_wisata='$id'");
    $value = mysqli_fetch_array($query);
?>

<a class="button-top small-icon" href="wisata.php" data-toggle="tooltip" title="Kembali"> <ion-icon name="arrow-back-outline"></ion-icon> </a>

<h1 class="title">Ubah Data Wisata</h1>

<?php include 'pesan.php' ?>

<div class="back-content">
    <form action="action-wisata.php" class="form pb-3" method="post" enctype="multipart/form-data" autocomplete="off">
        <input type="hidden" name="action" value="ubah">
        <input type="hidden" name="id" value="<?= $id ?>">
        <div class="row">
            <div class="col-12 col-sm-4">
                <label for="img-change">Gambar Wisata</label>
                <img id="image" src="uploads/wisata/<?= $value['gambar'] ?>" alt="<?= $value['nama_wisata'] ?>" title="<?= $value['nama_wisata'] ?>">
                <input type="file" id="img-change" accept="image/*" name="gambar">
            </div>
            <div class="col-12 col-sm-8">
                <label for="nama" class="d-block">Nama Wisata</label>
                <input type="text" class="form-control" id="nama" name="nama" value="<?= $value['nama_wisata'] ?>">

                <label for="alamat">Alamat</label>
                <textarea class="form-control" id="alamat" rows="5" name="alamat"><?= $value['alamat'] ?></textarea>

                <label for="telepon" class="d-block mt-3">Telepon</label>
                <input type="text" class="form-control" id="telepon" name="telepon" value="<?= $value['telepon'] ?>">

                <label for="google_maps" class="d-block mt-3">Link Google Maps</label>
                <input type="text" class="form-control" id="google_maps" name="google_maps" value="<?= $value['google_maps'] ?>">


                <button type="submit" class="btn btn-success mr-sm-1">Simpan</button>
                <button type="reset" class="btn btn-danger" onClick="bersihkan()">Bersihkan</button>
            </div>

        </div>
    </form>
</div>

<?php include 'php/bawah.php'; ?>

<script type="text/javascript">
    var imgfile = "uploads/wisata/<?= $value['gambar']; ?>";
    
    $("#img-change").change(function(){
        readURL(this);
    });

    function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
                $('#image').attr('src', e.target.result);
            }
            reader.readAsDataURL(input.files[0]);
        }
    }
    
    function bersihkan() {
        $('#image').attr('src', imgfile);
    }
</script>