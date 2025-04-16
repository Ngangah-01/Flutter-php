<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

include 'db_config.php';

// $input = file_get_contents('php://input');
// $data = json_decode($input, true);

// Log received data (for debugging)
// error_log("Received data: " . print_r($data, true));

// Check if request method is POST
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Read JSON input
    $input = file_get_contents("php://input");
    $data = json_decode($input, true);

    if (isset($data['voter_id']) && isset($data['password'])) {
        $voter_id = $data['voter_id'];
        $password = $data['password'];


        // Prepare SQL query
        $stmt = $conn->prepare("SELECT fname, user_password FROM voters WHERE voter_id = ?");
        $stmt->bind_param("i", $voter_id);
        $stmt->execute();
        $result = $stmt->get_result();

        if ($row = $result->fetch_assoc()) {
            // Verify password
            if ($password === $row['user_password']) {
                echo json_encode(["success" => true, "fname" => $row['fname'], "message" => "Login successful"]);
            } else {
                echo json_encode(["success" => false, "message" => "Invalid password"]);
            }
        } else {
            echo json_encode(["success" => false, "message" => "User not found"]);
        }

        $stmt->close();
    } else {
        echo json_encode(["success" => false, "message" => "Missing voter ID or password"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Invalid request method"]);
}

$conn->close();
