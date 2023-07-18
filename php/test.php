<?php
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;

$email = $_POST['email'];
$password = $_POST['password'];
$query = "SELECT * FROM user WHERE email = '$email' AND password = PASSWORD('$password')";
$result = mysqli_query($conn , $query);
$rows = mysqli_num_rows($result);

if($rows > 0) {
    $data = mysqli_fetch_array($result);
    $_SESSION["email"] = $data["email"];
    echo 'Welcome ' . $_SESSION['email'] . '!'; 
    echo 'Secure page!.';
    echo '<a href="logout.php">logout';  
    }
    else {
        echo "Wrong Password";
        
        exit;
    }
?>