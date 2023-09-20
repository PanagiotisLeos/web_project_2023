<?php
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;

{
    $querry=mysqli_query($conn,"SELECT store.id as store_id,store.name AS store_name, offers.id as offer_id, product.name AS product_name,category.name as category_name,offers.stock, offers.price , latitude , longitude , a5ai,a5aii
    FROM store 
    LEFT JOIN offers ON store.id = offers.store_id 
    LEFT JOIN product ON offers.product_id = product.id
    LEFT JOIN category ON product.category_id = category.id");
        
    $J=[];
    while($result=mysqli_fetch_assoc($querry))
    {
        $J[]=$result;
    }
    echo json_encode($J);
}



?>



