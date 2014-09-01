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
  `alternative_phrase` varchar(52) NOT NULL DEFAULT 'hyip',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


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


DROP TABLE IF EXISTS `wallets`;
CREATE TABLE `wallets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accountid` int(16) NOT NULL,
  `wallet` varchar(10) NOT NULL,
  `balance` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


-- 2014-09-01 10:31:42
