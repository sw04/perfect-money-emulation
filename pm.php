<?php
include getenv('DOCUMENT_ROOT').'/acct/functions.php';

class pm {
    static function create($accountid, $pass, $name = '', $alternative_phrase = 'hyip', $balance = 0) {
        $exist = get_account($accountid);
        if (array_key_exists('accountid', $exist)) {
            return ['error' => 'account_exist'];
        }

        $dbh = connect_db();
        $sql = "INSERT INTO accounts SET accountid = ?, passphrase = ?, name = ?, alternative_phrase = ?";
        $stmt = $dbh->prepare($sql);
        $stmt->bindParam(1, $accountid);
        $stmt->bindParam(2, $pass);
        $stmt->bindParam(3, $name);
        $stmt->bindParam(4, $alternative_phrase);
        $stmt->execute();

        self::add_wallet($accountid, $balance) ;
    }

    static function add_wallet($accountid, $balance) {
        $dbh = connect_db();
        $sql = "INSERT INTO wallets SET accountid = ?, wallet = ?, balance = ?";
        $stmt = $dbh->prepare($sql);
        $stmt->bindParam(1, $accountid);
        $wallet = 'U'.$accountid;
        $stmt->bindParam(2, $wallet);
        $stmt->bindParam(3, $balance);
        $stmt->execute();
    }

}
//sample
//
pm::create(123,123,'123 acc','hyip',100);