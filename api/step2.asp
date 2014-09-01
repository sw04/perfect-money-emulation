<?php
if (!empty($_POST)) {
    $req = [
        'AccountID',
        'PassPhrase',
        'Payer_Account',
        'Payee_Account',
        'Amount',
        'STATUS_URL',
        'PAYMENT_URL',
        'PAYMENT_URL_METHOD',
        'NOPAYMENT_URL',
        'NOPAYMENT_URL_METHOD'
    ];
    $error = '';
    foreach($req as $item) {
        if (!array_key_exists($item, $_POST)) {
            $error = 'Error: Invalid '.$item;
            break;
        }
    }
    if ($error != '') {
        echo $error;
        return 0;
    }

    $accountid = intval($_POST['AccountID']);
    $passphrase = filter_var($_POST['PassPhrase'], FILTER_SANITIZE_STRING);
    $Payer_Account = filter_var($_POST['Payer_Account'], FILTER_SANITIZE_STRING);
    $Payee_Account = filter_var($_POST['Payee_Account'], FILTER_SANITIZE_STRING);
    $Amount = floatval($_POST['Amount']);
    $baggage = get_baggage_fields();

    //transfer funds
    if (can_login($accountid, $passphrase)) {
        $balances = get_balance($accountid);
        foreach ($balances as $item) {
            if ($item['wallet'] == $Payer_Account) {
                if ($item['balance'] > $Amount*1.005) {
                    $transfer_result = transfer_funds($accountid, $Payer_Account, $Amount, $Payee_Account);

                    if (array_key_exists('error', $transfer_result)) {
                        echo_error($transfer_result['error']);
                        break;
                    } else {
                        echo send_transfer_result($transfer_result, $baggage);
                        break;
                    }
                } else {
                    echo_error('Not enough money to pay');
                    return 0;
                }
            }
        }
    } else {
        echo_error('Can not login with passed AccountID and PassPhrase');
        return 0;
    }
    return 1;
}
echo 'Not correct data';

