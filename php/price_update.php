<?php
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;

    if ($_SERVER["REQUEST_METHOD"] === "POST") {
        
        $uploadedFile = $_FILES["priceFile"];
    
        if ($uploadedFile["error"] === UPLOAD_ERR_OK) {
            $filePath = $uploadedFile["tmp_name"];
    
    
    $jsonContent = file_get_contents($filePath);
    $data = json_decode($jsonContent, true);
    
    foreach ($data["data"] as $product) {
        $productId = $product["id"];
    
        foreach ($product["prices"] as $priceData) {
            $date = $priceData["date"];
            $price = $priceData["price"];
    
            $sql = "INSERT ignore INTO price (product_id, date, price) 
            VALUES ('$productId', '$date', '$price')";
    
            if ($conn->query($sql) !== TRUE) {
                echo "Error: " . $sql . "<br>" . $conn->error;
            }
        }
    }
    }
        }


$conn->close();

$success = "true";
header( 'Location: ../html/admin_dashboard.html?success='.$success);
?>