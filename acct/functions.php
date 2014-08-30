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

function get_account($id) {
    $dbh = connect_db();
    $stmt = $dbh->prepare("SELECT * FROM accounts WHERE accountid = ?");
    $stmt->bindParam(1, $id, PDO::PARAM_INT);
    $stmt->execute();
    $result = $stmt->fetch();

    if ($result != null) {
        return $result;
    }
    return [];
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
function update_balance($wallet, $amount) {
    $dbh = connect_db();
    $stmt = $dbh->prepare("UPDATE wallets SET balance = balance + ? WHERE wallet = ?");
    $stmt->bindParam(1, $amount);
    $stmt->bindParam(2, $wallet);
    $stmt->execute();
}
function get_max_history_id() {
    $dbh = connect_db();
    $stmt = $dbh->prepare("SELECT MAX(id) AS batch FROM history");
    $stmt->execute();
    $result = $stmt->fetch();
    if ($result != null) {
        return $result['batch'] + 1;
    }
    return 1;
}

function add_history($Payer_Account, $Amount, $Payee_Account, $batch = 0, $Memo = '') {
    $dbh = connect_db();
    $stmt = $dbh->prepare("INSERT INTO history SET Time = ?,Type = ?,Currency = ?,Amount = ?, Fee = ?,Payer_Account = ?,Payee_Account = ?,Memo = ?, batch = ?");
    $time = time();
    $stmt->bindParam(1, $time);
    $type = 'Charge';
    if ($Amount > 0) {
        $type = 'Income';
    }
    $stmt->bindParam(2, $type);
    $Currency = 'USD'; //TODO default currency. most value - USD, EUR
    $stmt->bindParam(3, $Currency);
    $Amount = sprintf("%0.2f",$Amount);
    $stmt->bindParam(4, $Amount);
    $Fee = '0.00';
    if ($Amount > 0) {
        $Fee = sprintf("%0.2f",$Amount*0.005); //FIXME add account verification state
    }
    $stmt->bindParam(5, $Fee);
    $stmt->bindParam(6, $Payer_Account);
    $stmt->bindParam(7, $Payee_Account);
    if ($Memo == '') {
        if ($Amount > 0) {
            $Memo = 'Sent Payment ' . $Amount . ' USD from account ' . $Payer_Account . '. Memo: API Payment.';
        } else {
            $Memo = 'Sent Payment ' . $Amount*-1 . ' USD to account ' . $Payer_Account . '. Memo: API Payment.';
        }
    }
    $stmt->bindParam(8, $Memo);
    if ($batch == 0) {
        //get max id
        $batch = get_max_history_id();
    }
    $stmt->bindParam(9, $batch);
    $stmt->execute();
    return $batch;
}

function transfer_funds($AccountId, $Payer_Account, $Amount, $Payee_Account) {
    $dbh = connect_db();
    $stmt = $dbh->prepare("SELECT * FROM wallets WHERE wallet = ?");
    $stmt->bindParam(1, $Payee_Account);
    $stmt->execute();
    $result = $stmt->fetch();
    if ($result == null) {
        return ['error' => 'Invalid Payee_Account'];
    }
    //add in history
    $batch = add_history($Payer_Account, $Amount, $Payee_Account);
    add_history($Payee_Account, $Amount*-1, $Payer_Account, $batch);

    //update balance
    update_balance($Payer_Account, $Amount*-1);
    update_balance($Payee_Account, $Amount);

    //return spend data
    $account = get_account($AccountId);

    $spend = [
        'Payee_Account_Name' => $account['name'],
        'Payee_Account' => $Payee_Account,
        'Payer_Account' => $Payer_Account,
        'PAYMENT_AMOUNT' => $Amount,
        'PAYMENT_BATCH_NUM' => $batch
    ];
    return $spend;
}

function get_history($login, $start, $end) {
    $dbh = connect_db();
    $sql = "SELECT history.* FROM history LEFT JOIN wallet ON (wallets.wallet = history.Payer_Account OR wallets.wallet = history.Payee_Account) WHERE wallets.accountid = ? AND history.Time > ? AND history.Time < ?";
    $stmt = $dbh->prepare($sql);
    $stmt->bindParam(1, $login);
    $stmt->bindParam(2, $start);
    $stmt->bindParam(3, $end);
    $stmt->execute();
    $result = $stmt->fetchAll();
    return $result;
}