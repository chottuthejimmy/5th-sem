<?php
// Establish a connection to MySQL
$servername = "localhost";
$username = "root";
$password = "";
$database = "online_bookstore";

// Create connection
$conn = new mysqli($servername, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Prepare and bind parameters
$stmt = $conn->prepare("INSERT INTO Books (title, author, category_id, price, description, image_url) VALUES (?, ?, ?, ?, ?, ?)");
$stmt->bind_param("ssidds", $title, $author, $category_id, $price, $description, $image_url);

// Set parameters and execute
$title = $_POST["title"];
$author = $_POST["author"];
$category_id = $_POST["category_id"];
$price = $_POST["price"];
$description = $_POST["description"];
$image_url = $_POST["image_url"];

$stmt->execute();

echo "New record inserted successfully";

// Close connection
$stmt->close();
$conn->close();
?>
