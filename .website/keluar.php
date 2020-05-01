<?php
    session_start();
    unset($_SESSION['onlenkan_info_id']);
    unset($_SESSION['onlenkan_info_level']);
    header('location: .');

?>