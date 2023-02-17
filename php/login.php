<?php
$conn = new mysqli('localhost','root','','web' );


$sql = "SELECT * FROM user WHERE email='$email' and password = '$password'";
  $result=mysqli_query($conn,$sql);
  
  if(mysqli_num_rows($result)==1) 
  {
		session_start();
     $_SESSION['auth']='true';
	 header('Location: /html/index.html');
     
	} 
	else {
		echo'Invalid Email or Password!';
	}
$conn->close();


$.
?> 