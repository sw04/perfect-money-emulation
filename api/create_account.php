<?php
if (!empty($_GET)) {
    $req = ['login', 'password', 'name', 'alternative_phrase', 'balance'];
    $error = '';
    foreach($req as $item) {
        if (!array_key_exists($item, $_GET)) {
            $error = $item;
        }
    }
    if ($error != '') {
        echo 'error: not isset '.$error;
    }

    include getenv('DOCUMENT_ROOT').'/pm.php';
    $accountid = intval($_GET['login']);
    $passphrase = filter_var($_GET['password'], FILTER_SANITIZE_STRING);
    $name = filter_var($_GET['name'], FILTER_SANITIZE_STRING);
    $alternative_phrase = filter_var($_GET['alternative_phrase'], FILTER_SANITIZE_STRING);
    $balance = floatval($_GET['balance']);
    $result = pm::create($accountid, $passphrase, $name, $alternative_phrase, $balance);

    if (array_key_exists('error', $result)) {
        echo 'error '. $result['error'];
    } else {
        echo 'ok';
    }
} else {
    echo 'error not_all_data';
}