<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">

    <link rel="icon" href="img/logo.png">

    <link rel="stylesheet" href="css/main.css">
    <link rel="stylesheet" href="css/login.css">

    <title>Pusat Informasi x Onlenkan</title>
</head>

<body>
    <form action="" method="POST" class="wrap-login" autocomplete="off">
        <img src="img/user-admin.png" alt="">
        <h1 class="judul">Administrator</h1>

        <div class="wrap-input">
            <ion-icon name="person"></ion-icon>
            <input type="text" name="username" placeholder="Username or Email">
        </div>
        <div class="wrap-input">
            <ion-icon name="lock-closed"></ion-icon>
            <input type="password" name="password" placeholder="Password">
        </div>

        <button type="submit" name="login">Masuk</button>

        <a href="#">Lupa sandi?</a>
    </form>

    <?php
        if (isset($_POST['login'])) {
            $username = $_POST['username'];
            $password = $_POST['password'];

            if ($username == 'admin' && $password == 'aa') {
                session_start();
                $_SESSION['onlenkan_info_id']       = '1';
                $_SESSION['onlenkan_info_level']    = '1';

                header('location: .');
            }
            else {
                echo "<script> alert('Username atau password tidak dikenali!') </script>";
            }

        }
    ?>

    <script type="text/javascript" src="js/jquery.min.js"></script>
    
    <script type="module" src="https://unpkg.com/ionicons@5.0.0/dist/ionicons/ionicons.esm.js"></script>
    <script nomodule="" src="https://unpkg.com/ionicons@5.0.0/dist/ionicons/ionicons.js"></script>

</body>

</html>
