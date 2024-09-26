<?php 
    require "dbCon.php";
    if($_SERVER['REQUEST_METHOD'] == 'POST'){
        $json = file_get_contents('PHP://INPUT');
        $parsed = json_decode($json);
        
    }
?>