<?php
session_start();
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;

$lboard = array();
$query = "SELECT username , score FROM user WHERE is_admin=0 order by score desc";

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



