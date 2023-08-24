<?php
session_start();
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;
$offerId =$_POST['offer_id'];

$query = "DELETE FROM offers WHERE id = $offerId";

if ($conn->query($query) !== TRUE) {
    echo "Error: " . $sql . "<br>" . $conn->error;
}
else{
    echo 1;
}




?>