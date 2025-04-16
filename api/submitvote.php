<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

include 'db_config.php';

// Check if request method is POST
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    // Get raw JSON input
    $input = file_get_contents('php://input');
    $data = json_decode($input, true);

    // Handle vote submission request
    if (isset($data['voter_id']) && isset($data['votes'])) {
        $voter_id = $data['voter_id'];
        $votes = $data['votes']; // Already decoded as an associative array

        // Validate input
        if (empty($voter_id) || empty($votes)) {
            echo json_encode(["success" => false, "message" => "Missing voter ID or votes"]);
            exit;
        }

        // Insert votes into the database
        $success = true;
        foreach ($votes as $position => $candidate) {
            $stmt = $conn->prepare("INSERT INTO votes (voter_id, position, candidate) VALUES (?, ?, ?)");
            $stmt->bind_param("iss", $voter_id, $position, $candidate);
            if (!$stmt->execute()) {
                $success = false;
                break;
            }
            $stmt->close();
        }

        if ($success) {
            echo json_encode(["success" => true, "message" => "Votes submitted successfully"]);
        } else {
            echo json_encode(["success" => false, "message" => "Failed to submit votes"]);
        }
    } else {
        echo json_encode(["success" => false, "message" => "Missing voter ID or votes"]);
    }
} else {
    echo json_encode(["success" => false, "message" => "Invalid request method"]);
}

$conn->close();
?>