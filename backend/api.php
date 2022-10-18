<?php
/**quick and dirty apis**/
ini_set('display_errors', 1);
include_once("config.inc.php");

$token = filter_input(INPUT_SERVER, 'HTTP_TOKEN');
$uid = filter_input(INPUT_SERVER, 'HTTP_UID');

if ($token!=TOKEN){
    header("HTTP/1.0 403 Forbidden");
    exit;
}


if (!$uid) {
    $uid = uniqid();
}

$db = mysqli_connect(SQL_HOST, SQL_USERNAME, SQL_PASSWORD, SQL_DBNAME);

if (!$db) {
    header("HTTP/1.1 500 Internal Server Error");
    exit;
}

// Change character set to utf8
mysqli_set_charset($db,"utf8");


$request_method = filter_input(INPUT_SERVER, 'REQUEST_METHOD');
if ($request_method=='GET'){

    $operation = filter_input(INPUT_GET, 'operation');
    if ($operation=='canSave'){
        $current_score = filter_input(INPUT_GET, 'score');
        $response=array();
        $res = can_save($current_score);
        $response["canSave"] = $res;
        header('Content-Type: application/json');
        echo json_encode($response);
    } elseif ($operation=='test'){
    	echo $uid;
    } else {
        get_scores();

    }



}elseif ($request_method=='POST'){


    //Receive the RAW post data.
    $content = trim(file_get_contents("php://input"));


    //Attempt to decode the incoming RAW post data from JSON.
    $decoded = json_decode($content, true);
    
    //If json_decode failed, the JSON is invalid.
    if($decoded==null){
        header("HTTP/1.0 400 Bad Request");
        exit;
    }


    save_score($decoded, $uid);

}






function can_save($current_score){

    global $db;
    $isHigher = FALSE;

    //echo "kikou2:".$current_score;
    if ($current_score > 100000) {

	    $stmt = mysqli_prepare($db,"SELECT count(*) as nb FROM aircraft WHERE score > ?");
	    $stmt->bind_param("i", $current_score);
	    $stmt->execute();
	    $result  =  $stmt->get_result();
	    $row = $result->fetch_array(MYSQLI_ASSOC);

	    if ($row["nb"]<100) {
		$isHigher = TRUE;
	    } 

	    
	    $stmt->close();
    }
    //echo "isHigher:".$isHigher;
    return $isHigher;

}


function get_scores()
{
    global $db;
    $query="SELECT * FROM aircraft  ORDER BY aircraft.score DESC LIMIT 100";
    $response=array();
    $result=mysqli_query($db, $query);
    while($row=mysqli_fetch_array($result, MYSQLI_ASSOC))
    {
        $response[]=$row;
    }
    header('Content-type:application/json;charset=utf-8');
    echo json_encode($response);
}

function save_score($data, $uid){
    global $db;


    $canSave = can_save($data["score"]);
   
    if ($canSave == FALSE){
        header("HTTP/1.1 208 Already Reported");
        return;
    } 

    $stmt = mysqli_prepare($db, "SELECT id FROM aircraft WHERE uid = ? AND name = ?");
    $stmt->bind_param("ss", $uid, $data["name"]);
    $stmt->execute();
    $stmt->store_result();

    $sql = "";
    if($stmt->num_rows == 0) {
	//insert
	$sql = "INSERT INTO aircraft (name, score, date, env, uid) VALUES (?, ?, NOW(), ?, ?)";
    } else {
    	// update
    	$sql = "UPDATE aircraft SET name = ?, score = ?, date = NOW(), env = ? WHERE uid = ?";
    }
    $stmt->close();
    
    $stmt = mysqli_prepare($db, $sql);
    $stmt->bind_param("siss", $data["name"], $data["score"], $data["env"], $uid);
    

    //$stmt = mysqli_prepare($db, "INSERT INTO aircraft (name, score, date, env, uid) VALUES (?, ?, NOW(), ?, ?)");
    //$stmt->bind_param("siss", $data["name"], $data["score"], $data["env"], $uid);

    $result = $stmt->execute();
    if(!$result) {
        
        //die('execute() failed: ' . htmlspecialchars($stmt->error));
        header("HTTP/1.0 400 Bad Request");
        echo htmlspecialchars($stmt->error);
        $stmt->close();
    }else {
        $stmt->close();
        header("HTTP/1.0 201 Created");
    }
    

}




mysqli_close($db);
