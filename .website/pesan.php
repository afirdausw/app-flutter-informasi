<?php if (isset($_SESSION['info-pesan'])) { ?>
<div class="alert alert-<?= $_SESSION['info-status'] ?> alert-dismissible fade show mb-3 mt-2" role="alert">
    <?= $_SESSION['info-pesan'] ?>
    <button type="button" class="close" data-dismiss="alert" aria-label="Close">
        <span aria-hidden="true">&times;</span>
    </button>
</div>
<?php 
    }
    unset($_SESSION['info-pesan']);
    unset($_SESSION['info-status']);
?>
