<?php
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;
session_start();
$storeId = $_GET['store_id'];
$userId = $_SESSION['id'];
$x = $_GET['x'];

if ($x == 1){
    $query1 = "SELECT 
    product.name AS product_name,
    offers.price AS price, 
    offers.date AS offer_date, 
    user.username AS username, 
    offers.stock AS stock, 
    offers.id AS offer_id,
    IFNULL(user_ratings.react, 0) AS user_reaction,
    IFNULL(like_counts.likecount, 0) AS likecount,
    IFNULL(dislike_counts.dislikecount, 0) AS dislikecount
FROM offers 
INNER JOIN product ON offers.product_id = product.id
INNER JOIN user ON offers.user_id = user.user_id
LEFT JOIN (
    SELECT offer_id, react
    FROM ratings
    WHERE user_id = $userId
) AS user_ratings ON offers.id = user_ratings.offer_id
LEFT JOIN (
    SELECT offer_id, COUNT(*) AS likecount
    FROM ratings
    WHERE react = 2
    GROUP BY offer_id
) AS like_counts ON offers.id = like_counts.offer_id
LEFT JOIN (
    SELECT offer_id, COUNT(*) AS dislikecount
    FROM ratings
    WHERE react = 1
    GROUP BY offer_id
) AS dislike_counts ON offers.id = dislike_counts.offer_id
WHERE offers.store_id = $storeId;

    ";
    $result=mysqli_query($conn,$query1);
    
    $J=[];
    while($r=mysqli_fetch_assoc($result))
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
    
    $categoryArray = array_values($categories);
    
    echo json_encode($categoryArray);
}





?>