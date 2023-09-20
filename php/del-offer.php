<?php
session_start();
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;
$offerId =$_POST['offer_id'];

$query = "DELETE FROM offers WHERE id = $offerId";
$result = mysqli_query($conn,$query); 

if ($result) {
    echo 1;
}
else{
    echo 0;
}


?>