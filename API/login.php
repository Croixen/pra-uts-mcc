<?php 
    require 'dbCon.php';

    if($_SERVER['REQUEST_METHOD'] == 'POST'){
        $json = file_get_contents('PHP://INPUT');

        try{
            $parsed = json_decode($json, true);
            
            if($parsed == null || !$parsed){
                http_response_code(400);
                throw new Exception('The request body is empty'); 
            }

            $username = $parsed['username'] ?? null;
            $password = $parsed['password'] ?? null;

            if(!$password || !$username || $password == '' || $username  == ''){
                http_response_code(400);
                throw new Exception('username or password is empty in the body request');
            }

            $stmt = $conn -> prepare("SELECT `ID`,  'password' FROM `users` WHERE `username` = ? LIMIT 1;");
            $stmt -> bind_param('s', $username);

            $stmt -> execute();

            $result = $stmt -> get_result();
            $row = $result -> fetch_assoc();
            if(!$row){
                http_response_code(401);
                throw new Exception('User not Found');
            }

            if(!password_verify($password, $row['password'])){
                http_response_code(401);
                throw new Exception('Wrong Password, Unauthorized');
            }

            $response = array('ID' => $row['ID']);

            echo json_encode($response);

        }catch(Exception $e){
            $responseError = array('message' => $e -> getMessage(), 'response code' => http_response_code());
            echo json_encode($responseError);
        }
    }else{
        http_response_code(405);
        $responseError = array('message' => 'Method Not Allowed', 'response code' => http_response_code());
        echo json_encode($responseError);
    }
?>