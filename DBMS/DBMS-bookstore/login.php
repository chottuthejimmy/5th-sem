<?php
session_start();

// Establish a connection to MySQL
$servername = "localhost";
$username = "root";
$password = "";
$database = "online_bookstore";

$conn = new mysqli($servername, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Retrieve username and password from the login form
$login_username = $_POST['login_username'];
$login_password = $_POST['login_password'];

// SQL query to check if the provided credentials are valid
$sql = "SELECT * FROM users WHERE username = '$login_username' AND password = '$login_password'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    // User authenticated successfully
    $row = $result->fetch_assoc();
    $_SESSION['user_id'] = $row['id'];
    $_SESSION['username'] = $login_username;
    // Send success response
    echo json_encode(["success" => true]);
} else {
    // Invalid credentials
    echo json_encode(["success" => false, "message" => "Invalid username or password"]);
}

$conn->close();
?>
