<?php
include getenv('DOCUMENT_ROOT').'/acct/functions.php';

echo "<html>\n<head>\n  <title>Balance</title>\n</head>\n<body>\n<h1>Balance</h1>\n";

if (array_key_exists('AccountID', $_GET) and array_key_exists('PassPhrase', $_GET)){
    $login = intval($_GET['AccountID']);
    $password = filter_var($_GET['PassPhrase'], FILTER_SANITIZE_STRING);
    if (can_login($login, $password)) {
        $balances = get_balance($login);

        echo "<table border=1>\n<tr><td><b>Account No.</b></td><td><b>Balance</b></td></tr>";
        foreach($balances as $item) {
            echo "<tr><td>".$item['wallet']."</td><td>".sprintf("%0.2f",$item['balance'])."</td></tr>\n";
        }
        echo "</table>\n";
        foreach($balances as $item) {
            echo "<input name='".$item['wallet']."' type='hidden' value='".sprintf("%0.2f",$item['balance'])."'>\n";
        }
    } else {
        echo_error('Can not login with passed AccountID and PassPhrase');
    }
} else {
    echo_error('No values passed to API');
}
echo "\n</body>\n</html>";