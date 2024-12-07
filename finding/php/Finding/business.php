<?php
header('Content-Type: application/json');
include 'db_connection.php';

if ($conn->connect_error) {
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed']);
    exit();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $bname = $_POST['bname'] ?? '';
    $bnumber = $_POST['bnumber'] ?? '';
    $baddress = $_POST['baddress'] ?? '';
    $bcategory = $_POST['bcategory'] ?? '';

    if (empty($bname) || empty($bnumber) || empty($baddress) || empty($bcategory)) {
        echo json_encode(['status' => 'error', 'message' => 'All fields are required']);
        exit();
    }

    $bref = uniqid(); 

   
    $stmt = $conn->prepare("INSERT INTO business (bref, bname, bnumber, baddress, bcategory) VALUES (?, ?, ?, ?, ?)");
    $stmt->bind_param("sssss", $bref, $bname, $bnumber, $baddress, $bcategory);

    if ($stmt->execute()) {
        echo json_encode(['status' => 'success', 'bref' => $bref]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Failed to save data']);
    }

    $stmt->close();
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
}

$conn->close();
?>
