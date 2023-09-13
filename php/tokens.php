<?php
session_start();
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;

//calculate total users
$query = "SELECT COUNT(*) as total_users FROM user WHERE is_admin = 0";
$result = mysqli_query($conn,$query); 
$row = mysqli_fetch_assoc($result);

$total_users = $row["total_users"];

$tokens_to_distribute = 80*$total_users;

//calculate total months score
$query1 = "SELECT sum(added_score) as total_months_score FROM score_history WHERE MONTH(timestamp) = MONTH(now()) and YEAR(timestamp) = YEAR(now())";
$result1 = mysqli_query($conn,$query1); 
$row1 = mysqli_fetch_row($result1);

$total_score = $row1[0];

//calculate tokens for each user
$query2 = "SELECT user_id , SUM(added_score) as cur_m_score FROM `score_history` WHERE MONTH(timestamp) = MONTH(now()) and YEAR(timestamp) = YEAR(now()) group by user_id";
$result2 = mysqli_query($conn,$query2); 

    $data = mysqli_fetch_array($result);
    while( $row3 = mysqli_fetch_assoc($result2)){
        $user_score_perc = $row3["cur_m_score"] / $total_score;
        $user_tokens = round($tokens_to_distribute * $user_score_perc);

        $query3 = "UPDATE user SET tokens = tokens + $user_tokens where user_id = '" . $row3["user_id"] . "'";
        mysqli_query($conn,$query3); 
    }
    echo 1;
   



?>