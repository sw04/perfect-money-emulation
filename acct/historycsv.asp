<?php
include getenv('DOCUMENT_ROOT').'/acct/functions.php';
//startmonth=8&startday=10&startyear=2014&endmonth=9&endday=10&endyear=2014&AccountID=705512&PassPhrase=aHYfZMjZFW3K?startmonth=8&startday=10&startyear=2014&endmonth=9&endday=10&endyear=2014&AccountID=705512&PassPhrase=aHYfZMjZFW3K
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
            //TODO add send svc file
        } else {
            echo 'Error: Period between starting and ending date can not be more than 30 days';
        }
    } else {
        echo 'Error: Can not login with passed AccountID and PassPhrase';
    }
} else {
    echo 'Error: Can not login with passed AccountID and PassPhrase';
}