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
        echo 1;
    }
    else {
        $_SESSION['email'] = "";
        echo 0;
    }
    

        //if($password == PASSWORD('$password'))
      /*  if(password_verify($password, $data['password'])) {
            $_SESSION['email'] = $data['email'];
            echo 1; */
?>

