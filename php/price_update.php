<?php
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;


if ($_SERVER["REQUEST_METHOD"] === "POST") {
    // Get the uploaded JSON file data
    $uploadedFile = $_FILES["dataFile"];

    // Check if a file was uploaded successfully
    if ($uploadedFile["error"] === UPLOAD_ERR_OK) {
        $filePath = $uploadedFile["tmp_name"];


// Read JSON content from the file
$jsonContent = file_get_contents($filePath);
$data = json_decode($jsonContent, true);

foreach ($data["data"] as $product) {
    $productId = $product["id"];

    foreach ($product["prices"] as $priceData) {
        $date = $priceData["date"];
        $price = $priceData["price"];

        // SQL query to insert data into the prices table
        $sql = "INSERT INTO price (product_id, date, price) VALUES ('$productId', '$date', '$price')";

        if ($conn->query($sql) !== TRUE) {
            echo "Error: " . $sql . "<br>" . $conn->error;
        }
    }
}
}
    }


// Close the connection
$conn->close();

echo "Data uploaded and inserted into the database.";
?>