<?php
session_start();

$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;


$id = $_SESSION['id'];
$new_username = $_POST["username"];
$old_password = $_POST["old_password"];
$new_password = $_POST["new_password"];

$query1 = "SELECT * FROM user WHERE user_id = '$id' and password = PASSWORD('$old_password')";
$query = "UPDATE user SET username= '$new_username', password=PASSWORD('$new_password') WHERE user_id = '$id'";

$result = mysqli_query($conn,$query1); 
$row = mysqli_num_rows($result);

if ($row == 1) { 
if (mysqli_query($conn,$query)) { 
    $_SESSION['username'] = "$new_username";
    echo 1;
}
else{
echo 0;
}

}
?>