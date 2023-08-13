<?php 
if ($_SERVER["REQUEST_METHOD"] === "POST") {
    
    $uploadedFile = $_FILES["dataFile"];

    if ($uploadedFile["error"] === UPLOAD_ERR_OK) {
        $filePath = $uploadedFile["tmp_name"];


$jsonContent = file_get_contents($filePath);
$data = json_decode($jsonContent, true);

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
$conn->close();

echo "Data uploaded and inserted into the database.";
?>