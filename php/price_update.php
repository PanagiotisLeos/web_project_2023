<?php
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;

    if ($_SERVER["REQUEST_METHOD"] === "POST") {
        
        $uploadedFile = $_FILES["priceFile"];
    
        if ($uploadedFile["error"] === UPLOAD_ERR_OK) {
            $filePath = $uploadedFile["tmp_name"];
    
    
    $jsonContent = file_get_contents($filePath);
    if ($jsonContent === false) {
        echo "Error: Unable to read JSON file.";
    } else {
    $data = json_decode($jsonContent, true);
    if ($data === null) {
        echo "Error: Unable to decode JSON content.";
    } else {
     $sqlValues = [];   
    foreach ($data["data"] as $product) {
        $productId = $product["id"];
    
        foreach ($product["prices"] as $priceData) {
            $date = $priceData["date"];
            $price = $priceData["price"];
            $sqlValues[] = "('$productId', '$date', '$price')";

           
            }
        }
    }
    $sql = "INSERT IGNORE INTO price (product_id, date, price) VALUES " . implode(", ", $sqlValues);
   if ($conn->query($sql) !== TRUE) {
    echo "Error: " . $sql . "<br>" . $conn->error;
   }
    }
        }
    }


$conn->close();
echo("ok");
?>