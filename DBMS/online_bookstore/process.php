<?php
	session_start();

	$_SESSION['err'] = 1;
	foreach($_POST as $key => $value){
		if(trim($value) == ''){
			$_SESSION['err'] = 0;
		}	
	}

	if($_SESSION['err'] == 0){
		header("Location: purchase.php");
	} else {
		unset($_SESSION['err']);
	}

	require_once "./functions/database_functions.php";
	// print out header here
	$title = "Purchase Process";
	require "./template/header.php";
	// connect database
	$conn = db_connect();
	extract($_SESSION['ship']);

	// validate post section
	$card_type = isset($_POST['card_type']) ? $_POST['card_type'] : '';
	$card_number = isset($_POST['card_number']) ? $_POST['card_number'] : '';
	$card_PID = isset($_POST['card_PID']) ? $_POST['card_PID'] : '';
	$card_expire = isset($_POST['card_expire']) ? strtotime($_POST['card_expire']) : '';
	$card_owner = isset($_POST['card_owner']) ? $_POST['card_owner'] : '';

	//hash all the card information
	$card_number = sha1($card_number);
	$card_PID = sha1($card_PID);
	$card_expire = sha1($card_expire);
	$card_owner = sha1($card_owner);


	// find customer
	$customerid = getCustomerId($name, $address, $city, $zip_code, $country);
	if($customerid == null) {
		// insert customer into database and return customerid
		$customerid = setCustomerId($name, $address, $city, $zip_code, $country);
	}
	$date = date("Y-m-d H:i:s");
	insertIntoOrder($conn, $customerid, $_SESSION['total_price'], $date, $name, $address, $city, $zip_code, $country);

	// take orderid from order to insert order items
	$orderid = getOrderId($conn, $customerid);

	foreach($_SESSION['cart'] as $isbn => $qty){
		$bookprice = getbookprice($isbn);
		$query = "INSERT INTO order_items (orderid, book_isbn, item_price, quantity) VALUES 
		('$orderid', '$isbn', '$bookprice', '$qty')";
		$result = mysqli_query($conn, $query);
		
		if(!$result){
			echo "Insert value false!" . mysqli_error($conn2);
			exit;
		}
	}

	// Insert payment details into the payment_details table
$query = "INSERT INTO payment_details (customerid, Type, Number, CVV, ExpireDate, Name) VALUES ('$customerid','$card_type', '$card_number', '$card_PID', '$card_expire', '$card_owner')";
$result = mysqli_query($conn, $query);
if (!$result) {
    echo "Error inserting payment details: " . mysqli_error($conn);
    exit;
}

	session_unset();
?>

	<div class="alert alert-success rounded-0 my-4">Your order has been processed sucessfully. We'll be reaching you out to confirm your order. Thanks!</div>

<?php
	if(isset($conn)){
		mysqli_close($conn);
	}
	require_once "./template/footer.php";
?>