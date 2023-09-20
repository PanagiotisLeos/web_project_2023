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

if($x==2){ //change to offers_history
    $query1 = "SELECT store.name as store_name,product.name as product_name, price  ,date from offers_history 
    INNER JOIN product on offers_history.product_id = product.id
    INNER JOIN store on offers_history.store_id = store.id
    where user_id = $id and action = 'created' 
    order by date desc limit 15";

    $result=mysqli_query($conn,$query1);
    
    $userOffers=[];
    while($r=mysqli_fetch_assoc($result))
    {
        $userOffers[]=$r;
    }
    echo json_encode($userOffers);

}   

if($x==3){
    $query1 = "SELECT  product.name , price, user.username , react , timestamp 
    from ratings
    INNER JOIN offers on offers.id = ratings.offer_id
    INNER JOIN product on offers.product_id = product.id
    INNER JOIN user on user.user_id = offers.user_id
    where user.user_id = $id";

    $result=mysqli_query($conn,$query1);
    
    $userRatings=[];
    while($r=mysqli_fetch_assoc($result))
    {
        $userRatings[]=$r;
    }
    echo json_encode($userRatings);

}  


if($x==4){
    $query = "SELECT score , tokens , 
    (SELECT sum(added_score)  FROM score_history WHERE score_history.user_id = user.user_id AND MONTH(timestamp) = MONTH(now())) as cm_score  , 
    (SELECT sum(added_tokens)  FROM token_history WHERE token_history.user_id = user.user_id AND MONTH(timestamp) = MONTH(now())-1) as lm_tokens
    FROM user 
    WHERE user.user_id = $id";

    $result=mysqli_query($conn,$query);
    $data = mysqli_fetch_assoc($result);

    $userPoints = [];
    $userPoints['score'] = $data['score'];
    $userPoints['cm_score'] = $data['cm_score'];
    $userPoints['tokens'] = $data['tokens'];
    $userPoints['lm_tokens'] = $data['lm_tokens'];

    $userPointsJson = json_encode($userPoints);

    echo $userPointsJson;

}  

    

?>





