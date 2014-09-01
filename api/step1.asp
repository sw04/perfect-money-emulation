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
?>
    <form action="/api/step2.asp" method="post">
        <?php foreach($_POST as $index => $item) : ?>
            <input type="hidden" name="<?=$index?>" value="<?=filter_var($item, FILTER_SANITIZE_STRING)?>">
        <?php endforeach; ?>
        <p>
            AccountId:<input type="text" name="AccountID" value="<?=intval($_POST['AccountID'])?>">
        </p>
        <p>
            PassPhrase:<input type="text" name="PassPhrase" value="<?=filter_var($_POST['PassPhrase'], FILTER_SANITIZE_STRING)?>">
        </p>
        <p>
            Amount:<input type="text" name="Amount" value="<?=$_POST['Amount']?>" />
        </p>
        <p><input type="submit" value="Pay" /></p>
    </form>
<?php
}