<?php
    $page = 'Berita';

    include 'php/atas.php';

    $link  = $_GET['judul'];
    $id    = $_GET['berita'];

    $query = mysqli_query($connect, "SELECT * FROM berita WHERE link='$link' AND id_berita='$id'");
    $value = mysqli_fetch_array($query);
?>

<a class="button-top small-icon" href="berita.php" data-toggle="tooltip" title="Kembali"> <ion-icon name="arrow-back-outline"></ion-icon> </a>

<h1 class="title">Ubah Berita</h1>

<?php include 'pesan.php' ?>

<div class="back-content">
    <form action="action-berita.php" class="form pb-3" method="post" enctype="multipart/form-data" autocomplete="off">
        <input type="hidden" name="action" value="ubah">
        <input type="hidden" name="id" value="<?= $value['id_berita'] ?>">
        <div class="row">
            <div class="col-12 col-sm-4">
                <label for="judul">Gambar Berita</label>
                <img id="img-berita" src="uploads/berita/<?= $value['gambar'] ?>" alt="<?= $value['judul'] ?>" title="<?= $value['judul'] ?>">
                <input type="file" id="img-change" accept="image/*" name="gambar">
            </div>
            <div class="col-12 col-sm-8">
                <label class="d-block mb-1">Kategori</label>
                <div class="custom-control custom-radio custom-control-inline">
                    <input type="radio" class="custom-control-input" id="nasional" name="kategori" value="Nasional" <?= $value['kategori'] == 'Nasional' ? 'checked' : '' ?> >
                    <label class="custom-control-label" for="nasional">Nasional</label>
                </div>
                <div class="custom-control custom-radio custom-control-inline">
                    <input type="radio" class="custom-control-input" id="kab" name="kategori" value="Kabupaten" <?= $value['kategori'] == 'Kabupaten' ? 'checked' : '' ?>>
                    <label class="custom-control-label" for="kab">Kabupaten</label>
                </div>
                <div class="custom-control custom-radio custom-control-inline">
                    <input type="radio" class="custom-control-input" id="kota" name="kategori" value="Kota" <?= $value['kategori'] == 'Kota' ? 'checked' : '' ?>>
                    <label class="custom-control-label" for="kota">Kota</label>
                </div>
                
                <label for="judul" class="mt-3 d-block">Judul Berita</label>
                <input type="text" class="form-control" id="judul" name="judul" value="<?= $value['judul'] ?>">

                <label for="konten">Konten</label>
                <textarea class="form-control" id="konten" rows="15" name="konten"><?= $value['konten'] ?></textarea>

                <label for="tag">Tag</label>
                <input type="text" class="form-control mb-1" id="tag" name="tag" value="<?= $value['tag'] ?>">
                <small class="text-secondary d-block mb-4">Gunakan pemisah tanda koma <b>(,)</b> untuk tag lebih dari satu</small>

                <button type="submit" class="btn btn-success mr-sm-1">Simpan</button>
                <button type="reset" class="btn btn-danger" onClick="bersihkan()">Bersihkan</button>
            </div>

        </div>
    </form>
</div>

<?php include 'php/bawah.php'; ?>

<script type="text/javascript">
    var imgfile = "uploads/berita/<?= $value['gambar']; ?>";
    
    $("#img-change").change(function(){
        readURL(this);
    });

    function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
                $('#img-berita').attr('src', e.target.result);
                $('#img-berita').addClass('d-block').removeClass('d-none');
            }
            reader.readAsDataURL(input.files[0]);
        }
    }
    
    function bersihkan() {
        $('#img-berita').attr('src', imgfile);
    }
</script>