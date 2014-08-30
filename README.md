PerfectMoney emulation

requirements:

1. php 5.4+
2. mysql 5.1+

installation:

1. create database, import dump /_sql/perfectmoney.sql
2. add type application/x-httpd-php for /acct/*.asp files

complete methods:

1. Get balance for all your accounts (sample, /acct/balance.asp?AccountID=1111&PassPhrase=1111)
2. Transfer funds to another account (sample, /acct/confirm.asp?AccountID=1111&PassPhrase=1111&Payer_Account=U1111&Payee_Account=U2222&Amount=1)

Todo:

1. Get history in CSV format
