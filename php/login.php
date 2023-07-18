<?php
// Start the session
session_start();

// Include the database connection file (assuming db.php contains the necessary database connection code)
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database;

// Check if the request method is POST and if email and password fields are set
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['email']) && isset($_POST['password'])) {
    // Get the submitted email and password
    $email = $_POST['email'];
    $password = $_POST['password'];

    // Validate and sanitize the email and password inputs (you may use additional validation as needed)

    // Prepare and execute a query to fetch the user with the submitted email from the database
    if ($stmt = $conn->prepare('SELECT * FROM user WHERE email = ?')) {
        $stmt->execute([$email]);
        $stmt->store_result();

        // Check if a user with the given email exists in the database
        if ($stmt->num_rows > 0) {
            $stmt->bind_result($user_id, $user_email, $hashed_password);
            $stmt->fetch();

            // Verify the password hash
            if (password_verify($password, $hashed_password)) {
                // Store relevant user information in the session
                $_SESSION['user_id'] = $user_id;
                $_SESSION['email'] = $user_email;

                // Send a response indicating successful login
                echo 'Welcome ' . $_SESSION['email'] . '!';
            } else {
                // Incorrect password
                echo 'Incorrect email and/or password!';
            }
        } else {
            // User with the given email not found
            echo 'User not found!';
        }

        $stmt->close();
    }
} else {
    // If email and password fields are not set
    exit('Please fill both the email and password fields!');
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