<?php
define('DB_NAME', 'perfectmoney');
define('DB_USER', 'root');
define('DB_PASS', '');
function connect_db() {
    return new PDO('mysql:host=localhost;dbname='.DB_NAME, DB_USER, DB_PASS);
}

function can_login($login, $password) {
    $dbh = connect_db();
    $stmt = $dbh->prepare("SELECT * FROM accounts WHERE accountid = ? AND passphrase = ?");
    $stmt->bindParam(1, $login);
    $stmt->bindParam(2, $password);
    $stmt->execute();
    $result = $stmt->fetch();

    if ($result != null and array_key_exists('accountid', $result)) {
        return 1;
    }
    return 0;
}

function get_balance($id){
    $dbh = connect_db();
    $stmt = $dbh->prepare("SELECT * FROM wallets WHERE accountid = ?");
    $stmt->bindParam(1, $id, PDO::PARAM_INT);
    $stmt->execute();
    $result = $stmt->fetchAll();

    if ($result != null) {
        return $result;
    }
    return [];
}

function echo_error($error) {
    echo "Error: ".$error."\n<input name='ERROR' type='hidden' value='".$error."'>";
}
