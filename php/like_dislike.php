<?php 
session_start();
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;
$offerId = $_GET['offer_id'];
$user_id = $_SESSION['id'];

$offers = mysqli_query($conn, 'SELECT * FROM OFFERS');
foreach($offers as $offer) :
    $offer_id = $offer["id"];

    $query = "SELECT COUNT(*) AS likes FROM review WHERE offer_id = $offerId AND react = 2 ";
    $result = mysqli_query($conn,$query);
    $likecount = mysqli_fetch_assoc($result);

    $query1 = "SELECT COUNT(*) AS dislikes FROM review WHERE offer_id = $offerId AND react = 1 ";
    $result1 = mysqli_query($conn,$query1);
    $dislikecount = mysqli_fetch_assoc($result1);

    $query2 = "SELECT react FROM review WHERE offer_id = $offer_id AND user_id = $user_id";
    $result2 = mysqli_query($conn,$query2);
    $react = mysqli_fetch_assoc($result2);
endforeach;
    
?>