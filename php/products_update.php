<?php 

$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    
    $uploadedFile = $_FILES["dataFile"];

    if ($uploadedFile["error"] === UPLOAD_ERR_OK) {
        $filePath = $uploadedFile["tmp_name"];

$jsonContent = file_get_contents($filePath);
$data = json_decode($jsonContent, true);
if ($data === null) {
    echo "Error: Unable to decode JSON content.";
} else {
    foreach ($data["products"] as $product) {
        $id = $product["id"];
        $name = $product["name"];
        $category = $product["category"];
        $subcategory = $product["subcategory"];
    
        $query = "INSERT IGNORE INTO product (id, name, category_id, subcategory_id) VALUES ('$id', '$name', '$category', '$subcategory')";
       }
             
    }
    if ($conn->query($query) === TRUE) {
        echo "Record inserted successfully!";
    } else {
        echo "Error: " . $conn->error;
    }

}


}




else if ($_SERVER["REQUEST_METHOD"] === "GET") {
    $query = "DELETE FROM  product WHERE 1";
    
    if (mysqli_query($conn,$query)) {   
        echo 1;
    }
    else {
        echo "Error: " . mysqli_error($conn); // Display the MySQL error message
    }
}

?>