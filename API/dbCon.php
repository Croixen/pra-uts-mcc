<?php 
    $username = 'root';
    $host = 'localhost';
    $database = 'project_pra_uts';
    
    $conn = new mysqli($host, $username, '', $database);
    $conn -> autocommit(false);
    
    if ($conn->connect_error) {
        die("Connection failed: " . $conn->connect_error);
    }
?>