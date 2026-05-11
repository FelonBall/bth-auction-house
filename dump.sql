-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: auction_house
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `auction_house`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `auction_house` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `auction_house`;

--
-- Table structure for table `auctions`
--

DROP TABLE IF EXISTS `auctions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auctions` (
  `auction_id` int NOT NULL AUTO_INCREMENT,
  `item_id` int NOT NULL,
  `start_price` int NOT NULL,
  `current_price` int NOT NULL,
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `status` enum('active','closed','cancelled') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  `high_bidder_id` int DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`auction_id`),
  UNIQUE KEY `uq_auctions_item` (`item_id`),
  KEY `ix_auctions_status_endtime` (`status`,`end_time`),
  KEY `ix_auctions_high_bidder` (`high_bidder_id`),
  CONSTRAINT `fk_auctions_high_bidder` FOREIGN KEY (`high_bidder_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_auctions_item` FOREIGN KEY (`item_id`) REFERENCES `items` (`item_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_auctions_prices` CHECK (((`start_price` > 0) and (`current_price` >= `start_price`))),
  CONSTRAINT `chk_auctions_times` CHECK ((`end_time` > `start_time`))
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auctions`
--

LOCK TABLES `auctions` WRITE;
/*!40000 ALTER TABLE `auctions` DISABLE KEYS */;
INSERT INTO `auctions` VALUES (1,1,3820,3820,'2026-05-07 04:47:50','2026-05-25 15:47:50','active',NULL,'2026-05-11 11:47:49'),(2,2,200,450,'2026-05-09 22:47:50','2026-06-05 12:47:50','active',15,'2026-05-11 11:47:49'),(3,3,1060,1500,'2026-05-03 11:47:50','2026-06-07 04:47:50','active',2,'2026-05-11 11:47:49'),(4,4,1470,2560,'2026-04-27 11:47:50','2026-05-10 11:47:50','closed',20,'2026-05-11 11:47:49'),(5,5,1150,2320,'2026-04-27 11:47:50','2026-05-06 11:47:50','closed',25,'2026-05-11 11:47:49'),(6,6,4380,5420,'2026-05-10 08:47:50','2026-05-30 22:47:50','active',5,'2026-05-11 11:47:49'),(7,7,680,930,'2026-04-27 11:47:50','2026-05-08 11:47:50','closed',3,'2026-05-11 11:47:49'),(8,8,4580,5500,'2026-05-02 15:47:50','2026-05-28 06:47:50','active',19,'2026-05-11 11:47:49'),(9,9,3430,3430,'2026-05-08 09:47:50','2026-06-09 12:47:50','active',NULL,'2026-05-11 11:47:49'),(10,10,2370,3460,'2026-05-07 23:47:50','2026-05-21 19:47:50','active',27,'2026-05-11 11:47:49'),(11,11,1410,1820,'2026-05-06 05:47:50','2026-05-30 08:47:50','active',1,'2026-05-11 11:47:49'),(12,12,3780,4650,'2026-05-02 06:47:50','2026-06-08 04:47:50','active',18,'2026-05-11 11:47:49'),(13,13,2900,2900,'2026-04-27 11:47:50','2026-05-09 11:47:50','closed',NULL,'2026-05-11 11:47:49'),(14,14,2100,2850,'2026-05-11 10:47:50','2026-05-25 21:47:50','active',10,'2026-05-11 11:47:49'),(15,15,3400,4290,'2026-05-02 01:47:50','2026-06-09 17:47:50','active',10,'2026-05-11 11:47:49'),(16,16,3860,4020,'2026-04-27 11:47:50','2026-05-09 11:47:50','closed',1,'2026-05-11 11:47:49'),(17,17,1900,2630,'2026-05-01 17:47:50','2026-05-31 23:47:50','active',8,'2026-05-11 11:47:49'),(18,18,830,1030,'2026-04-27 11:47:50','2026-05-07 11:47:50','closed',20,'2026-05-11 11:47:49'),(19,19,3100,3460,'2026-05-01 23:47:50','2026-05-20 23:47:50','active',6,'2026-05-11 11:47:49'),(20,20,630,880,'2026-04-27 11:47:50','2026-05-08 11:47:50','closed',28,'2026-05-11 11:47:49'),(21,21,2270,2560,'2026-05-01 08:47:50','2026-05-28 20:47:50','active',1,'2026-05-11 11:47:49'),(22,22,4720,5300,'2026-05-07 06:47:50','2026-06-04 03:47:50','active',20,'2026-05-11 11:47:49'),(23,23,830,1340,'2026-04-27 11:47:50','2026-05-09 11:47:50','closed',21,'2026-05-11 11:47:49'),(24,24,2550,2740,'2026-04-27 11:47:50','2026-05-10 11:47:50','closed',27,'2026-05-11 11:47:49'),(25,25,4540,4540,'2026-05-07 10:47:50','2026-05-25 18:47:50','active',NULL,'2026-05-11 11:47:49'),(26,26,700,1350,'2026-04-27 11:47:50','2026-05-10 11:47:50','closed',29,'2026-05-11 11:47:49'),(27,27,2210,2980,'2026-05-08 19:47:50','2026-05-27 06:47:50','active',25,'2026-05-11 11:47:49'),(28,28,1960,3260,'2026-04-27 11:47:50','2026-05-06 11:47:50','closed',28,'2026-05-11 11:47:49'),(29,29,1780,1870,'2026-04-27 11:47:50','2026-05-09 11:47:50','closed',30,'2026-05-11 11:47:49'),(30,30,410,1250,'2026-05-08 04:47:50','2026-06-05 11:47:50','active',8,'2026-05-11 11:47:49'),(31,31,410,890,'2026-04-27 11:47:50','2026-05-09 11:47:50','closed',17,'2026-05-11 11:47:49'),(32,32,720,1150,'2026-05-01 05:47:50','2026-06-03 04:47:50','active',19,'2026-05-11 11:47:49'),(33,33,1020,1620,'2026-05-03 20:47:50','2026-05-26 00:47:50','active',15,'2026-05-11 11:47:49'),(34,34,4470,4470,'2026-05-05 22:47:50','2026-06-01 01:47:50','active',NULL,'2026-05-11 11:47:49'),(35,35,4140,4240,'2026-04-27 11:47:50','2026-05-06 11:47:50','closed',8,'2026-05-11 11:47:49'),(36,36,760,1750,'2026-04-27 11:47:50','2026-05-10 11:47:50','closed',24,'2026-05-11 11:47:49'),(37,37,4180,5030,'2026-05-04 09:47:50','2026-05-26 01:47:50','active',26,'2026-05-11 11:47:49'),(38,38,520,830,'2026-05-10 18:47:50','2026-06-07 11:47:50','active',16,'2026-05-11 11:47:49'),(39,39,4470,5200,'2026-05-04 20:47:50','2026-06-02 17:47:50','active',27,'2026-05-11 11:47:49'),(40,40,4790,5110,'2026-05-04 23:47:50','2026-05-18 19:47:50','active',1,'2026-05-11 11:47:49'),(41,41,3430,4420,'2026-05-04 12:47:50','2026-06-10 04:47:50','active',19,'2026-05-11 11:47:49'),(42,42,3010,3470,'2026-04-27 11:47:50','2026-05-08 11:47:50','closed',29,'2026-05-11 11:47:49'),(43,43,2490,3370,'2026-05-06 10:47:50','2026-05-20 05:47:50','active',10,'2026-05-11 11:47:49'),(44,44,400,480,'2026-04-27 11:47:50','2026-05-09 11:47:50','closed',4,'2026-05-11 11:47:49'),(45,45,3010,4480,'2026-05-04 17:47:50','2026-05-21 18:47:50','active',19,'2026-05-11 11:47:49'),(46,46,2940,2940,'2026-05-09 14:47:50','2026-06-01 05:47:50','active',NULL,'2026-05-11 11:47:49'),(47,47,1270,1520,'2026-05-07 13:47:50','2026-06-08 21:47:50','active',7,'2026-05-11 11:47:49'),(48,48,1660,1860,'2026-04-27 11:47:50','2026-05-06 11:47:50','closed',6,'2026-05-11 11:47:49'),(49,49,420,1450,'2026-05-03 17:47:50','2026-06-06 14:47:50','active',28,'2026-05-11 11:47:49'),(50,50,4550,5280,'2026-04-27 11:47:50','2026-05-10 11:47:50','closed',22,'2026-05-11 11:47:49'),(51,51,1590,1730,'2026-05-08 18:47:50','2026-06-02 09:47:50','active',3,'2026-05-11 11:47:49'),(52,52,4820,4820,'2026-05-10 18:47:50','2026-06-08 20:47:50','active',NULL,'2026-05-11 11:47:49'),(53,53,2880,3220,'2026-04-27 11:47:50','2026-05-09 11:47:50','closed',28,'2026-05-11 11:47:49'),(54,54,1090,1620,'2026-04-27 11:47:50','2026-05-10 11:47:50','closed',10,'2026-05-11 11:47:49'),(55,55,520,1640,'2026-04-27 11:47:50','2026-05-06 11:47:50','closed',28,'2026-05-11 11:47:49'),(56,56,3310,3310,'2026-05-11 01:47:50','2026-05-18 15:47:50','active',NULL,'2026-05-11 11:47:49'),(57,57,90,760,'2026-05-02 22:47:50','2026-06-10 04:47:50','active',22,'2026-05-11 11:47:49'),(58,58,2870,3930,'2026-04-27 11:47:50','2026-05-09 11:47:50','closed',23,'2026-05-11 11:47:49'),(59,59,4650,4710,'2026-04-27 11:47:50','2026-05-09 11:47:50','closed',12,'2026-05-11 11:47:49'),(60,60,4570,5330,'2026-05-01 00:47:50','2026-05-22 04:47:50','active',11,'2026-05-11 11:47:49'),(61,61,4560,5100,'2026-04-27 11:47:50','2026-05-08 11:47:50','closed',22,'2026-05-11 11:47:49'),(62,62,4200,5160,'2026-05-05 14:47:50','2026-06-01 10:47:50','active',19,'2026-05-11 11:47:49'),(63,63,1180,1510,'2026-04-27 11:47:50','2026-05-06 11:47:50','closed',17,'2026-05-11 11:47:49'),(64,64,3420,3430,'2026-05-07 04:47:50','2026-05-25 11:47:50','active',22,'2026-05-11 11:47:49'),(65,65,3330,3670,'2026-05-07 03:47:50','2026-05-20 22:47:50','active',19,'2026-05-11 11:47:49'),(66,66,960,1520,'2026-05-06 08:47:50','2026-05-18 19:47:50','active',24,'2026-05-11 11:47:49'),(67,67,3780,4340,'2026-05-09 22:47:50','2026-06-06 22:47:50','active',5,'2026-05-11 11:47:49'),(68,68,4650,5360,'2026-05-02 08:47:50','2026-06-03 23:47:50','active',11,'2026-05-11 11:47:49'),(69,69,2710,3810,'2026-04-27 11:47:50','2026-05-10 11:47:50','closed',11,'2026-05-11 11:47:49'),(70,70,4760,5800,'2026-04-27 11:47:50','2026-05-10 11:47:50','closed',11,'2026-05-11 11:47:49'),(71,71,2640,3830,'2026-04-30 12:47:50','2026-05-21 20:47:50','active',12,'2026-05-11 11:47:49'),(72,72,2880,3030,'2026-05-05 13:47:50','2026-05-30 20:47:50','active',4,'2026-05-11 11:47:49'),(73,73,4670,5860,'2026-04-27 11:47:50','2026-05-09 11:47:50','closed',22,'2026-05-11 11:47:49'),(74,74,1600,1710,'2026-05-06 18:47:50','2026-05-30 11:47:50','active',29,'2026-05-11 11:47:49'),(75,75,2430,3780,'2026-04-27 11:47:50','2026-05-09 11:47:50','closed',25,'2026-05-11 11:47:49'),(76,76,3420,3560,'2026-05-02 12:47:50','2026-06-02 16:47:50','active',4,'2026-05-11 11:47:49'),(77,77,520,670,'2026-04-30 16:47:50','2026-06-07 21:47:50','active',7,'2026-05-11 11:47:49'),(78,78,280,540,'2026-04-27 11:47:50','2026-05-09 11:47:50','closed',12,'2026-05-11 11:47:49'),(79,79,2990,3720,'2026-04-27 11:47:50','2026-05-09 11:47:50','closed',29,'2026-05-11 11:47:49'),(80,80,3570,4480,'2026-05-05 07:47:50','2026-05-26 07:47:50','active',10,'2026-05-11 11:47:49');
/*!40000 ALTER TABLE `auctions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bids`
--

DROP TABLE IF EXISTS `bids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bids` (
  `bid_id` int NOT NULL AUTO_INCREMENT,
  `auction_id` int NOT NULL,
  `bidder_id` int NOT NULL,
  `amount` int NOT NULL,
  `placed_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`bid_id`),
  KEY `ix_bids_auction` (`auction_id`),
  KEY `ix_bids_bidder` (`bidder_id`),
  KEY `ix_bids_auction_amount` (`auction_id`,`amount`),
  CONSTRAINT `fk_bids_auction` FOREIGN KEY (`auction_id`) REFERENCES `auctions` (`auction_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_bids_bidder` FOREIGN KEY (`bidder_id`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_bids_amount` CHECK ((`amount` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=326 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bids`
--

LOCK TABLES `bids` WRITE;
/*!40000 ALTER TABLE `bids` DISABLE KEYS */;
INSERT INTO `bids` VALUES (1,2,15,450,'2026-05-11 11:47:49'),(2,3,27,1120,'2026-05-11 11:47:49'),(3,3,18,1350,'2026-05-11 11:47:49'),(4,3,2,1500,'2026-05-11 11:47:49'),(5,4,29,1550,'2026-05-11 11:47:49'),(6,4,15,1590,'2026-05-11 11:47:49'),(7,4,27,1640,'2026-05-11 11:47:49'),(8,4,22,1790,'2026-05-11 11:47:49'),(9,4,18,1960,'2026-05-11 11:47:49'),(10,4,11,2160,'2026-05-11 11:47:49'),(11,4,30,2410,'2026-05-11 11:47:49'),(12,4,20,2560,'2026-05-11 11:47:49'),(13,5,28,1290,'2026-05-11 11:47:49'),(14,5,15,1470,'2026-05-11 11:47:49'),(15,5,24,1530,'2026-05-11 11:47:49'),(16,5,15,1690,'2026-05-11 11:47:49'),(17,5,25,1780,'2026-05-11 11:47:49'),(18,5,28,1860,'2026-05-11 11:47:49'),(19,5,9,2070,'2026-05-11 11:47:49'),(20,5,25,2320,'2026-05-11 11:47:49'),(21,6,21,4540,'2026-05-11 11:47:49'),(22,6,9,4620,'2026-05-11 11:47:49'),(23,6,3,4770,'2026-05-11 11:47:49'),(24,6,10,5000,'2026-05-11 11:47:49'),(25,6,9,5080,'2026-05-11 11:47:49'),(26,6,11,5190,'2026-05-11 11:47:49'),(27,6,3,5370,'2026-05-11 11:47:49'),(28,6,5,5420,'2026-05-11 11:47:49'),(29,7,24,810,'2026-05-11 11:47:49'),(30,7,24,860,'2026-05-11 11:47:49'),(31,7,3,930,'2026-05-11 11:47:49'),(32,8,11,4720,'2026-05-11 11:47:49'),(33,8,15,4900,'2026-05-11 11:47:49'),(34,8,2,5040,'2026-05-11 11:47:49'),(35,8,27,5110,'2026-05-11 11:47:49'),(36,8,13,5250,'2026-05-11 11:47:49'),(37,8,19,5500,'2026-05-11 11:47:49'),(38,10,1,2530,'2026-05-11 11:47:49'),(39,10,11,2650,'2026-05-11 11:47:49'),(40,10,14,2900,'2026-05-11 11:47:49'),(41,10,19,3040,'2026-05-11 11:47:49'),(42,10,25,3280,'2026-05-11 11:47:49'),(43,10,27,3460,'2026-05-11 11:47:49'),(44,11,8,1570,'2026-05-11 11:47:49'),(45,11,14,1660,'2026-05-11 11:47:49'),(46,11,1,1820,'2026-05-11 11:47:49'),(47,12,22,3890,'2026-05-11 11:47:49'),(48,12,27,4110,'2026-05-11 11:47:49'),(49,12,25,4240,'2026-05-11 11:47:49'),(50,12,28,4300,'2026-05-11 11:47:49'),(51,12,5,4450,'2026-05-11 11:47:49'),(52,12,18,4650,'2026-05-11 11:47:49'),(53,14,20,2290,'2026-05-11 11:47:49'),(54,14,1,2510,'2026-05-11 11:47:49'),(55,14,22,2540,'2026-05-11 11:47:49'),(56,14,5,2680,'2026-05-11 11:47:49'),(57,14,6,2830,'2026-05-11 11:47:49'),(58,14,10,2850,'2026-05-11 11:47:49'),(59,15,7,3510,'2026-05-11 11:47:49'),(60,15,12,3660,'2026-05-11 11:47:49'),(61,15,26,3770,'2026-05-11 11:47:49'),(62,15,10,3900,'2026-05-11 11:47:49'),(63,15,28,4150,'2026-05-11 11:47:49'),(64,15,10,4290,'2026-05-11 11:47:49'),(65,16,1,4020,'2026-05-11 11:47:49'),(66,17,12,1920,'2026-05-11 11:47:49'),(67,17,22,2000,'2026-05-11 11:47:49'),(68,17,26,2030,'2026-05-11 11:47:49'),(69,17,2,2240,'2026-05-11 11:47:49'),(70,17,1,2490,'2026-05-11 11:47:49'),(71,17,7,2570,'2026-05-11 11:47:49'),(72,17,21,2580,'2026-05-11 11:47:49'),(73,17,8,2630,'2026-05-11 11:47:49'),(74,18,23,990,'2026-05-11 11:47:49'),(75,18,20,1030,'2026-05-11 11:47:49'),(76,19,24,3250,'2026-05-11 11:47:49'),(77,19,26,3340,'2026-05-11 11:47:49'),(78,19,6,3460,'2026-05-11 11:47:49'),(79,20,28,880,'2026-05-11 11:47:49'),(80,21,4,2370,'2026-05-11 11:47:49'),(81,21,1,2560,'2026-05-11 11:47:49'),(82,22,23,4910,'2026-05-11 11:47:49'),(83,22,14,5040,'2026-05-11 11:47:49'),(84,22,8,5270,'2026-05-11 11:47:49'),(85,22,20,5300,'2026-05-11 11:47:49'),(86,23,24,870,'2026-05-11 11:47:49'),(87,23,11,1120,'2026-05-11 11:47:49'),(88,23,21,1340,'2026-05-11 11:47:49'),(89,24,27,2740,'2026-05-11 11:47:49'),(90,26,14,880,'2026-05-11 11:47:49'),(91,26,12,1100,'2026-05-11 11:47:49'),(92,26,17,1130,'2026-05-11 11:47:49'),(93,26,11,1340,'2026-05-11 11:47:49'),(94,26,29,1350,'2026-05-11 11:47:49'),(95,27,4,2370,'2026-05-11 11:47:49'),(96,27,12,2510,'2026-05-11 11:47:49'),(97,27,30,2720,'2026-05-11 11:47:49'),(98,27,24,2870,'2026-05-11 11:47:49'),(99,27,14,2920,'2026-05-11 11:47:49'),(100,27,25,2980,'2026-05-11 11:47:49'),(101,28,10,2170,'2026-05-11 11:47:49'),(102,28,27,2370,'2026-05-11 11:47:49'),(103,28,26,2550,'2026-05-11 11:47:49'),(104,28,16,2710,'2026-05-11 11:47:49'),(105,28,28,2850,'2026-05-11 11:47:49'),(106,28,20,3090,'2026-05-11 11:47:49'),(107,28,12,3180,'2026-05-11 11:47:49'),(108,28,28,3260,'2026-05-11 11:47:49'),(109,29,30,1870,'2026-05-11 11:47:49'),(110,30,26,490,'2026-05-11 11:47:49'),(111,30,20,640,'2026-05-11 11:47:49'),(112,30,23,840,'2026-05-11 11:47:49'),(113,30,12,970,'2026-05-11 11:47:49'),(114,30,17,980,'2026-05-11 11:47:49'),(115,30,7,1090,'2026-05-11 11:47:49'),(116,30,8,1250,'2026-05-11 11:47:49'),(117,31,11,500,'2026-05-11 11:47:49'),(118,31,30,590,'2026-05-11 11:47:49'),(119,31,24,790,'2026-05-11 11:47:49'),(120,31,18,880,'2026-05-11 11:47:49'),(121,31,17,890,'2026-05-11 11:47:49'),(122,32,8,750,'2026-05-11 11:47:49'),(123,32,14,990,'2026-05-11 11:47:49'),(124,32,19,1150,'2026-05-11 11:47:49'),(125,33,16,1250,'2026-05-11 11:47:49'),(126,33,23,1460,'2026-05-11 11:47:49'),(127,33,15,1620,'2026-05-11 11:47:49'),(128,35,8,4240,'2026-05-11 11:47:49'),(129,36,8,990,'2026-05-11 11:47:49'),(130,36,22,1090,'2026-05-11 11:47:49'),(131,36,12,1280,'2026-05-11 11:47:49'),(132,36,18,1440,'2026-05-11 11:47:49'),(133,36,12,1610,'2026-05-11 11:47:49'),(134,36,24,1750,'2026-05-11 11:47:49'),(135,37,12,4290,'2026-05-11 11:47:49'),(136,37,16,4520,'2026-05-11 11:47:49'),(137,37,10,4610,'2026-05-11 11:47:49'),(138,37,8,4700,'2026-05-11 11:47:49'),(139,37,25,4740,'2026-05-11 11:47:49'),(140,37,11,4810,'2026-05-11 11:47:49'),(141,37,25,4850,'2026-05-11 11:47:49'),(142,37,26,5030,'2026-05-11 11:47:49'),(143,38,7,590,'2026-05-11 11:47:49'),(144,38,16,830,'2026-05-11 11:47:49'),(145,39,19,4710,'2026-05-11 11:47:49'),(146,39,17,4960,'2026-05-11 11:47:49'),(147,39,10,5160,'2026-05-11 11:47:49'),(148,39,27,5200,'2026-05-11 11:47:49'),(149,40,8,4890,'2026-05-11 11:47:49'),(150,40,6,5010,'2026-05-11 11:47:49'),(151,40,1,5110,'2026-05-11 11:47:49'),(152,41,9,3480,'2026-05-11 11:47:49'),(153,41,2,3500,'2026-05-11 11:47:49'),(154,41,10,3680,'2026-05-11 11:47:49'),(155,41,5,3910,'2026-05-11 11:47:49'),(156,41,29,4120,'2026-05-11 11:47:49'),(157,41,16,4370,'2026-05-11 11:47:49'),(158,41,29,4410,'2026-05-11 11:47:49'),(159,41,19,4420,'2026-05-11 11:47:49'),(160,42,16,3170,'2026-05-11 11:47:49'),(161,42,11,3320,'2026-05-11 11:47:49'),(162,42,2,3380,'2026-05-11 11:47:49'),(163,42,29,3470,'2026-05-11 11:47:49'),(164,43,28,2530,'2026-05-11 11:47:49'),(165,43,13,2560,'2026-05-11 11:47:49'),(166,43,3,2720,'2026-05-11 11:47:49'),(167,43,21,2910,'2026-05-11 11:47:49'),(168,43,2,3130,'2026-05-11 11:47:49'),(169,43,5,3180,'2026-05-11 11:47:49'),(170,43,10,3370,'2026-05-11 11:47:49'),(171,44,4,480,'2026-05-11 11:47:49'),(172,45,14,3260,'2026-05-11 11:47:49'),(173,45,21,3460,'2026-05-11 11:47:49'),(174,45,8,3660,'2026-05-11 11:47:49'),(175,45,17,3910,'2026-05-11 11:47:49'),(176,45,15,4040,'2026-05-11 11:47:49'),(177,45,10,4190,'2026-05-11 11:47:49'),(178,45,14,4380,'2026-05-11 11:47:49'),(179,45,19,4480,'2026-05-11 11:47:49'),(180,47,7,1520,'2026-05-11 11:47:49'),(181,48,23,1750,'2026-05-11 11:47:49'),(182,48,6,1780,'2026-05-11 11:47:49'),(183,48,6,1860,'2026-05-11 11:47:49'),(184,49,6,450,'2026-05-11 11:47:49'),(185,49,14,460,'2026-05-11 11:47:49'),(186,49,23,610,'2026-05-11 11:47:49'),(187,49,16,810,'2026-05-11 11:47:49'),(188,49,2,910,'2026-05-11 11:47:49'),(189,49,10,990,'2026-05-11 11:47:49'),(190,49,10,1220,'2026-05-11 11:47:49'),(191,49,28,1450,'2026-05-11 11:47:49'),(192,50,23,4580,'2026-05-11 11:47:49'),(193,50,9,4660,'2026-05-11 11:47:49'),(194,50,20,4870,'2026-05-11 11:47:49'),(195,50,27,5090,'2026-05-11 11:47:49'),(196,50,14,5160,'2026-05-11 11:47:49'),(197,50,19,5200,'2026-05-11 11:47:49'),(198,50,22,5280,'2026-05-11 11:47:49'),(199,51,28,1680,'2026-05-11 11:47:49'),(200,51,3,1730,'2026-05-11 11:47:49'),(201,53,20,2980,'2026-05-11 11:47:49'),(202,53,28,3220,'2026-05-11 11:47:49'),(203,54,4,1240,'2026-05-11 11:47:49'),(204,54,24,1390,'2026-05-11 11:47:49'),(205,54,24,1490,'2026-05-11 11:47:49'),(206,54,10,1620,'2026-05-11 11:47:49'),(207,55,16,700,'2026-05-11 11:47:49'),(208,55,3,850,'2026-05-11 11:47:49'),(209,55,2,1050,'2026-05-11 11:47:49'),(210,55,25,1190,'2026-05-11 11:47:49'),(211,55,20,1300,'2026-05-11 11:47:49'),(212,55,1,1390,'2026-05-11 11:47:49'),(213,55,8,1420,'2026-05-11 11:47:49'),(214,55,28,1640,'2026-05-11 11:47:49'),(215,57,2,280,'2026-05-11 11:47:49'),(216,57,26,530,'2026-05-11 11:47:49'),(217,57,17,590,'2026-05-11 11:47:49'),(218,57,22,760,'2026-05-11 11:47:49'),(219,58,7,2960,'2026-05-11 11:47:49'),(220,58,15,3150,'2026-05-11 11:47:49'),(221,58,28,3360,'2026-05-11 11:47:49'),(222,58,3,3520,'2026-05-11 11:47:49'),(223,58,13,3680,'2026-05-11 11:47:49'),(224,58,12,3820,'2026-05-11 11:47:49'),(225,58,23,3930,'2026-05-11 11:47:49'),(226,59,12,4710,'2026-05-11 11:47:49'),(227,60,17,4800,'2026-05-11 11:47:49'),(228,60,23,4900,'2026-05-11 11:47:49'),(229,60,28,5030,'2026-05-11 11:47:49'),(230,60,19,5280,'2026-05-11 11:47:49'),(231,60,16,5300,'2026-05-11 11:47:49'),(232,60,11,5330,'2026-05-11 11:47:49'),(233,61,4,4670,'2026-05-11 11:47:49'),(234,61,13,4920,'2026-05-11 11:47:49'),(235,61,27,5090,'2026-05-11 11:47:49'),(236,61,22,5100,'2026-05-11 11:47:49'),(237,62,15,4350,'2026-05-11 11:47:49'),(238,62,7,4370,'2026-05-11 11:47:49'),(239,62,12,4540,'2026-05-11 11:47:49'),(240,62,26,4740,'2026-05-11 11:47:49'),(241,62,22,4900,'2026-05-11 11:47:49'),(242,62,26,5050,'2026-05-11 11:47:49'),(243,62,7,5070,'2026-05-11 11:47:49'),(244,62,19,5160,'2026-05-11 11:47:49'),(245,63,16,1280,'2026-05-11 11:47:49'),(246,63,17,1510,'2026-05-11 11:47:49'),(247,64,22,3430,'2026-05-11 11:47:49'),(248,65,6,3560,'2026-05-11 11:47:49'),(249,65,19,3660,'2026-05-11 11:47:49'),(250,65,19,3670,'2026-05-11 11:47:49'),(251,66,8,990,'2026-05-11 11:47:49'),(252,66,15,1030,'2026-05-11 11:47:49'),(253,66,22,1070,'2026-05-11 11:47:49'),(254,66,16,1120,'2026-05-11 11:47:49'),(255,66,10,1350,'2026-05-11 11:47:49'),(256,66,24,1520,'2026-05-11 11:47:49'),(257,67,28,3920,'2026-05-11 11:47:49'),(258,67,16,4080,'2026-05-11 11:47:49'),(259,67,15,4160,'2026-05-11 11:47:49'),(260,67,5,4340,'2026-05-11 11:47:49'),(261,68,20,4720,'2026-05-11 11:47:49'),(262,68,24,4890,'2026-05-11 11:47:49'),(263,68,29,4940,'2026-05-11 11:47:49'),(264,68,9,4970,'2026-05-11 11:47:49'),(265,68,27,5220,'2026-05-11 11:47:49'),(266,68,11,5360,'2026-05-11 11:47:49'),(267,69,28,2800,'2026-05-11 11:47:49'),(268,69,10,2810,'2026-05-11 11:47:49'),(269,69,10,3050,'2026-05-11 11:47:49'),(270,69,20,3240,'2026-05-11 11:47:49'),(271,69,16,3460,'2026-05-11 11:47:49'),(272,69,15,3510,'2026-05-11 11:47:49'),(273,69,16,3690,'2026-05-11 11:47:49'),(274,69,11,3810,'2026-05-11 11:47:49'),(275,70,18,5010,'2026-05-11 11:47:49'),(276,70,15,5140,'2026-05-11 11:47:49'),(277,70,28,5250,'2026-05-11 11:47:49'),(278,70,23,5320,'2026-05-11 11:47:49'),(279,70,19,5400,'2026-05-11 11:47:49'),(280,70,8,5530,'2026-05-11 11:47:49'),(281,70,14,5780,'2026-05-11 11:47:49'),(282,70,11,5800,'2026-05-11 11:47:49'),(283,71,27,2870,'2026-05-11 11:47:49'),(284,71,14,3000,'2026-05-11 11:47:49'),(285,71,27,3220,'2026-05-11 11:47:49'),(286,71,5,3430,'2026-05-11 11:47:49'),(287,71,2,3590,'2026-05-11 11:47:49'),(288,71,18,3640,'2026-05-11 11:47:49'),(289,71,12,3830,'2026-05-11 11:47:49'),(290,72,4,3030,'2026-05-11 11:47:49'),(291,73,1,4820,'2026-05-11 11:47:50'),(292,73,6,5060,'2026-05-11 11:47:50'),(293,73,29,5200,'2026-05-11 11:47:50'),(294,73,6,5410,'2026-05-11 11:47:50'),(295,73,17,5440,'2026-05-11 11:47:50'),(296,73,12,5530,'2026-05-11 11:47:50'),(297,73,24,5730,'2026-05-11 11:47:50'),(298,73,22,5860,'2026-05-11 11:47:50'),(299,74,29,1710,'2026-05-11 11:47:50'),(300,75,12,2560,'2026-05-11 11:47:50'),(301,75,24,2770,'2026-05-11 11:47:50'),(302,75,17,3020,'2026-05-11 11:47:50'),(303,75,2,3200,'2026-05-11 11:47:50'),(304,75,3,3400,'2026-05-11 11:47:50'),(305,75,22,3480,'2026-05-11 11:47:50'),(306,75,11,3700,'2026-05-11 11:47:50'),(307,75,25,3780,'2026-05-11 11:47:50'),(308,76,4,3560,'2026-05-11 11:47:50'),(309,77,7,670,'2026-05-11 11:47:50'),(310,78,2,290,'2026-05-11 11:47:50'),(311,78,26,400,'2026-05-11 11:47:50'),(312,78,10,420,'2026-05-11 11:47:50'),(313,78,12,540,'2026-05-11 11:47:50'),(314,79,9,3040,'2026-05-11 11:47:50'),(315,79,15,3210,'2026-05-11 11:47:50'),(316,79,23,3400,'2026-05-11 11:47:50'),(317,79,6,3460,'2026-05-11 11:47:50'),(318,79,3,3520,'2026-05-11 11:47:50'),(319,79,29,3720,'2026-05-11 11:47:50'),(320,80,23,3770,'2026-05-11 11:47:50'),(321,80,17,3850,'2026-05-11 11:47:50'),(322,80,5,4040,'2026-05-11 11:47:50'),(323,80,16,4120,'2026-05-11 11:47:50'),(324,80,10,4330,'2026-05-11 11:47:50'),(325,80,10,4480,'2026-05-11 11:47:50');
/*!40000 ALTER TABLE `bids` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_bid_before_insert` BEFORE INSERT ON `bids` FOR EACH ROW BEGIN
    DECLARE v_status        VARCHAR(20);
    DECLARE v_end_time      DATETIME;
    DECLARE v_current_price INT;
    DECLARE v_seller_id     INT;

    SELECT a.status, a.end_time, a.current_price, i.seller_id
      INTO v_status, v_end_time, v_current_price, v_seller_id
      FROM Auctions a
      JOIN Items    i ON a.item_id = i.item_id
     WHERE a.auction_id = NEW.auction_id;

    IF v_status IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Auction does not exist';
    END IF;

    IF v_status <> 'active' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Auction is not active';
    END IF;

    IF v_end_time <= NOW() THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Auction has already ended';
    END IF;

    IF v_seller_id = NEW.bidder_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Sellers cannot bid on their own items';
    END IF;

    IF NEW.amount <= v_current_price THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Bid amount must be greater than current price';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_bid_after_insert` AFTER INSERT ON `bids` FOR EACH ROW BEGIN
    UPDATE Auctions
       SET current_price  = NEW.amount,
           high_bidder_id = NEW.bidder_id
     WHERE auction_id = NEW.auction_id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `categories` (
  `category_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `parent_id` int DEFAULT NULL,
  PRIMARY KEY (`category_id`),
  UNIQUE KEY `uq_categories_name` (`name`),
  KEY `fk_categories_parent` (`parent_id`),
  CONSTRAINT `fk_categories_parent` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`category_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `categories`
--

LOCK TABLES `categories` WRITE;
/*!40000 ALTER TABLE `categories` DISABLE KEYS */;
INSERT INTO `categories` VALUES (1,'Electronics',NULL),(2,'Collectibles',NULL),(3,'Fashion',NULL),(4,'Home & Garden',NULL),(5,'Sports & Outdoors',NULL),(6,'Vehicles',NULL),(7,'Art',NULL),(8,'Phones',1),(9,'Laptops',1),(10,'Cameras',1),(11,'Coins',2),(12,'Trading Cards',2),(13,'Watches',3),(14,'Sneakers',3),(15,'Furniture',4),(16,'Bicycles',5),(17,'Cars',6),(18,'Paintings',7);
/*!40000 ALTER TABLE `categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `items`
--

DROP TABLE IF EXISTS `items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `items` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `seller_id` int NOT NULL,
  `category_id` int NOT NULL,
  `title` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `item_condition` enum('new','like_new','good','fair','poor') COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`item_id`),
  KEY `ix_items_seller` (`seller_id`),
  KEY `ix_items_category` (`category_id`),
  CONSTRAINT `fk_items_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_items_seller` FOREIGN KEY (`seller_id`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `items`
--

LOCK TABLES `items` WRITE;
/*!40000 ALTER TABLE `items` DISABLE KEYS */;
INSERT INTO `items` VALUES (1,21,9,'Image loss ten','Her world enter six. Expect recent room situation product main couple.','new','2026-05-11 11:47:49'),(2,4,18,'Why often my','Anyone live try most. Whether bag control organization. Identify walk now often always.','poor','2026-05-11 11:47:49'),(3,3,11,'Information on','Various daughter respond draw how public. Lead upon very act perform. You available defense enter value thing these.','like_new','2026-05-11 11:47:49'),(4,23,18,'Expect just myself few','Property never use. Voice care break blood. Choice example decision garden reach table measure.','poor','2026-05-11 11:47:49'),(5,26,8,'Town suffer begin','Analysis four capital woman claim. Necessary into act away third tough. Along hard need involve among half value.','like_new','2026-05-11 11:47:49'),(6,25,13,'Together decide','Government nice themselves wind. Understand door class son.','new','2026-05-11 11:47:49'),(7,12,17,'Thing agent say','Soon ten specific environment skin blue. Teach develop staff. Glass star the development process huge everything.','good','2026-05-11 11:47:49'),(8,30,14,'Whom evidence','Quickly such former agree theory end. While enter board its rock finish paper memory. Tonight couple and job mind southern.','new','2026-05-11 11:47:49'),(9,28,13,'Hair attorney professional','Finish summer rest feel finally impact I fast. Court professor here security. Past feeling nature a.','poor','2026-05-11 11:47:49'),(10,8,12,'Decision size parent','Kid put memory soldier where save probably. Middle plan friend stand seem. Different current agency each little.','new','2026-05-11 11:47:49'),(11,21,13,'Lay though','Responsibility himself hundred challenge reach. Sing despite sound receive. Anyone eat summer lead soon property write.','like_new','2026-05-11 11:47:49'),(12,23,18,'Fish sense kind spring throughout','Knowledge city technology late seem style everyone. Machine dream key require doctor from throw. Catch discuss really relationship.','new','2026-05-11 11:47:49'),(13,8,10,'Increase former','Artist strategy hope show watch affect. Herself accept goal send table well industry. Son today major event magazine home protect.','fair','2026-05-11 11:47:49'),(14,8,18,'Right subject try wonder','Trade option production. Poor career left anyone. Force lawyer front they everything week.','good','2026-05-11 11:47:49'),(15,9,9,'Edge bank affect much','Practice sit prepare senior wear. Stuff perform draw list boy. Let eight hard paper white.','like_new','2026-05-11 11:47:49'),(16,16,14,'Sing clearly','Official up office traditional. However resource away real physical big.','fair','2026-05-11 11:47:49'),(17,18,16,'Sure outside building','Girl into have. Positive actually information majority item gun through. Religious itself safe whole establish space Mrs.','good','2026-05-11 11:47:49'),(18,8,10,'Let stay or focus','Everything late seek now. From management foot maintain great election.','poor','2026-05-11 11:47:49'),(19,21,10,'They red everybody','Way beat result major serve real position.','fair','2026-05-11 11:47:49'),(20,15,16,'Large admit family identify','Professional hard network gas you. Former reflect even edge building court build.','good','2026-05-11 11:47:49'),(21,22,16,'Week real course school everybody','Others wonder strategy fast guess few remain. Ever window network recently. Point sell bill activity. Light key continue anything wait.','good','2026-05-11 11:47:49'),(22,6,15,'Box assume man officer','Chance none fight yes.','new','2026-05-11 11:47:49'),(23,4,18,'Newspaper indicate other','Simply herself training father open. Figure perform participant science way debate. Enough ball dream necessary choose. Late order fact discuss religious reflect.','good','2026-05-11 11:47:49'),(24,12,10,'Author do enough social','Interesting name positive training step. Arrive society organization station. Keep light fight I evening. Management ball always it focus economy before.','poor','2026-05-11 11:47:49'),(25,1,9,'Onto again share start office','Million kind everything young job sport why. Girl four prove tax form really explain.','good','2026-05-11 11:47:49'),(26,19,9,'Spend nearly lawyer fire','Wife identify method write. Left approach million performance material kind appear. Near until just recognize building.','new','2026-05-11 11:47:49'),(27,22,15,'Participant dream citizen nearly need','Yeah tree left brother strategy. Usually factor relate indeed lot line lead.','poor','2026-05-11 11:47:49'),(28,7,16,'Himself two meet','Everybody so increase various. Environment able rise study oil process tend.','like_new','2026-05-11 11:47:49'),(29,15,16,'Mrs generation necessary myself','Thank wonder draw him task improve. Seat relate specific history professional star. Manager already maybe opportunity.','fair','2026-05-11 11:47:49'),(30,1,17,'Them key','Address century that wide avoid sit enter. Realize power system system teacher here first responsibility. Their along attention piece TV young section.','poor','2026-05-11 11:47:49'),(31,23,18,'Within set region beyond','Tough animal someone fall hear. Each include radio conference.','new','2026-05-11 11:47:49'),(32,17,11,'Bad that people','Tree central leave effect effort act source. Quality citizen kid generation onto.','good','2026-05-11 11:47:49'),(33,24,17,'Real lead few yourself','Down occur offer yeah. Against stop how account ten. Treat seat strategy.','poor','2026-05-11 11:47:49'),(34,4,9,'Simply discover soon','Per question return process stuff. Best physical always small almost half capital travel.','fair','2026-05-11 11:47:49'),(35,24,8,'Section compare car much','Maybe evening clearly trial want whose far. Sound life away senior difficult put. Whose source hand so add Mr.','new','2026-05-11 11:47:49'),(36,28,9,'Happy see energy herself','Push likely people wall. Trip determine as statement travel few. Bring animal also you break doctor.','like_new','2026-05-11 11:47:49'),(37,14,10,'Career law provide sea watch','Score choice increase between majority impact week allow. Describe know door guy wonder happen. Art every why we station begin.','good','2026-05-11 11:47:49'),(38,28,16,'Politics others again','Writer skin day stop never. Democratic thank forget challenge too able teach certain. Music sometimes body term.','new','2026-05-11 11:47:49'),(39,30,11,'Address so draw','Company appear score. Box as large gun order later develop. Analysis situation term miss leader who article look.','like_new','2026-05-11 11:47:49'),(40,13,8,'International blue Republican kitchen','Part assume every plan nature foot. Most law painting between reduce table prepare shoulder.','like_new','2026-05-11 11:47:49'),(41,26,15,'Involve thousand including','Indeed believe interview professor hear check. Attack story behavior benefit school speech news. What no prove improve them wait institution trouble.','good','2026-05-11 11:47:49'),(42,23,15,'Why outside','Official defense prevent difference. Glass news boy everything. Southern suddenly window stand party.','like_new','2026-05-11 11:47:49'),(43,24,16,'Ago upon stop environment Congress','Go consider century price attorney scientist. Begin most heavy.','new','2026-05-11 11:47:49'),(44,17,16,'Game have return since','Be apply church pay purpose evening product magazine. Increase democratic mention generation book question. Main project animal house out account feeling deep.','like_new','2026-05-11 11:47:49'),(45,20,9,'Share face build','Compare herself region matter street south. However score job least. Television office of remember.','like_new','2026-05-11 11:47:49'),(46,20,8,'Face if whom commercial','Story turn because such during open model. That second develop single baby plan. Member town glass road standard spring door. Eight community check service.','poor','2026-05-11 11:47:49'),(47,17,13,'Concern significant','Senior service large under north play person. Firm key light place someone option goal avoid. Later arm story baby ten talk past.','good','2026-05-11 11:47:49'),(48,9,14,'His oil west school','Training occur could painting may whatever late.','like_new','2026-05-11 11:47:49'),(49,30,9,'Word base position always','Model particular hair truth hold simple. Appear piece free form newspaper hit edge surface. Their four old center glass whose recognize hot.','new','2026-05-11 11:47:49'),(50,18,11,'Remember be next poor foreign','Behavior provide meet adult final week game. Court yourself choice fast small medical music.','poor','2026-05-11 11:47:49'),(51,8,13,'Also from short capital heavy','Story side speak close. Analysis hair rest wide particular sell.','good','2026-05-11 11:47:49'),(52,20,18,'Doctor dream whole six','Question now key show sing me. Whom stage soon catch economic political.','poor','2026-05-11 11:47:49'),(53,22,9,'Never bill suffer surface','Several evening town challenge. Begin treat stage this us increase.','like_new','2026-05-11 11:47:49'),(54,5,12,'Maybe dog yes heart','Us stuff practice social case expert.','good','2026-05-11 11:47:49'),(55,22,18,'Receive catch relationship large','Affect democratic change vote.','good','2026-05-11 11:47:49'),(56,21,14,'Month book explain feeling answer','Lead book toward others administration middle drop century. Ability good number cost property model. Attack moment medical write never hospital.','good','2026-05-11 11:47:49'),(57,9,10,'Analysis hit health section','General run pick sign. Card good full poor store range. Place specific as simply leader fall analysis.','fair','2026-05-11 11:47:49'),(58,4,9,'Though firm financial','List already positive experience television answer pretty. Buy happy threat sea thus. Fund cost reality happen something entire.','like_new','2026-05-11 11:47:49'),(59,5,14,'Risk bad','Nation fly bag produce. Knowledge response coach know language. Past itself police social arm provide. Guy song quickly well central parent.','like_new','2026-05-11 11:47:49'),(60,12,11,'Alone attack sing hand','Allow check last he know baby case. Huge power economic box save material. Trial brother simple region Democrat partner.','like_new','2026-05-11 11:47:49'),(61,28,14,'Customer career available common','Specific whose worry property. Nearly face feel church. Soldier meeting building cut.','poor','2026-05-11 11:47:49'),(62,14,8,'Door management guess','Level work candidate this assume huge. Moment shoulder statement available win politics last. General there sister policy consider whom item.','like_new','2026-05-11 11:47:49'),(63,8,12,'Story million','Class various different way. Thus suffer economy play nearly by field.','like_new','2026-05-11 11:47:49'),(64,7,15,'Behavior political option oil commercial','Front under American tell ball we side enough. Short indicate police marriage phone. Politics few each southern image. Authority art keep machine daughter parent fine.','good','2026-05-11 11:47:49'),(65,7,14,'Safe team wish candidate','No five letter environment easy best face. Ten industry while total spend value. Couple city you level these market.','good','2026-05-11 11:47:49'),(66,17,14,'War measure','On any example our successful. Experience account blue care enough hand idea.','poor','2026-05-11 11:47:49'),(67,19,12,'Hundred now','Network available mean share evidence writer. Budget window hour some fund voice sense current.','new','2026-05-11 11:47:49'),(68,26,13,'Husband American although require sound','Chance throw cause use five hotel pattern. Order medical meeting majority none. Staff happy purpose woman on someone rise.','fair','2026-05-11 11:47:49'),(69,19,11,'Ago listen whose situation simply','Return on color pick people. Challenge quite all way body affect. Industry include data maybe particularly likely.','good','2026-05-11 11:47:49'),(70,30,16,'Relationship million','Your long heavy what least mouth. Great sign return poor really particular court. Everything fear walk word side.','like_new','2026-05-11 11:47:49'),(71,11,17,'Real major look','Explain of myself time house. West source fact explain research get. Pretty section degree still even no.','good','2026-05-11 11:47:49'),(72,10,18,'Case past only','Prove most point. Beyond form line.','fair','2026-05-11 11:47:49'),(73,5,11,'Accept nearly upon','Local current white fly position traditional become. Discussion school sure also TV individual study. Young however many.','fair','2026-05-11 11:47:49'),(74,6,17,'Theory across nothing','Expect writer myself management voice surface. Evening speak former room possible responsibility add.','poor','2026-05-11 11:47:49'),(75,10,11,'So nothing serious compare','Middle beautiful protect continue cell food. According himself land environment form. Reveal activity president realize artist brother fill if.','fair','2026-05-11 11:47:49'),(76,15,15,'Type thousand show real','Pass despite card check security paper. Reduce tree serious soon stay seven.','like_new','2026-05-11 11:47:49'),(77,3,12,'Their bank land region back','Article natural measure of. Clearly take kind quite. Major together knowledge argue car indeed nor next.','poor','2026-05-11 11:47:49'),(78,27,11,'Rich how staff','Authority interest red must art thus worry line. Important shoulder she within position.','good','2026-05-11 11:47:49'),(79,8,15,'Hear through large true','Bag who themselves card team budget. Hotel camera without strong series without leg. Interest here discover leave choice country themselves.','poor','2026-05-11 11:47:49'),(80,7,14,'Allow produce','Drive attack order. Our reflect any scientist I doctor describe. Cell year doctor trouble. Five our pull fly few century produce.','fair','2026-05-11 11:47:49');
/*!40000 ALTER TABLE `items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transactions`
--

DROP TABLE IF EXISTS `transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transactions` (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `auction_id` int NOT NULL,
  `buyer_id` int NOT NULL,
  `seller_id` int NOT NULL,
  `sale_price` int NOT NULL,
  `completed_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`transaction_id`),
  UNIQUE KEY `uq_transactions_auction` (`auction_id`),
  KEY `ix_transactions_buyer` (`buyer_id`),
  KEY `ix_transactions_seller` (`seller_id`),
  KEY `ix_transactions_completed` (`completed_at`),
  CONSTRAINT `fk_transactions_auction` FOREIGN KEY (`auction_id`) REFERENCES `auctions` (`auction_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_transactions_buyer` FOREIGN KEY (`buyer_id`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_transactions_seller` FOREIGN KEY (`seller_id`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT,
  CONSTRAINT `chk_transactions_parties` CHECK ((`buyer_id` <> `seller_id`)),
  CONSTRAINT `chk_transactions_price` CHECK ((`sale_price` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transactions`
--

LOCK TABLES `transactions` WRITE;
/*!40000 ALTER TABLE `transactions` DISABLE KEYS */;
INSERT INTO `transactions` VALUES (1,4,20,23,2560,'2026-05-11 11:47:50'),(2,5,25,26,2320,'2026-05-11 11:47:50'),(3,7,3,12,930,'2026-05-11 11:47:50'),(4,16,1,16,4020,'2026-05-11 11:47:50'),(5,18,20,8,1030,'2026-05-11 11:47:50'),(6,20,28,15,880,'2026-05-11 11:47:50'),(7,23,21,4,1340,'2026-05-11 11:47:50'),(8,24,27,12,2740,'2026-05-11 11:47:50'),(9,26,29,19,1350,'2026-05-11 11:47:50'),(10,28,28,7,3260,'2026-05-11 11:47:50'),(11,29,30,15,1870,'2026-05-11 11:47:50'),(12,31,17,23,890,'2026-05-11 11:47:50'),(13,35,8,24,4240,'2026-05-11 11:47:50'),(14,36,24,28,1750,'2026-05-11 11:47:50'),(15,42,29,23,3470,'2026-05-11 11:47:50'),(16,44,4,17,480,'2026-05-11 11:47:50'),(17,48,6,9,1860,'2026-05-11 11:47:50'),(18,50,22,18,5280,'2026-05-11 11:47:50'),(19,53,28,22,3220,'2026-05-11 11:47:50'),(20,54,10,5,1620,'2026-05-11 11:47:50'),(21,55,28,22,1640,'2026-05-11 11:47:50'),(22,58,23,4,3930,'2026-05-11 11:47:50'),(23,59,12,5,4710,'2026-05-11 11:47:50'),(24,61,22,28,5100,'2026-05-11 11:47:50'),(25,63,17,8,1510,'2026-05-11 11:47:50'),(26,69,11,19,3810,'2026-05-11 11:47:50'),(27,70,11,30,5800,'2026-05-11 11:47:50'),(28,73,22,5,5860,'2026-05-11 11:47:50'),(29,75,25,10,3780,'2026-05-11 11:47:50'),(30,78,12,27,540,'2026-05-11 11:47:50'),(31,79,29,8,3720,'2026-05-11 11:47:50');
/*!40000 ALTER TABLE `transactions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `uq_users_username` (`username`),
  UNIQUE KEY `uq_users_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'johnsonjoshua','donaldgarcia@example.net','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(2,'garzaanthony','robinsonwilliam@example.org','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(3,'jennifermiles','lrobinson@example.com','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(4,'blakeerik','jpeterson@example.org','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(5,'curtis61','melanie94@example.org','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(6,'yherrera','arnoldmaria@example.net','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(7,'barbara10','kendragalloway@example.org','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(8,'jamesshawn','francisco53@example.net','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(9,'jacqueline19','amandasanchez@example.com','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(10,'onelson','gabriellecameron@example.org','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(11,'lydiatrujillo','nadams@example.net','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(12,'jason76','ithomas@example.org','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(13,'julie69','icox@example.net','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(14,'ddavis','hernandezernest@example.net','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(15,'ycarlson','dcarlson@example.net','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(16,'tasha01','kayla51@example.com','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(17,'amoore','teresa28@example.org','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(18,'meagan89','ericfarmer@example.net','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(19,'georgetracy','hickmannatasha@example.com','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(20,'brianhumphrey','millertodd@example.org','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(21,'davidalvarez','josephbrennan@example.com','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(22,'sarahcampos','jenniferross@example.net','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(23,'samuel87','wrightcaleb@example.org','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(24,'briannasmith','perezrebecca@example.com','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(25,'palmerjoshua','ilewis@example.net','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(26,'esanchez','glee@example.net','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(27,'agomez','dshields@example.net','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(28,'brownjessica','wrightjames@example.com','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(29,'robertramirez','nancyjones@example.net','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49'),(30,'williamsyvette','novaksara@example.org','scrypt:32768:8:1$FTtCaNPAQ5Hz3jRV$2b7da8bcbfeaa868785a9275568eaa7a12364fbac9dbf9ea1096b8bda99f1531275706d7b7059c7894a63306c61dee6318cfbd146f888be2f0dcd432c75e3d39','2026-05-11 11:47:49');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `watchlist`
--

DROP TABLE IF EXISTS `watchlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `watchlist` (
  `user_id` int NOT NULL,
  `auction_id` int NOT NULL,
  `added_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`,`auction_id`),
  KEY `ix_watchlist_auction` (`auction_id`),
  CONSTRAINT `fk_watchlist_auction` FOREIGN KEY (`auction_id`) REFERENCES `auctions` (`auction_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_watchlist_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `watchlist`
--

LOCK TABLES `watchlist` WRITE;
/*!40000 ALTER TABLE `watchlist` DISABLE KEYS */;
INSERT INTO `watchlist` VALUES (1,2,'2026-05-11 11:47:50'),(1,21,'2026-05-11 11:47:50'),(1,37,'2026-05-11 11:47:50'),(1,60,'2026-05-11 11:47:50'),(1,70,'2026-05-11 11:47:50'),(3,39,'2026-05-11 11:47:50'),(3,45,'2026-05-11 11:47:50'),(3,76,'2026-05-11 11:47:50'),(4,26,'2026-05-11 11:47:50'),(4,33,'2026-05-11 11:47:50'),(4,39,'2026-05-11 11:47:50'),(4,55,'2026-05-11 11:47:50'),(4,59,'2026-05-11 11:47:50'),(5,14,'2026-05-11 11:47:50'),(5,31,'2026-05-11 11:47:50'),(5,62,'2026-05-11 11:47:50'),(6,38,'2026-05-11 11:47:50'),(6,46,'2026-05-11 11:47:50'),(6,74,'2026-05-11 11:47:50'),(7,2,'2026-05-11 11:47:50'),(7,3,'2026-05-11 11:47:50'),(7,36,'2026-05-11 11:47:50'),(7,38,'2026-05-11 11:47:50'),(7,51,'2026-05-11 11:47:50'),(8,7,'2026-05-11 11:47:50'),(8,37,'2026-05-11 11:47:50'),(8,64,'2026-05-11 11:47:50'),(8,78,'2026-05-11 11:47:50'),(9,78,'2026-05-11 11:47:50'),(10,25,'2026-05-11 11:47:50'),(10,29,'2026-05-11 11:47:50'),(11,6,'2026-05-11 11:47:50'),(11,13,'2026-05-11 11:47:50'),(11,18,'2026-05-11 11:47:50'),(11,33,'2026-05-11 11:47:50'),(12,5,'2026-05-11 11:47:50'),(12,57,'2026-05-11 11:47:50'),(13,12,'2026-05-11 11:47:50'),(13,17,'2026-05-11 11:47:50'),(13,38,'2026-05-11 11:47:50'),(13,47,'2026-05-11 11:47:50'),(14,23,'2026-05-11 11:47:50'),(14,54,'2026-05-11 11:47:50'),(15,17,'2026-05-11 11:47:50'),(16,35,'2026-05-11 11:47:50'),(16,47,'2026-05-11 11:47:50'),(16,65,'2026-05-11 11:47:50'),(16,68,'2026-05-11 11:47:50'),(17,33,'2026-05-11 11:47:50'),(18,15,'2026-05-11 11:47:50'),(18,38,'2026-05-11 11:47:50'),(18,44,'2026-05-11 11:47:50'),(19,10,'2026-05-11 11:47:50'),(19,19,'2026-05-11 11:47:50'),(19,29,'2026-05-11 11:47:50'),(20,2,'2026-05-11 11:47:50'),(20,12,'2026-05-11 11:47:50'),(20,47,'2026-05-11 11:47:50'),(20,51,'2026-05-11 11:47:50'),(20,72,'2026-05-11 11:47:50'),(21,16,'2026-05-11 11:47:50'),(21,69,'2026-05-11 11:47:50'),(22,34,'2026-05-11 11:47:50'),(22,48,'2026-05-11 11:47:50'),(22,75,'2026-05-11 11:47:50'),(23,14,'2026-05-11 11:47:50'),(23,30,'2026-05-11 11:47:50'),(23,48,'2026-05-11 11:47:50'),(24,4,'2026-05-11 11:47:50'),(24,72,'2026-05-11 11:47:50'),(24,80,'2026-05-11 11:47:50'),(25,29,'2026-05-11 11:47:50'),(25,79,'2026-05-11 11:47:50'),(26,9,'2026-05-11 11:47:50'),(26,15,'2026-05-11 11:47:50'),(26,39,'2026-05-11 11:47:50'),(26,53,'2026-05-11 11:47:50'),(26,60,'2026-05-11 11:47:50'),(27,6,'2026-05-11 11:47:50'),(29,15,'2026-05-11 11:47:50'),(29,64,'2026-05-11 11:47:50');
/*!40000 ALTER TABLE `watchlist` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'auction_house'
--
/*!50003 DROP FUNCTION IF EXISTS `fn_get_bid_count` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_get_bid_count`(p_auction_id INT) RETURNS int
    READS SQL DATA
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count
      FROM Bids
     WHERE auction_id = p_auction_id;
    RETURN v_count;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP FUNCTION IF EXISTS `fn_is_auction_active` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `fn_is_auction_active`(p_auction_id INT) RETURNS tinyint(1)
    READS SQL DATA
BEGIN
    DECLARE v_status   VARCHAR(20);
    DECLARE v_end_time DATETIME;

    SELECT status, end_time
      INTO v_status, v_end_time
      FROM Auctions
     WHERE auction_id = p_auction_id;

    IF v_status IS NULL THEN
        RETURN FALSE;
    END IF;

    RETURN (v_status = 'active' AND v_end_time > NOW());
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_close_expired_auctions` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_close_expired_auctions`()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    
    INSERT INTO Transactions (auction_id, buyer_id, seller_id, sale_price)
    SELECT a.auction_id,
           a.high_bidder_id,
           i.seller_id,
           a.current_price
      FROM Auctions a
      JOIN Items    i ON a.item_id = i.item_id
     WHERE a.status         = 'active'
       AND a.end_time      <= NOW()
       AND a.high_bidder_id IS NOT NULL;

    
    UPDATE Auctions
       SET status = 'closed'
     WHERE status   = 'active'
       AND end_time <= NOW();

    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_end_auction_now` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_end_auction_now`(
    IN p_auction_id INT,
    IN p_user_id    INT
)
BEGIN
    DECLARE v_seller_id     INT;
    DECLARE v_status        VARCHAR(20);
    DECLARE v_high_bidder   INT;
    DECLARE v_current_price INT;

    SELECT i.seller_id, a.status, a.high_bidder_id, a.current_price
      INTO v_seller_id, v_status, v_high_bidder, v_current_price
      FROM Auctions a
      JOIN Items    i ON a.item_id = i.item_id
     WHERE a.auction_id = p_auction_id;

    IF v_seller_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Auction does not exist';
    END IF;

    IF v_seller_id <> p_user_id THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Only the seller can end this auction';
    END IF;

    IF v_status <> 'active' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Auction is already closed';
    END IF;

    IF v_high_bidder IS NOT NULL THEN
        INSERT INTO Transactions (auction_id, buyer_id, seller_id, sale_price)
        VALUES (p_auction_id, v_high_bidder, v_seller_id, v_current_price);
    END IF;

    UPDATE Auctions
       SET status   = 'closed',
           end_time = NOW() + INTERVAL 1 SECOND
     WHERE auction_id = p_auction_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_place_bid` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_place_bid`(
    IN p_auction_id INT,
    IN p_user_id    INT,
    IN p_amount     INT
)
BEGIN
    INSERT INTO Bids (auction_id, bidder_id, amount)
    VALUES (p_auction_id, p_user_id, p_amount);
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-11 11:51:12
