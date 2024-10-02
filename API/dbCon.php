<?php 
    $username = 'root';
    $host = 'localhost';
    $database = 'pra_uts';

    header("Content-Type: application/json"); // Corrected syntax here
    header("Access-Control-Allow-Origin: *"); // Allow access from any origin
    header("Access-Control-Allow-Methods: *"); // Specify allowed methods
    header("Access-Control-Allow-Headers: Content-Type, Authorization"); // Specify allowed headers
    
    $conn = new mysqli($host, $username, '', $database);
    $conn -> autocommit(false);
    
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
?>