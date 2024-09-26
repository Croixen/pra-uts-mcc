<?php 
    require "dbCon.php";
    if($_SERVER['REQUEST_METHOD'] == 'POST'){
        $json = file_get_contents('php://input');

        try{

            #get things from request body
            $parsed = json_decode($json, true);


            #just a safety meaasure, if someone fucked up on the front end, well in the end of the day, this is just a solo project
            if($parsed === null || !$parsed){
                http_response_code(400);
                throw new Exception("The request body is empty");
            }

            $username = $parsed['username'];
            $password = $parsed['password'];
            $nama = $parsed['nama'];
            $alamat = $parsed['alamat'];
            $tanggalLahir = $parsed['tanggalLahir'];
            $noTelepon = $parsed['noTelepon'];
            $alamatEmail = $parsed['email'];
            $status = $parsed['status'];
            $jenisKelamin = $parsed['jenisKelamin'];

            #start the transaction 
            $conn -> begin_transaction();

            $stmt = $conn -> prepare("INSERT INTO `users`(`username`, `password`) VALUES (?,?) ");
            $stmt -> bind_param('ss', $username, $password);
            $stmt -> execute();

            #so this is just a quick fallback, assuming if there is something failed while tryign to make a new account
            if(!$stmt){
                http_response_code(400);
                throw new Exception('The registratio on the new account has failed, everything is being rolledback now, please contact the service or wait for a moment!');
            }

            $ID = (int)$conn -> insert_id;

            $stmt = $conn -> prepare("INSERT INTO `biodata`(`UID`, `alamat`, `tanggalLahir`, `noTelepon`, `alamatEmail`, `status`, `jenisKelamin`, `nama`) VALUES (?,?,?,?,?,?,?,?)");
            $stmt -> bind_param('isssssss', $ID, $alamat, $tanggalLahir, $noTelepon, $alamatEmail, $status, $jenisKelamin, $nama);
            $stmt -> execute();

            #this only happens, if something weird is happens while want to insert the data into the bidoata table, this is just a complete measure and follow up from the previous statement execution
            if(!$stmt){
                http_response_code(400);
                throw new Exception('New account is succesfully made, but it seems there is something happend with the data, pealse contact the service for the further support!');
            }

            $conn -> commit();
            
        }catch(Exception $e){
            $conn -> rollback();
            $responseError = array(
                'message' => $e -> getMessage(),
                'response code' => http_response_code()
            );
        }finally{
            $conn -> close();
        }
    }else{
        http_response_code(405);
        $responseError = array('message' => 'Method Not Allowed', 'response code' => http_response_code());
        echo json_encode($responseError);
    }
?>