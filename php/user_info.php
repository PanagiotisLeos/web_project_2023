<?php
session_start();
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;

$id = $_SESSION['id'];

$userDetails = array(
    'email' => $_SESSION['email'],
    'username' => $_SESSION['username']
);

$query = "SELECT score FROM user WHERE user_id = $id";
$result = mysqli_query($conn,$query); 
$row = mysqli_num_rows($result);

if ($row == 1) {
    $data = mysqli_fetch_assoc($result);
    $userDetails['score'] = $data['score'];
}


$userDetailsJson = json_encode($userDetails);


echo $userDetailsJson;



    

?>





