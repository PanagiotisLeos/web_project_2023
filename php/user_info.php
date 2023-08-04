<?php
session_start();


// Create a JSON object with the user details
$userDetails = array(
    'email' => $_SESSION['email'],
    'username' => $_SESSION['username']
);

// Convert the array to JSON format
$userDetailsJson = json_encode($userDetails);

// Return the JSON data

echo $userDetailsJson;



    

?>





