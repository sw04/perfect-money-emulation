-- Adminer 4.1.0 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `accounts`;
CREATE TABLE `accounts` (
  `id` int(16) NOT NULL AUTO_INCREMENT,
  `accountid` int(16) NOT NULL,
  `passphrase` varchar(512) NOT NULL,
  `name` varchar(16) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `accounts` (`id`, `accountid`, `passphrase`, `name`) VALUES
(1,	1111,	'1111',	'some data'),
(2,	2222,	'2222',	'account2');

DROP TABLE IF EXISTS `history`;
CREATE TABLE `history` (
  `id` int(12) NOT NULL AUTO_INCREMENT,
  `Time` int(32) NOT NULL,
  `Type` varchar(6) NOT NULL,
  `Currency` varchar(4) NOT NULL,
  `Amount` float NOT NULL,
  `Fee` float NOT NULL,
  `Payer_Account` varchar(12) NOT NULL,
  `Payee_Account` varchar(12) NOT NULL,
  `Memo` varchar(255) NOT NULL,
  `batch` int(12) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `history` (`id`, `Time`, `Type`, `Currency`, `Amount`, `Fee`, `Payer_Account`, `Payee_Account`, `Memo`, `batch`) VALUES
(1,	1409400228,	'Income',	'USD',	1,	0.01,	'U1111',	'U2222',	'Sent Payment 1 USD from account U1111. Memo: API Payment.',	1),
(2,	1409400228,	'Charge',	'USD',	-1,	0,	'U2222',	'U1111',	'Sent Payment 1 USD to account U1111. Memo: API Payment.',	1),
(3,	1409400277,	'Income',	'USD',	1,	0.01,	'U1111',	'U2222',	'Sent Payment 1.00 USD from account U1111. Memo: API Payment.',	2),
(4,	1409400277,	'Charge',	'USD',	-1,	0,	'U2222',	'U1111',	'Sent Payment 1 USD to account U1111. Memo: API Payment.',	3),
(5,	1409400363,	'Income',	'USD',	1,	0.01,	'U1111',	'U2222',	'Sent Payment 1.00 USD from account U1111. Memo: API Payment.',	4),
(6,	1409400363,	'Charge',	'USD',	-1,	0,	'U2222',	'U1111',	'Sent Payment 1 USD to account U1111. Memo: API Payment.',	5),
(7,	1409400406,	'Income',	'USD',	1,	0.01,	'U1111',	'U2222',	'Sent Payment 1.00 USD from account U1111. Memo: API Payment.',	6),
(8,	1409400406,	'Charge',	'USD',	-1,	0,	'U2222',	'U1111',	'Sent Payment 1 USD to account U1111. Memo: API Payment.',	7),
(9,	1409400538,	'Income',	'USD',	1,	0.01,	'U1111',	'U2222',	'Sent Payment 1.00 USD from account U1111. Memo: API Payment.',	1),
(10,	1409400538,	'Charge',	'USD',	-1,	0,	'U2222',	'U1111',	'Sent Payment 1 USD to account U1111. Memo: API Payment.',	1),
(11,	1409400543,	'Income',	'USD',	1,	0.01,	'U1111',	'U2222',	'Sent Payment 1.00 USD from account U1111. Memo: API Payment.',	1),
(12,	1409400543,	'Charge',	'USD',	-1,	0,	'U2222',	'U1111',	'Sent Payment 1 USD to account U1111. Memo: API Payment.',	1),
(13,	1409400602,	'Income',	'USD',	1,	0.01,	'U1111',	'U2222',	'Sent Payment 1.00 USD from account U1111. Memo: API Payment.',	1),
(14,	1409400602,	'Charge',	'USD',	-1,	0,	'U2222',	'U1111',	'Sent Payment 1 USD to account U1111. Memo: API Payment.',	1),
(15,	1409400624,	'Income',	'USD',	1,	0.01,	'U1111',	'U2222',	'Sent Payment 1.00 USD from account U1111. Memo: API Payment.',	1),
(16,	1409400624,	'Charge',	'USD',	-1,	0,	'U2222',	'U1111',	'Sent Payment 1 USD to account U1111. Memo: API Payment.',	1),
(17,	1409400625,	'Income',	'USD',	1,	0.01,	'U1111',	'U2222',	'Sent Payment 1.00 USD from account U1111. Memo: API Payment.',	1),
(18,	1409400625,	'Charge',	'USD',	-1,	0,	'U2222',	'U1111',	'Sent Payment 1 USD to account U1111. Memo: API Payment.',	1),
(19,	1409400680,	'Income',	'USD',	1,	0.01,	'U1111',	'U2222',	'Sent Payment 1.00 USD from account U1111. Memo: API Payment.',	1),
(20,	1409400680,	'Charge',	'USD',	-1,	0,	'U2222',	'U1111',	'Sent Payment 1 USD to account U1111. Memo: API Payment.',	1),
(21,	1409400681,	'Income',	'USD',	1,	0.01,	'U1111',	'U2222',	'Sent Payment 1.00 USD from account U1111. Memo: API Payment.',	1),
(22,	1409400681,	'Charge',	'USD',	-1,	0,	'U2222',	'U1111',	'Sent Payment 1 USD to account U1111. Memo: API Payment.',	1),
(23,	1409400694,	'Income',	'USD',	1,	0.01,	'U1111',	'U2222',	'Sent Payment 1.00 USD from account U1111. Memo: API Payment.',	23),
(24,	1409400694,	'Charge',	'USD',	-1,	0,	'U2222',	'U1111',	'Sent Payment 1 USD to account U1111. Memo: API Payment.',	23),
(25,	1409400695,	'Income',	'USD',	1,	0.01,	'U1111',	'U2222',	'Sent Payment 1.00 USD from account U1111. Memo: API Payment.',	25),
(26,	1409400695,	'Charge',	'USD',	-1,	0,	'U2222',	'U1111',	'Sent Payment 1 USD to account U1111. Memo: API Payment.',	25),
(27,	1409400696,	'Income',	'USD',	1,	0.01,	'U1111',	'U2222',	'Sent Payment 1.00 USD from account U1111. Memo: API Payment.',	27),
(28,	1409400696,	'Charge',	'USD',	-1,	0,	'U2222',	'U1111',	'Sent Payment 1 USD to account U1111. Memo: API Payment.',	27),
(29,	1409401059,	'Income',	'USD',	1,	0.01,	'U1111',	'U2222',	'Sent Payment 1.00 USD from account U1111. Memo: API Payment.',	29),
(30,	1409401059,	'Charge',	'USD',	-1,	0,	'U2222',	'U1111',	'Sent Payment 1 USD to account U2222. Memo: API Payment.',	29),
(31,	1409401179,	'Income',	'USD',	1,	0.01,	'U1111',	'U2222',	'Sent Payment 1.00 USD from account U1111. Memo: API Payment.',	31),
(32,	1409401179,	'Charge',	'USD',	-1,	0,	'U2222',	'U1111',	'Sent Payment 1 USD to account U2222. Memo: API Payment.',	31),
(33,	1409407538,	'Income',	'USD',	1.5,	0.01,	'U1111',	'U2222',	'Sent Payment 1.50 USD from account U1111. Memo: API Payment.',	33),
(34,	1409407538,	'Charge',	'USD',	-1.5,	0,	'U2222',	'U1111',	'Sent Payment 1.5 USD to account U2222. Memo: API Payment.',	33);

DROP TABLE IF EXISTS `wallets`;
CREATE TABLE `wallets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accountid` int(16) NOT NULL,
  `wallet` varchar(10) NOT NULL,
  `balance` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `wallets` (`id`, `accountid`, `wallet`, `balance`) VALUES
(3,	1111,	'U1111',	105.5),
(4,	2222,	'U2222',	17.5);

-- 2014-09-01 03:38:29
