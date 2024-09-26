<?php 
    require 'dbCon.php';

    if($_SERVER['REQUEST_METHOD'] == 'POST'){
        $json = file_get_contents('PHP://INPUT');
        $parsed = json_decode($json);
        $username = $parsed -> username;
        $password = $parsed -> password;


        try{
            if(!$password || !$username){
                throw new Exception('username or password is empty in the body request');
            }

            $stmt = $conn -> prepare("SELECT `ID` FROM `users` WHERE `username` = ? AND `password` = ?");
            $stmt -> bind_param('ss', $username, $password);

            $stmt -> execute();

            $result = $stmt -> get_result();
            $row = $result -> fetch_assoc();

            $response = array('ID' => $row['ID']);

            header("Content-Type: application/json");
            echo json_encode($response);

        }catch(Exception $e){
            http_response_code(400);
            echo('there is something wrong');
            echo('error code ->'.$e);
        }
    }
?>