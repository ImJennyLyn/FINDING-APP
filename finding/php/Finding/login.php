<?php
header('Content-Type: application/json');
include 'db_connection.php';
file_put_contents('php://stderr', print_r($_POST, true));



    $email = $_POST['email'];
    $password = $_POST['password'];



    $stmt = $conn->prepare("SELECT * FROM user_account WHERE email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();
        // Verify password
        if (password_verify($password, $user['password'])) {
            echo json_encode([
                'status' => 'success',
                'message' => 'Login successful',
                'user' => [
                    'u_id' => $user['u_id'],
                    'email' => $user['email'],
                ]
            ]);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Incorrect password']);
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'User not found']);
    }

    $stmt->close();

$conn->close();
?>