<?php
    $page = 'Berita';

    include 'php/atas.php';
?>

<a class="button-top small-icon" href="berita.php" data-toggle="tooltip" title="Kembali"> <ion-icon name="arrow-back-outline"></ion-icon> </a>

<h1 class="title">Tambah Berita</h1>

<?php include 'pesan.php' ?>

<div class="back-content">
    <form action="action-berita.php" class="form pb-3" method="post" enctype="multipart/form-data" autocomplete="off">
        <input type="hidden" name="action" value="tambah">
        <div class="row">
            <div class="col-12 col-sm-4">
                <label for="img-change">Gambar Berita</label>
                <div id="img">
                    <ion-icon name="image-outline"></ion-icon>
                </div>
                <img id="img-berita" class="d-none" src="img/images.png" alt="Gambar Tajuk Berita">
                <input type="file" id="img-change" accept="image/*" name="gambar">
            </div>
            <div class="col-12 col-sm-8">
                <label class="d-block mb-1">Kategori</label>
                <div class="custom-control custom-radio custom-control-inline">
                    <input type="radio" class="custom-control-input" id="nasional" name="kategori" value="Nasional" checked="">
                    <label class="custom-control-label" for="nasional">Nasional</label>
                </div>
                <div class="custom-control custom-radio custom-control-inline">
                    <input type="radio" class="custom-control-input" id="kab" name="kategori" value="Kabupaten">
                    <label class="custom-control-label" for="kab">Kabupaten</label>
                </div>
                <div class="custom-control custom-radio custom-control-inline">
                    <input type="radio" class="custom-control-input" id="kota" name="kategori" value="Kota">
                    <label class="custom-control-label" for="kota">Kota</label>
                </div>
                
                <label for="judul" class="d-block mt-3">Judul Berita</label>
                <input type="text" class="form-control" id="judul" name="judul">

                <label for="konten">Konten</label>
                <textarea class="form-control" id="konten" rows="15" name="konten"></textarea>

                <label for="tag">Tag</label>
                <input type="text" class="form-control mb-1" id="tag" name="tag">
                <small class="text-secondary d-block mb-4">Gunakan pemisah tanda koma <b>(,)</b> untuk tag lebih dari satu</small>

                <button type="submit" class="btn btn-success mr-sm-1">Tambah</button>
                <button type="reset" class="btn btn-danger" onClick="bersihkan()">Bersihkan</button>
            </div>

        </div>
    </form>
</div>

<?php include 'php/bawah.php'; ?>

<script type="text/javascript">
    $("#img-change").change(function(){
        readURL(this);
    });

    function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();

            reader.onload = function (e) {
                $('#img-berita').attr('src', e.target.result);
                $('#img-berita').addClass('d-block').removeClass('d-none');
                $('#img').addClass('d-none');
            }
            reader.readAsDataURL(input.files[0]);
        }
    }
    
    function bersihkan() {
        $('#img-berita').removeClass('d-block').addClass('d-none');
        $('#img').removeClass('d-none');
    }
</script>