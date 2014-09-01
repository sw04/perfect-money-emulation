<?php
include getenv('DOCUMENT_ROOT').'/acct/functions.php';

class pm {
    static function create($login, $pass, $account = '', $alternative_phrase = 'hyip', $balance = 0) {
        $exist = get_account($login);
        if (array_key_exists('accountid', $exist)) {
            return ['error' => 'account_exist'];
        }

        $dbh = connect_db();
        $sql = "INSERT INTO accounts SET accountid = ?, passphrase = ?, name = ?, alternative_phrase = ?";
        $stmt = $dbh->prepare($sql);
        $stmt->bindParam(1, $login);
        $stmt->bindParam(2, $pass);
        $stmt->bindParam(3, $account);
        $stmt->bindParam(4, $alternative_phrase);
        $stmt->execute();

        self::add_wallet($login, $balance) ;
    }

    static function add_wallet($login, $balance) {
        $dbh = connect_db();
        $sql = "INSERT INTO wallets SET accountid = ?, wallet = ?, balance = ?";
        $stmt = $dbh->prepare($sql);
        $stmt->bindParam(1, $login);
        $wallet = 'U'.$login;
        $stmt->bindParam(2, $wallet);
        $stmt->bindParam(3, $balance);
        $stmt->execute();
    }

}
//sample
//
pm::create(123,123,'123 acc','hyip',100);