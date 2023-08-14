<?php
session_start();
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;

$storeId = $_POST['store_id'];
$id = $_SESSION['id'];

$product = $_POST['product'];
$price = $_POST['price'];
$stock = $_POST['stock'];


    $query = "INSERT INTO `offers`(`price`, `user_id`, `product_id`, `store_id`, `stock`, `date`) 
    VALUES ('$price','$id',$product,$storeId,'$stock',CURRENT_DATE)";

if ($conn->query($query) !== TRUE) {
    echo "Error: " . $sql . "<br>" . $conn->error;
}
else{
    echo 1;
}

?>