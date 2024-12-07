<?php
include 'db_connection.php'; 

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents("php://input"), true);

    $bname = $data['bname'] ?? null;
    $bnumber = $data['bnumber'] ?? null;
    $baddress = $data['baddress'] ?? null;
    $bcategory = $data['bcategory'] ?? null;
    $map_link = $data['map_link'] ?? null;

   
    if (empty($bname) || empty($bnumber) || empty($baddress) || empty($map_link) || empty($bcategory)) {
        echo json_encode(['status' => 'error', 'message' => 'All fields are required.']);
        exit;
    }

 
    try {
        $stmt = $pdo->prepare("INSERT INTO business (bname, bnumber, baddress, bcategory, map_link) 
                               VALUES (?, ?, ?, ?, ?)");
        $stmt->execute([$bname, $bnumber, $baddress, $map_link, $bcategory]);

        echo json_encode(['status' => 'success', 'message' => 'Business added successfully.']);
    } catch (Exception $e) {
        echo json_encode(['status' => 'error', 'message' => 'Failed to insert data: ' . $e->getMessage()]);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method.']);
}
?>
