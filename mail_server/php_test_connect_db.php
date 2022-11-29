<?php
$conn = new mysqli('localhost', 'test_user', 'EXAMPLE_PASSWORD', 'test_database');
if ($conn->connect_error) {
    die('Database connection failed: ' . $conn->connect_error);
}
echo 'Database connection was successful';
