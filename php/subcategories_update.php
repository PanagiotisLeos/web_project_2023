<?php
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database;

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $uploadedFile = $_FILES["subFile"];

    if ($uploadedFile["error"] === UPLOAD_ERR_OK) {
        $filePath = $uploadedFile["tmp_name"];

        $jsonContent = file_get_contents($filePath);
        $data = json_decode($jsonContent, true);
        if ($data === null) {
            echo "Error: Unable to decode JSON content.";
        } else {
            foreach ($data["subcategories"] as $subcategory) {
                $id = $subcategory["id"];
                $name = $subcategory["name"];
                $categoryId = $subcategory["category_id"];

                $query = "INSERT IGNORE INTO subcategory (id, name, category_id) VALUES ('$id', '$name', '$categoryId' )";
                
                if ($conn->query($query) !== TRUE) {
                    echo "Error: " . $query . "<br>" . $conn->error;
                }
            }
        }

        $conn->close();
        echo "Data uploaded and inserted into the database.";
    } else {
        echo "Error uploading file.";
    }
}

else if ($_SERVER["REQUEST_METHOD"] === "GET") {
    $query = "DELETE FROM `subcategory` WHERE 1";
    
    if (mysqli_query($conn,$query)) {   
        echo 1;
    }
    else {
        echo "Error: " . mysqli_error($conn); // Display the MySQL error message
    }
}

?>




