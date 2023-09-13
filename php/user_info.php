<?php
session_start();
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;

$id = $_SESSION['id'];
$x = $_POST['x'];


if ($x==1) {
$userDetails = array(
    'email' => $_SESSION['email'],
    'username' => $_SESSION['username']
);

$query = "SELECT score , tokens FROM user WHERE user_id = $id";
$result = mysqli_query($conn,$query); 
$row = mysqli_num_rows($result);

if ($row == 1) {
    $data = mysqli_fetch_assoc($result);
    $userDetails['score'] = $data['score'];
    $userDetails['tokens'] = $data['tokens'];
}

$userDetailsJson = json_encode($userDetails);

echo $userDetailsJson;
}

if($x==2){
    $query1 = "SELECT store.name as store_name,product.name as product_name, price , stock ,date from offers 
    INNER JOIN product on offers.product_id = product.id
    INNER JOIN store on offers.store_id = store.id
    where user_id = $id ";

    $result=mysqli_query($conn,$query1);
    
    $userOffers=[];
    while($r=mysqli_fetch_assoc($result))
    {
        $userOffers[]=$r;
    }
    echo json_encode($userOffers);

}   


    

?>





