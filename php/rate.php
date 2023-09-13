<?php 
session_start();
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;
$offerId = $_POST['offer_id'];
$user_id = $_SESSION['id'];
$cur_react = $_POST['cur_react'];


$user_rate = mysqli_query($conn,"SELECT react from ratings WHERE offer_id = $offerId AND user_id = $user_id");
if (mysqli_num_rows($user_rate) > 0){
    $rating = mysqli_fetch_assoc($user_rate);
    if($rating['react'] == $cur_react){
        mysqli_query($conn,"DELETE FROM ratings WHERE offer_id = $offerId AND user_id = $user_id");
        echo "delete";
    }
    else {
        mysqli_query($conn,"UPDATE ratings SET react = $cur_react , timpestamp=now() WHERE offer_id = $offerId AND user_id = $user_id");
        echo "change";
    }
}else{
    mysqli_query($conn,"INSERT INTO ratings (user_id,offer_id,react,timestamp) VALUES($user_id,$offerId,$cur_react,now())");
    echo "new";

}