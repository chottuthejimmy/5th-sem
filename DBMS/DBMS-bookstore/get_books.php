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

// Fetch data from Books table
$sql = "SELECT id, title, author, category_id, price, description, image_url FROM Books"; // Adjust column names as per your table schema
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // Initialize an empty array to store book data
    $books = array();

    // Fetch each row from the result set
    while ($row = $result->fetch_assoc()) {
        // Add each row (book) to the $books array
        $books[] = $row;
    }

    // Convert the $books array to JSON format and output it
    echo json_encode($books);
} else {
    // If no books are found, return an empty array
    echo json_encode(array());
}

// Close connection
$conn->close();
?>
