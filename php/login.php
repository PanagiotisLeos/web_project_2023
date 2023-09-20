<?php
session_start();
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;

$email = $_POST["email"];
$password = $_POST["password"];

$query = "SELECT * FROM user WHERE email = '$email' and password = PASSWORD('$password')";
$result = mysqli_query($conn,$query); 
$row = mysqli_num_rows($result);


if ($row == 1) {
        $data = mysqli_fetch_assoc($result);

        $_SESSION['email'] = $data['email'];
        $_SESSION['username'] = $data ['username'];
        $_SESSION['id'] = $data['user_id'];

        if ($data['is_admin'] == 0) {
            echo 1;
            }

        if ($data['is_admin'] == 1) {
            echo 2;
        }
    }
    else {
        echo 0;
    }
    

?>

