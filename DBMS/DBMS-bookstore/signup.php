<?php
// Establish a connection to MySQL
$servername = "localhost";
$username = "root";
$password = ""; // Note: Consider setting a password for your MySQL root user
$database = "online_bookstore";

// Create connection
$conn = new mysqli($servername, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Retrieve username and password from the signup form
$signup_username = $conn->real_escape_string($_POST['signup_username']);
$signup_password = $conn->real_escape_string($_POST['signup_password']);

// SQL query to insert new user into the database using prepared statement
$sql = "INSERT INTO users (username, password) VALUES (?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ss", $signup_username, $signup_password);

if ($stmt->execute()) {
    echo "Sign up successful";

     // Redirect back to the form page after 3 seconds
     echo '<script>window.location.href = "login.html";</script>';
     exit; // Exit to prevent further output
} else {
    echo "Error: " . $sql . "<br>" . $conn->error;
}

$stmt->close();
$conn->close();
?>
