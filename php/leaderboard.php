<?php
session_start();
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;

$lboard = array();
$query = "SELECT username , score ,tokens ,
(SELECT sum(token_history.added_tokens) as l_m_tokens
        FROM token_history WHERE token_history.user_id=user.user_id AND MONTH(timestamp) = MONTH(now()) )
FROM user
WHERE is_admin=0 
ORDER BY score DESC;";

$result = mysqli_query($conn,$query); 
$row = mysqli_num_rows($result);

    $data = mysqli_fetch_assoc($result);

   
    $t=mysqli_query($conn,$query);
        
    $J=[];
    while($r=mysqli_fetch_assoc($t))
    {
        $J[]=$r;
    }
    echo json_encode($J);



