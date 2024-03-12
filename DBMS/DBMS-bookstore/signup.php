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

// Check if the username already exists
$check_sql = "SELECT * FROM users WHERE username = ?";
$check_stmt = $conn->prepare($check_sql);
$check_stmt->bind_param("s", $signup_username);
$check_stmt->execute();
$check_result = $check_stmt->get_result();

if ($check_result->num_rows > 0) {
    // Username already exists
    echo json_encode(["success" => false, "message" => "Username already exists"]);
} else {
    // SQL query to insert new user into the database using prepared statement
    $sql = "INSERT INTO users (username, password) VALUES (?, ?)";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("ss", $signup_username, $signup_password);

    if ($stmt->execute()) {
        // Sign up successful
        echo json_encode(["success" => true, "message" => "Sign up successful"]);
    } else {
        // Error occurred
        echo json_encode(["success" => false, "message" => "Error: " . $stmt->error]);
    }

    $stmt->close();
}

$check_stmt->close();
$conn->close();
?>
