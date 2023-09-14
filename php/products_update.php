<?php 

$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    
    $uploadedFile = $_FILES["dataFile"];

    if ($uploadedFile["error"] === UPLOAD_ERR_OK) {
        $filePath = $uploadedFile["tmp_name"];
        echo "File path: " . $filePath;

$jsonContent = file_get_contents($filePath);
if ($jsonContent === false) {
    echo "Error: Unable to read JSON file.";
} else {
$data = json_decode($jsonContent, true);
if ($data === null) {
    echo "Error: Unable to decode JSON content.";
} else {
    foreach ($data["products"] as $product) {
        $id = $product["id"];
        $name = $product["name"];
        $category = $product["category"];
        $subcategory = $product["subcategory"];
    
        $sql = "INSERT IGNORE INTO product (id, name, category_id, subcategory_id) VALUES ('$id', '$name', '$category', '$subcategory')";
    
            if ($conn->query($sql) !== TRUE) {
                echo "Error: " . $sql . "<br>" . $conn->error;
            }
        }
    }
}

}
}
$conn->close();

echo "Data uploaded and inserted into the database.";
?>