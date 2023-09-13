<?php
session_start();
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;

$offerId = $_POST['offer_id'];
$stock = $_POST['stock'];

$query = "UPDATE offers set stock = '$stock' where id = $offerId";

if (mysqli_query($conn,$query)) {   
    echo 1;
}
else{
    echo 0;
}


?>