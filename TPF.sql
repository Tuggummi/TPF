-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.27-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping structure for table accounts
CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transaction-id` varchar(50) DEFAULT NULL,
  `steamid` varchar(255) DEFAULT NULL,
  `firstname` varchar(255) DEFAULT NULL,
  `lastname` varchar(255) DEFAULT NULL,
  `balance` float DEFAULT 0,
  `cash` float DEFAULT 0,
  `job` varchar(255) DEFAULT NULL,
  `job_level` varchar(255) DEFAULT '0',
  `last_paycheck` varchar(255) DEFAULT NULL,
  `cindex` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table identifiers
CREATE TABLE IF NOT EXISTS `identifiers` (
  `steamname` varchar(40) DEFAULT NULL,
  `steamid` varchar(40) NOT NULL,
  `license` varchar(50) DEFAULT NULL,
  `license2` varchar(50) DEFAULT NULL,
  `discord` varchar(40) DEFAULT NULL,
  `fivem` varchar(40) DEFAULT NULL,
  `xbl` varchar(40) DEFAULT NULL,
  `ip` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`steamid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table job
CREATE TABLE IF NOT EXISTS `job` (
  `title` varchar(50) DEFAULT NULL,
  `job_name` varchar(50) DEFAULT NULL,
  `job_level` varchar(50) DEFAULT NULL,
  `salary` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Dumping data for table job: ~16 rows (approximately)
/*!40000 ALTER TABLE `job` DISABLE KEYS */;
INSERT INTO `job` (`title`, `job_name`, `job_level`, `salary`) VALUES
	('Arbetsförmedlingen', 'unemployed', '0', 2000),
	('Undersökterska', 'ambulance', '0', 2000),
	('Sjuksköterska', 'ambulance', '1', 3000),
	('Sjukvårdare', 'ambulance', '2', 5000),
	('Läkare', 'ambulance', '3', 7000),
	('Överläkare', 'ambulance', '4', 9000),
	('Biträdande Regionschef', 'ambulance', '5', 12000),
	('Regionschef', 'ambulance', '6', 17000),
	('Polisassistent', 'police', '0', 2500),
	('Polis', 'police', '1', 4000),
	('Polisinspektör', 'police', '2', 6000),
	('Kriminalinspektör', 'police', '3', 8000),
	('Polisintendent', 'police', '4', 10000),
	('Biträdande Rikspolischef', 'police', '5', 15000),
	('Rikspolischef', 'police', '6', 20000),
	('Utvecklare', 'developer', '0', 20000);
/*!40000 ALTER TABLE `job` ENABLE KEYS */;


-- Dumping structure for table transactions
CREATE TABLE IF NOT EXISTS `transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transaction-id` varchar(255) DEFAULT NULL,
  `steamid` varchar(255) DEFAULT NULL,
  `amount` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `reciver` varchar(255) DEFAULT NULL,
  `note` varchar(2555) DEFAULT NULL,
  `date` varchar(255) DEFAULT NULL,
  `cindex` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=160 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- Data exporting was unselected.

-- Dumping structure for table users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `steamname` varchar(40) DEFAULT NULL,
  `steamid` varchar(40) NOT NULL,
  `firstname` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  `age` int(11) DEFAULT NULL,
  `dob` varchar(50) DEFAULT NULL,
  `gender` varchar(50) DEFAULT NULL,
  `job` varchar(50) DEFAULT 'unemployed',
  `lastpos` varchar(255) DEFAULT NULL,
  `model` varchar(255) DEFAULT 'a_f_m_bodybuild_01',
  `weapons` varchar(10000) DEFAULT 'weapon_bottle,weapon_flashlight',
  `active` varchar(255) DEFAULT '0',
  `cindex` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data exporting was unselected.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
