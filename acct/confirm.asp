<?php
include getenv('DOCUMENT_ROOT').'/acct/functions.php';

echo "<html>\n\n<head>\n  <title>Spend</title>\n</head>\n\n<body>\n\n<h1>Spend</h1>\n\n";
if (array_key_exists('AccountID', $_GET) and array_key_exists('PassPhrase', $_GET)){
    $login = intval($_GET['AccountID']);
    $password = filter_var($_GET['PassPhrase'], FILTER_SANITIZE_STRING);

    if (!array_key_exists('Amount', $_GET)) {
        echo_error('Invalid Amount');
    } else {
        $Amount = floatval($_GET['Amount']);

        if (!array_key_exists('Payer_Account', $_GET)) {
            echo_error('Invalid Payer_Account');
        } else {
            $Payer_Account = filter_var($_GET['Payer_Account'], FILTER_SANITIZE_STRING);
            if (can_login($login, $password)) {
                $balances = get_balance($login);
                $error = 'Invalid Payer_Account';
                foreach ($balances as $item) {
                    if ($item['wallet'] == $Payer_Account) {
                        if ($item['balance'] > $Amount) {
                            if (!array_key_exists('Payee_Account', $_GET)) {
                                echo_error('Invalid Payee_Account');
                                return 0;
                            } else {
                                $Payee_Account = filter_var($_GET['Payee_Account'], FILTER_SANITIZE_STRING);
                                $transfer_result = transfer_funds($login, $Payer_Account, $Amount, $Payee_Account);

                                if (array_key_exists('error', $transfer_result)) {
                                    echo_error($transfer_result['error']);
                                    return 0;
                                } else {
                                    echo "<table border=1>\n<tr><td><b>Name</b></td><td><b>Value</b></td></tr><tr><td>Payee_Account_Name</td><td>".$transfer_result['Payee_Account_Name']." account</td></tr>\n";
                                    //get data
                                    echo "<tr><td>Payee_Account</td><td>".$transfer_result['Payee_Account']."</td></tr>\n";
                                    echo "<tr><td>Payer_Account</td><td>".$transfer_result['Payer_Account']."</td></tr>\n";
                                    echo "<tr><td>PAYMENT_AMOUNT</td><td>".$transfer_result['PAYMENT_AMOUNT']."</td></tr>\n";
                                    echo "<tr><td>PAYMENT_BATCH_NUM</td><td>".$transfer_result['PAYMENT_BATCH_NUM']."</td></tr>\n";
                                    echo "<tr><td>PAYMENT_ID</td><td></td></tr>";
                                    echo "</table>\n";
                                    //
                                    echo "<input name='Payee_Account_Name' type='hidden' value='".$transfer_result['Payee_Account_Name']." account'>\n";
                                    echo "<input name='Payee_Account' type='hidden' value='".$transfer_result['Payee_Account']."'>\n";
                                    echo "<input name='Payer_Account' type='hidden' value='".$transfer_result['Payer_Account']."'>\n";
                                    echo "<input name='PAYMENT_AMOUNT' type='hidden' value='".$transfer_result['PAYMENT_AMOUNT']."'>\n";
                                    echo "<input name='PAYMENT_BATCH_NUM' type='hidden' value='".$transfer_result['PAYMENT_BATCH_NUM']."'>\n";
                                    echo "<input name='PAYMENT_ID' type='hidden' value=''>\n";
                                    return 1;
                                }
                            }
                        } else {
                            echo_error('Not enough money to pay');
                            return 0;
                        }
                    }
                }
            } else {
                echo_error('Can not login with passed AccountID and PassPhrase');
            }
        }
    }
} else {
    echo_error('Can not login with passed AccountID and PassPhrase');
}
echo "</body>\n\n</html>";