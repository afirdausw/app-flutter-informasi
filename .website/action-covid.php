<?php
    include 'php/koneksi.php';

    if (!isset($_SESSION['onlenkan_info_id'])) {
        header('location: login.php');
    }

    if (isset($_POST['action'])) {
        $id         = $_POST['id'];
        $positif    = $_POST['positif'];
        $sembuh     = $_POST['sembuh'];
        $meninggal  = $_POST['meninggal'];
        $odp        = $_POST['odp'];
        $pdp        = $_POST['pdp'];

        if ($_POST['action'] == 'update') {
            $query = mysqli_query($connect, "UPDATE covid_19 SET
                                                    positif='$positif', sembuh='$sembuh', meninggal='$meninggal',
                                                    odp='$odp', pdp='$pdp', pemudik='10', update_terakhir=NOW()
                                                    WHERE id_covid='$id' ");
            
            if ($query) {
                header('location: .');
            }
            else {
                header('location: .');
            }
        }
    }