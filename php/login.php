<?php
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;

$email = $_POST['email'];


if ( !isset($_POST['email'], $_POST['password']) ) {
	
		exit('Please fill both the email and password fields!');
	} 

	if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['email']) && isset($_POST['password'])) {
		// get the submitted username and password
		$email = $_POST['email'];
		$password = $_POST['password'];

if ($stmt = $conn->prepare('SELECT * FROM user WHERE email = ?')); {
 	$stmt->execute([$email]);
  	$stmt->store_result();
	$user = $stmt->fetch();

	if ($stmt->num_rows > 0) {
		
	
		if (password_verify($password, $user['password'])) {
    	$_SESSION['email'] = $email;
		echo 'Welcome ' . $_SESSION['email'] . '!';

		} else {
			// Incorrect password
			echo 'Incorrect email and/or password!';
		} 
	}
$stmt->close();
} 
	}


/*


 
if (empty($_POST['email'])) {
    $error[] = "Email field is required";
}
if (empty($_POST['password'])) {
    $error[] = "Password field is required";
}
if (!empty($_POST['email']) && !filter_var($_POST['email'], FILTER_VALIDATE_EMAIL)) {
    $error[] = "Enter Valid Email address";
}
$sql = "SELECT * FROM user WHERE email='$email' and password = '$password'";
$result=mysqli_query($conn,$sql);
  
	$email=$_POST['email'];
	$password=$_POST['password'];
	$check=mysqli_query($conn,"select * from user where email='$email' and password='$password'");

	

	if (isset($_SESSION['session_email']))
	{
	echo "Έχεις κάνει ήδη login <b>".$_SESSION['session_email']."</b>! Μια φορά αρκεί.";
	echo "<br><a href='logoff.php'>Log off</a>";
	}

	if (mysqli_num_rows($check)>0)
	{
		$_SESSION['email']=$email;
		echo json_encode(array("statusCode"=>200));
	}
	else{
		echo json_encode(array("statusCode"=>201));
	}
mysqli_close($conn)

*/

?> 