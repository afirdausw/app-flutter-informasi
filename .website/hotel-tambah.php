<?php
    $page = 'Tempat';

    include 'php/atas.php';
?>

<a class="button-top small-icon" href="hotel.php" data-toggle="tooltip" title="Kembali"> <ion-icon name="arrow-back-outline"></ion-icon> </a>

<h1 class="title">Tambah Data Hotel</h1>

<?php include 'pesan.php' ?>

<div class="back-content">
    <form action="action-hotel.php" class="form pb-3" method="post" enctype="multipart/form-data" autocomplete="off">
        <input type="hidden" name="action" value="tambah">
        <div class="row">
            <div class="col-12 col-sm-4">
                <label for="img-change">Gambar Hotel</label>
                <div id="img">
                    <ion-icon name="image-outline"></ion-icon>
                </div>
                <img id="image" class="d-none" src="img/images.png" alt="Gambar Tajuk Hotel">
                <input type="file" id="img-change" accept="image/*" name="gambar">
            </div>
            <div class="col-12 col-sm-8">
                <label for="nama" class="d-block">Nama Hotel</label>
                <input type="text" class="form-control" id="nama" name="nama">

                <label for="alamat">Alamat</label>
                <textarea class="form-control" id="alamat" rows="5" name="alamat"></textarea>

                <label for="telepon" class="d-block mt-3">Telepon</label>
                <input type="text" class="form-control" id="telepon" name="telepon">

                <label for="google_maps" class="d-block mt-3">Link Google Maps</label>
                <input type="text" class="form-control" id="google_maps" name="google_maps" placeholder="https://goo.gl/maps/xxxxxxx">


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
                $('#image').attr('src', e.target.result);
                $('#image').addClass('d-block').removeClass('d-none');
                $('#img').addClass('d-none');
            }
            reader.readAsDataURL(input.files[0]);
        }
    }
    
    function bersihkan() {
        $('#image').removeClass('d-block').addClass('d-none');
        $('#img').removeClass('d-none');
    }
</script>