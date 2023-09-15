<?php
session_start();
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;

$month = $_GET["month"];
$year = $_GET["year"];



$query = "SELECT COUNT(*) as number_of_offers, date from offers where Month(date) = $month and YEAR(date) = $year 
GROUP by day(date)";

$result=mysqli_query($conn,$query);

    $userOffers=[];
    while($r=mysqli_fetch_assoc($result))
    {
        $userOffers[]=$r;
    }
    echo json_encode($userOffers);


?>