<?php include 'php/atas.php'; ?>

<h1 class="title">Dashboard</h1>

<?php
    $covid = mysqli_fetch_array(mysqli_query($connect, "SELECT * FROM covid_19"));
?>

<span class="text-white d-block mb-2"><ion-icon name="time-outline"></ion-icon> <?= tanggal(date('D, d M Y, H:i:s', strtotime($covid['update_terakhir']))) ?></span>

<div class="row covid">
    <div class="col bg-white">
        Positif
        <h5><?= $covid['positif'] ?> <small>Orang</small></h5>
    </div>
    <div class="col bg-white">
        Sembuh
        <h5><?= $covid['sembuh'] ?> <small>Orang</small></h5>
    </div>
    <div class="col bg-white">
        Meninggal
        <h5><?= $covid['meninggal'] ?> <small>Orang</small></h5>
    </div>
    <div class="col bg-white">
        ODP
        <h5><?= $covid['odp'] ?> <small>Orang</small></h5>
    </div>
    <div class="col bg-white">
        PDP
        <h5><?= $covid['pdp'] ?> <small>Orang</small></h5>
    </div>
</div>

<a class="btn text-white badge badge-secondary px-2" href="#" data-toggle="modal" data-target="#modal-covid">
    <ion-icon name="sync-outline"></ion-icon> Update data Covid-19
</a>

<div class="modal fade" id="modal-covid" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <form class="modal-content" action="action-covid.php" method="post" enctype="multipart/form-data">
            <div class="modal-header d-flex align-items-baseline">
                <h5 class="modal-title mr-2">Data Covid-19,</h5>
                <small><?= tanggal(date('D, d M Y, H:i:s', strtotime($covid['update_terakhir']))) ?></small>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<?= $covid['id_covid'] ?>">
                <div class="form-row">
                    <div class="form-group col">
                        <label for="positif">Positif</label>
                        <input type="text" class="form-control" id="positif" name="positif" value="<?= $covid['positif'] ?>">
                    </div>
                    <div class="form-group col">
                        <label for="sembuh">Sembuh</label>
                        <input type="text" class="form-control" id="sembuh" name="sembuh" value="<?= $covid['sembuh'] ?>">
                    </div>
                    <div class="form-group col">
                        <label for="meninggal">Meninggal</label>
                        <input type="text" class="form-control" id="meninggal" name="meninggal" value="<?= $covid['meninggal'] ?>">
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group col-md-6">
                        <label for="odp">ODP</label>
                        <input type="text" class="form-control" id="odp" name="odp" value="<?= $covid['odp'] ?>">
                    </div>
                    <div class="form-group col-md-6">
                        <label for="pdp">PDP</label>
                        <input type="text" class="form-control" id="pdp" name="pdp" value="<?= $covid['pdp'] ?>">
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-success">Simpan Perubahan</button>
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Tutup</button>
            </div>
        </form>
    </div>
</div>

<?php include 'php/bawah.php'; ?>
