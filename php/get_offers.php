<?php
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;
session_start();
$storeId = $_GET['store_id'];
$userId = $_SESSION['id'];
$x = $_GET['x'];

if ($x == 1){
    $query1 = "SELECT product.name as product_name, offers.price as price, offers.date as offer_date, user.username as username , offers.stock as stock , offers.id as offer_id
    FROM offers 
    INNER JOIN product ON offers.product_id = product.id
    INNER JOIN user ON offers.user_id = user.user_id
    WHERE store_id = $storeId
    ";
    $t=mysqli_query($conn,$query1);
        
    $J=[];
    while($r=mysqli_fetch_assoc($t))
    {
        $J[]=$r;
    }
    echo json_encode($J);
}

if($x == 2){
    $query2 = "SELECT category.id AS category_id, category.name AS category_name, subcategory.id AS subcategory_id, subcategory.name AS subcategory_name, product.id AS product_id, product.name AS product_name FROM `subcategory` 
    INNER JOIN category ON category_id = category.id
    INNER JOIN product ON subcategory_id = subcategory.id";
    $result = mysqli_query($conn, $query2);

    $categories = array();
    while ($row = mysqli_fetch_assoc($result)) {
        $category_id = $row['category_id'];
        $subcategory_id = $row['subcategory_id'];
    
        // If category does not exist in the array, create it
        if (!isset($categories[$category_id])) {
            $categories[$category_id] = array(
                'id' => $category_id,
                'name' => $row['category_name'],
                'subcategories' => array()
            );
        }
    
        // If subcategory does not exist in the category, create it
        if (!isset($categories[$category_id]['subcategories'][$subcategory_id])) {
            $categories[$category_id]['subcategories'][$subcategory_id] = array(
                'id' => $subcategory_id,
                'name' => $row['subcategory_name'],
                'products' => array()
            );
        }
    
        // Add product to the subcategory's products
        if (!is_null($row['product_id'])) {
            $categories[$category_id]['subcategories'][$subcategory_id]['products'][] = array(
                'id' => $row['product_id'],
                'name' => $row['product_name']
            );
        }
    }
    
    // Convert the associative array into a simple array
    $categoryArray = array_values($categories);
    
    echo json_encode($categoryArray);
}





?>