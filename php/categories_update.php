<<<<<<< Updated upstream
=======
<?php
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database;

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $uploadedFile = $_FILES["catFile"];

    if ($uploadedFile["error"] === UPLOAD_ERR_OK) {
        $filePath = $uploadedFile["tmp_name"];

        $jsonContent = file_get_contents($filePath);
            $data = json_decode($jsonContent, true);
            if ($data === null) {
                echo "Error: Unable to decode JSON content.";
            } else {
                foreach ($data["categories"] as $category) {
                    $categoryId = $category["id"];
                    $categoryName = $category["name"];

                    
                  
                    $query = "INSERT IGNORE INTO category (id, name) VALUES ('$id', '$name')";
                }
                
                if ($conn->query($sql) !== TRUE) {
                    echo "Error: " . $sql . "<br>" . $conn->error;
                }
            }
        }

        $conn->close();
        echo "Data uploaded and inserted into the database.";
    } else 

    {
        echo "Error uploading file.";
    }


else if ($_SERVER["REQUEST_METHOD"] === "GET") {
    $query = "DELETE FROM  `category` WHERE 1";
    
    if (mysqli_query($conn,$query)) {   
        echo 1;
    }
}
?>



>>>>>>> Stashed changes

