<?php
include getenv('DOCUMENT_ROOT').'/acct/functions.php';

if (array_key_exists('AccountID', $_GET) and array_key_exists('PassPhrase', $_GET)) {
    $login = intval($_GET['AccountID']);
    $password = filter_var($_GET['PassPhrase'], FILTER_SANITIZE_STRING);
    if (can_login($login, $password)) {
        $req = [
            'startmonth',
            'startday',
            'startyear',
            'endmonth',
            'endday',
            'endyear'
        ];
        $error = '';
        foreach($req as $item) {
            if (!array_key_exists($item, $_GET)) {
                $error = 'Error: Invalid '.$item;
                break;
            }
        }
        if ($error != '') {
            echo $error;
        }

        $start = intval($_GET['startyear']).'-'.intval($_GET['startmonth']).'-'.intval($_GET['startday']);
        $end = intval($_GET['endyear']).'-'.intval($_GET['endmonth']).'-'.intval($_GET['endday']);

        $start = strtotime($start);
        $end = strtotime($end);

        if ($end - $start < 60*60*24*30 and $end - $start > 0) {
            $history = get_history($login, $start, $end);

            $data = 'Time,Type,Batch,Currency,Amount,Fee,Payer Account,Payee Account,Payment ID,Memo'.chr(10);
            foreach($history as $item) {
                $data .= date('m/d/Y H:i', $item['Time']).',';
                $data .= $item['Type'].',';
                $data .= $item['batch'].',';
                $data .= $item['Currency'].',';
                $data .= $item['Amount'].',';
                $data .= $item['Fee'].',';
                $data .= $item['Payer_Account'].',';
                $data .= $item['Payee_Account'].',';
                $data .= $item['id'].',';
                $data .= $item['Memo'].chr(10);
            }
            send_csv($data);
            return 1;
        } else {
            echo 'Error: Period between starting and ending date can not be more than 30 days';
        }
    } else {
        echo 'Error: Can not login with passed AccountID and PassPhrase';
    }
} else {
    echo 'Error: Can not login with passed AccountID and PassPhrase';
}