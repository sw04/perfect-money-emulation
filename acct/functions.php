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
    $dbh = connect_db();
    $stmt = $dbh->prepare("INSERT INTO errors SET error = ?");
    $stmt->bindParam(1, $error);
    $stmt->execute();
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
    $stmt = $dbh->prepare("SELECT id, MAX(id) AS batch, time AS timestampgmt FROM history");
    $stmt->execute();
    $result = $stmt->fetch();
    if ($result != null) {
        $result['batch'] = $result['batch'] + 1;
        return $result;
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
        $max_id = get_max_history_id();
        $batch = $max_id['batch'];
    }
    $stmt->bindParam(9, $batch);
    $stmt->execute();

    $max_id = get_max_history_id();
    return ['batch' => $batch, 'id' => $max_id['id'], 'time' => $max_id['timestampgmt']];
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
    $payment = add_history($Payer_Account, $Amount, $Payee_Account);
    add_history($Payee_Account, $Amount*-1, $Payer_Account, $payment['batch']);

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
        'PAYMENT_BATCH_NUM' => $payment['batch'],
        'PAYMENT_ID' => $payment['id'],
        'TIMESTAMPGMT' => $payment['time']
    ];
    return $spend;
}

function get_history($login, $start, $end, $batch = 0, $paymentsreceived = 0) {
    $dbh = connect_db();
    $batchsql = '';
    if ($batch) {
        $batchsql = 'AND batch = ?';
    }
    $joinsql = '';
    if (!$paymentsreceived) {
        $joinsql = ' wallets.wallet = history.Payer_Account OR ';
    }

    $sql = "SELECT history.* FROM history LEFT JOIN wallets ON (".$joinsql." wallets.wallet = history.Payee_Account) WHERE wallets.accountid = ? AND history.Time > ? AND history.Time < ? ".$batchsql." ORDER BY history.id DESC";
    $stmt = $dbh->prepare($sql);
    $stmt->bindParam(1, $login);
    $stmt->bindParam(2, $start);
    $stmt->bindParam(3, $end);
    if ($batch) {
        $stmt->bindParam(4, $batch);
    }
    $stmt->execute();
    $result = $stmt->fetchAll();
    return $result;
}

function get_alternative_phrase($wallet) {
    $dbh = connect_db();
    $sql = 'SELECT accounts.alternative_phrase FROM wallets LEFT JOIN accounts ON (wallets.accountid = accounts.accountid) WHERE wallets.wallet = ?';
    $stmt = $dbh->prepare($sql);
    $stmt->bindParam(1, $wallet);
    $stmt->execute();
    $result = $stmt->fetch();
    return $result['alternative_phrase'];
}

function get_v2_hash($data){
    $hash  = $data['PAYMENT_ID'].':'.$data['Payee_Account'].':'.$data['PAYMENT_AMOUNT'].':USD:';
    $hash .= $data['PAYMENT_BATCH_NUM'].':'.$data['Payer_Account'];
    $hash .= ':'.strtoupper(md5(get_alternative_phrase($data['Payer_Account']))).':'.$data['TIMESTAMPGMT']; //TODO fix alrenative phrase
    return strtoupper(md5($hash));
}

function get_baggage_fields() {
    if (array_key_exists('BAGGAGE_FIELDS', $_POST)) {
        $baggage = explode(' ', str_replace('+', ' ',$_POST['BAGGAGE_FIELDS']));
        $result = [];
        foreach($baggage as $item) {
            if (array_key_exists($item, $_POST)) {
                array_push($result, ['index' => $item, 'value' => $_POST[$item]]);
            }
        }
        return $result;
    }
    return [];
}

function send_transfer_result($data, $b) {
    $send_data = [
        "PAYEE_ACCOUNT" => $data['Payee_Account'],
        "PAYMENT_ID" => $data['PAYMENT_ID'],
        "PAYMENT_AMOUNT" => $data['PAYMENT_AMOUNT'],
        "PAYMENT_UNITS" => "USD", //TODO default currency. most value - USD, EUR
        "PAYMENT_BATCH_NUM" => $data['PAYMENT_BATCH_NUM'],
        "PAYER_ACCOUNT" => $data['Payer_Account'],
        "TIMESTAMPGMT" => $data['TIMESTAMPGMT'],
        "V2_HASH" => get_v2_hash($data),
        "BAGGAGE_FIELDS" => $_POST['BAGGAGE_FIELDS']
    ];
    //baggage fields
    foreach($b as $item) {
        $send_data[$item['index']] = $item['value'];
    }

    //generate post query
    $post_data = '';
    foreach($send_data as $index => $item) {
        $post_data .= $index.'='.$item;
        $post_data .= '&';
    }

    //send result
    $out = '';
    if ($_POST['PAYMENT_URL_METHOD'] == 'POST') {
        $url = $_POST['STATUS_URL'];

        if( $curl = curl_init() ) {
            curl_setopt($curl, CURLOPT_URL, urldecode($url));
            curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($curl, CURLOPT_POST, count($send_data));
            curl_setopt($curl, CURLOPT_POSTFIELDS, $post_data);
            $out = curl_exec($curl);
            curl_close($curl);
        }
    }
    return $out;
}

function send_csv ($data) {
    $file = 'history.csv';
    $fp = fopen($file, 'w');
    fwrite($fp, $data);
    fclose($fp);

    if (file_exists($file)) {
        header('Content-Description: File Transfer');
        header('Content-Type: application/octet-stream');
        header('Content-Disposition: attachment; filename='.basename($file));
        header('Content-Transfer-Encoding: binary');
        header('Expires: 0');
        header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
        header('Pragma: public');
        header('Content-Length: ' . filesize($file));
        ob_clean();
        flush();
        readfile($file);
        unlink($file);
        exit;
    }
}