<?php
// header('Content-Type: application/json');

// include 'db_connection.php';

// $firstName = $_POST['firstName'];
// $lastName = $_POST['lastName'];
// $birthDate = $_POST['birthDate'];
// $email = $_POST['email'];
// $password = password_hash($_POST['password'], PASSWORD_DEFAULT); // Hash passwords for security
// $verification = $_POST['verification'];
// $country = $_POST['countries'];
// $address = $_POST['address'];
// $idPhoto = $_POST['idPhoto'];
// $selfiePhoto = $_POST['selfiePhoto']; 
// // $paymentDetails = $_POST['paymentDetails'];

// $sql = "INSERT INTO user_account (fname, lname, bdate, email, password, gov_id, country, address, id_photo, selfie_photo) 
//         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?,?)";

// $stmt = $conn->prepare($sql);
// $stmt->bind_param('ssssssssss', $firstName, $lastName, $birthDate, $email, $password, $verification, $country, $address, $idPhoto, $selfiePhoto);

// if ($stmt->execute()) {
//     echo json_encode(["success" => true, "message" => "User data saved successfully."]);
// } else {
//     echo json_encode(["success" => false, "message" => "Error saving user data."]);
// }

// $stmt->close();
// $conn->close();

header('Content-Type: application/json');

include 'db_connection.php';

$firstName = $_POST['firstName'];
$lastName = $_POST['lastName'];
$birthDate = $_POST['birthDate'];
$email = $_POST['email'];
$password = password_hash($_POST['password'], PASSWORD_DEFAULT); // Hash passwords for security
$verification = $_POST['verification'];
$country = $_POST['countries'];
$address = $_POST['address'];
$idPhotoBase64 = $_POST['idPhoto']; // Base64 ID photo
$selfiePhotoBase64 = $_POST['selfiePhoto']; // Base64 selfie photo
$receiptPhotoBase64 = $_POST['receiptPhoto']; // Base64 selfie photo

// Define upload directory (outside public access for security)
$uploadDir = '../photo/';
if (!file_exists($uploadDir)) {
    mkdir($uploadDir, 0777, true); // Create directory if it doesn't exist
}

// Generate unique filenames for the images
$idPhotoFilename = uniqid('id_', true) . '.jpg';
$selfiePhotoFilename = uniqid('selfie_', true) . '.jpg';
$receiptPhotoFilename = uniqid('receipt_', true) . '.jpg';
// Decode Base64 data and save the files
$idPhotoPath = $uploadDir . $idPhotoFilename;
$selfiePhotoPath = $uploadDir . $selfiePhotoFilename;
$receiptPhotoPath = $uploadDir . $receiptPhotoFilename;

if (file_put_contents($idPhotoPath, base64_decode($idPhotoBase64)) === false || 
    file_put_contents($selfiePhotoPath, base64_decode($selfiePhotoBase64)) === false || 
    file_put_contents($receiptPhotoPath, base64_decode($receiptPhotoBase64)) === false) {
    echo json_encode(["success" => false, "message" => "Error saving images."]);
    exit;
}

// Save filenames (not the actual image) in the database
$sql = "INSERT INTO user_account (fname, lname, bdate, email, password, gov_id, country, address, id_photo, selfie_photo, receipt_photo) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)";

$stmt = $conn->prepare($sql);
$stmt->bind_param('sssssssssss', $firstName, $lastName, $birthDate, $email, $password, $verification, $country, $address, $idPhotoFilename, $selfiePhotoFilename, $receiptPhotoFilename);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "message" => "User data saved successfully."]);
} else {
    echo json_encode(["success" => false, "message" => "Error saving user data to the database."]);
}

// Close connections
$stmt->close();
$conn->close();

?>