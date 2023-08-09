<?php
$database = 'C:\xampp\htdocs\web_project\php\db.php';
include $database ;

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $uploadedFile = $_FILES["geojsonFile"];

    if ($uploadedFile["error"] === UPLOAD_ERR_OK) {
        $filePath = $uploadedFile["tmp_name"];

        $geojsonContent = file_get_contents($filePath);
        $data = json_decode($geojsonContent, true);

        foreach ($data["features"] as $feature) {
            $idField = $feature["id"];
            $id = preg_replace('/^.*\//', '', $idField); 
            $name = $feature["properties"]["name"] ? $conn->real_escape_string($feature["properties"]["name"]) : null;
            $brand = $feature["properties"]["brand"] ? $conn->real_escape_string($feature["properties"]["brand"]) : null;
            $longitude = $feature["geometry"]["coordinates"][0];
            $latitude = $feature["geometry"]["coordinates"][1];

        if ($name !== null || $brand !== null) {
            $sql = "INSERT INTO store (name, brand, longitude, latitude) VALUES ('$name', '$brand', '$longitude', '$latitude')";

            if ($conn->query($sql) !== TRUE) {
                echo "Error: " . $sql . "<br>" . $conn->error;
            }
        }
            }
        // Close the connection
        $conn->close();

        echo "GeoJSON data uploaded and inserted into the database.";
    } else {
        echo "Error uploading file.";
    }
}

else if ($_SERVER["REQUEST_METHOD"] === "GET") {
    $query = "DELETE FROM  `store` WHERE 1";
    
    if (mysqli_query($conn,$query)) {   
        echo 1;
    }
}
?>