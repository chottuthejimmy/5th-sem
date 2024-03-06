<?php
session_start(); // Start the session to access session variables

// Handle checkout process and database insertions

// Check if user ID is stored in the session
if (!isset($_SESSION['user_id']) || empty($_SESSION['user_id'])) {
    echo json_encode(array('success' => false, 'message' => 'User is not logged in or session has expired'));
    exit();
}

// Retrieve user_id from the session
$user_id = $_SESSION['user_id'];

// Establish a connection to MySQL
$servername = "localhost";
$username = "root";
$password = "";
$database = "online_bookstore";

// Create connection
$conn = new mysqli($servername, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    echo json_encode(array('success' => false, 'message' => 'Connection failed: ' . $conn->connect_error));
    exit();
}

// Retrieve cart data from the request
$data = json_decode(file_get_contents("php://input"), true);

// Example: Inserting data into Orders table
$total_price = 0;
$order_date = date('Y-m-d H:i:s');

foreach ($data['cart'] as $item) {
    $total_price += $item['price'];
}

$sql = "INSERT INTO Orders (user_id, total_price, order_date) VALUES (?, ?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ids", $user_id, $total_price, $order_date);
if ($stmt->execute()) {
    $order_id = $stmt->insert_id;

    // Insert data into OrderDetails table
    foreach ($data['cart'] as $item) {
        $book_id = $item['id'];
        $quantity = 1; // Assuming quantity is 1 for each book
        $price = $item['price'];

        $sql = "INSERT INTO OrderDetails (order_id, book_id, quantity, price) VALUES (?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("iiid", $order_id, $book_id, $quantity, $price);
        $stmt->execute();
    }

    // Return success response
    echo json_encode(array('success' => true, 'message' => 'Checkout successful'));
} else {
    // Return error response
    echo json_encode(array('success' => false, 'message' => 'Error: ' . $conn->error));
}

// Close connection
$conn->close();
?>
