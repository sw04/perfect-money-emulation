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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `accounts` (`id`, `accountid`, `passphrase`) VALUES
(1,	1111,	'1111');

DROP TABLE IF EXISTS `wallets`;
CREATE TABLE `wallets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `accountid` int(16) NOT NULL,
  `wallet` varchar(10) NOT NULL,
  `balance` float NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `wallets` (`id`, `accountid`, `wallet`, `balance`) VALUES
(3,	1111,	'U1555753',	123);

-- 2014-08-30 10:17:19
