<?php
session_start();
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;

$username = $_POST["username"];
$email = $_POST["email"];
$password = $_POST["password"];

$query = "INSERT INTO user (username, email, password) VALUES ('$username', '$email','$password')";

if (mysqli_query($conn,$query)) {   
    echo 1;
}
else{
    echo 0;
}
?>
