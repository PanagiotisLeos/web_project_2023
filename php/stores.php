<?php
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;

{
    $t=mysqli_query($conn,"SELECT store.id as store_id,store.name AS store_name, offers.id as offer_id, product.name AS product_name,category.name as category_name,offers.stock, offers.price , latitude , longitude , a5ai,a5aii
    FROM store 
    LEFT JOIN offers ON store.id = offers.store_id 
    LEFT JOIN product ON offers.product_id = product.id
    LEFT JOIN category ON product.category_id = category.id");
        
    $J=[];
    while($r=mysqli_fetch_assoc($t))
    {
        $J[]=$r;
    }
    echo json_encode($J);
}


/* 
"SELECT store.name AS store_name, product.name AS product_name, offers.price , latitude , longitude
        FROM store 
        INNER JOIN offers ON store.id = offers.store_id 
        INNER JOIN product ON offers.product_id = product.id");
*/
?>



