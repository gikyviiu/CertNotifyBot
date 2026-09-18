-- MySQL dump 10.13  Distrib 8.0.40, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: test
-- ------------------------------------------------------
-- Server version	8.0.40

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `certificates`
--

DROP TABLE IF EXISTS `certificates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `certificates` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employee_id` int NOT NULL,
  `serial_number` varchar(100) NOT NULL,
  `issuer` varchar(500) NOT NULL,
  `subject` varchar(500) NOT NULL,
  `valid_from` datetime NOT NULL,
  `valid_to` datetime NOT NULL,
  `thumbprint_sha1` varchar(64) DEFAULT NULL,
  `thumbprint_sha256` varchar(128) DEFAULT NULL,
  `public_key` text,
  `key_usage` text,
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_cert` (`serial_number`,`issuer`),
  KEY `employee_id` (`employee_id`),
  CONSTRAINT `certificates_ibfk_1` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `certificates`
--

LOCK TABLES `certificates` WRITE;
/*!40000 ALTER TABLE `certificates` DISABLE KEYS */;
INSERT INTO `certificates` VALUES (7,7,'S002006','CN=УЦ АО \"Почта Банк\", C=RU','CN=Васильева Ольга Павловна, INN=778899001122, C=RU','2023-06-18 00:00:00','2025-06-17 23:59:00','A6B7C8D9E0F1A2B3C4D5E6F7A8B9C0D1E2F3A4B5','A6B7C8D9E0F1A2B3C4D5E6F7A8B9C0D1E2F3A4B5C6D7E8F9A0B1C2D3E4F5A6B7','-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA...\n-----END PUBLIC KEY-----','nonRepudiation','None','2025-08-02 13:09:08','2026-04-15 15:01:56'),(8,8,'S002007','CN=УЦ ООО \"Алтэкс\", C=RU','CN=Федоров Михаил Юрьевич, INN=889900112233, C=RU','2023-07-22 00:00:00','2025-07-21 23:59:59','B7C8D9E0F1A2B3C4D5E6F7A8B9C0D1E2F3A4B5C6','B7C8D9E0F1A2B3C4D5E6F7A8B9C0D1E2F3A4B5C6D7E8F9A0B1C2D3E4F5A6B7C8','-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA...\n-----END PUBLIC KEY-----','digitalSignature',NULL,'2025-08-02 13:09:08','2025-08-02 13:09:08'),(9,9,'S002008','CN=УЦ ПАО \"ВТБ\", C=RU','CN=Лебедева Татьяна Игоревна, INN=990011223344, C=RU','2023-08-30 00:00:00','2025-08-29 23:59:59','C8D9E0F1A2B3C4D5E6F7A8B9C0D1E2F3A4B5C6D7','C8D9E0F1A2B3C4D5E6F7A8B9C0D1E2F3A4B5C6D7E8F9A0B1C2D3E4F5A6B7C8D9','-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA...\n-----END PUBLIC KEY-----','keyEncipherment',NULL,'2025-08-02 13:09:08','2025-08-02 13:09:08'),(10,10,'S002009','CN=УЦ ООО \"КриптоПро\", C=RU','CN=Смирнов Роман Владимирович, INN=001122334455, C=RU','2023-09-11 00:00:00','2026-04-22 23:59:00','D9E0F1A2B3C4D5E6F7A8B9C0D1E2F3A4B5C6D7E8','D9E0F1A2B3C4D5E6F7A8B9C0D1E2F3A4B5C6D7E8F9A0B1C2D3E4F5A6B7C8D9E0','-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA...\n-----END PUBLIC KEY-----','digitalSignature','None','2025-08-02 13:09:08','2026-04-20 16:05:27'),(11,11,'S002010','CN=УЦ АО \"Такском\", C=RU','CN=Кузнецова Наталья Олеговна, INN=112233445566, C=RU','2023-10-05 00:00:00','2026-07-10 23:59:00','E0F1A2B3C4D5E6F7A8B9C0D1E2F3A4B5C6D7E8F9','E0F1A2B3C4D5E6F7A8B9C0D1E2F3A4B5C6D7E8F9A0B1C2D3E4F5A6B7C8D9E0F1','-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA...\n-----END PUBLIC KEY-----','digitalSignature','None','2025-08-02 13:09:08','2026-07-05 20:44:23'),(12,12,'S002011','CN=УЦ ПАО \"Газпромбанк\", C=RU','CN=Попов Сергей Михайлович, INN=223344556677, C=RU','2023-11-14 00:00:00','2025-11-13 23:59:59','F1A2B3C4D5E6F7A8B9C0D1E2F3A4B5C6D7E8F9A0','F1A2B3C4D5E6F7A8B9C0D1E2F3A4B5C6D7E8F9A0B1C2D3E4F5A6B7C8D9E0F1A2','-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA...\n-----END PUBLIC KEY-----','digitalSignature',NULL,'2025-08-02 13:09:08','2025-08-02 13:09:08'),(13,13,'S002012','CN=УЦ ООО \"НПП \"Инфотекс\"','CN=Орлова Дарья Александровна, INN=334455667788, C=RU','2023-12-01 00:00:00','2025-11-30 23:59:59','A2B3C4D5E6F7A8B9C0D1E2F3A4B5C6D7E8F9A0B1','A2B3C4D5E6F7A8B9C0D1E2F3A4B5C6D7E8F9A0B1C2D3E4F5A6B7C8D9E0F1A2B3','-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA...\n-----END PUBLIC KEY-----','nonRepudiation',NULL,'2025-08-02 13:09:08','2025-08-02 13:09:08'),(14,14,'S002013','CN=УЦ АО \"Калуга Астрал\", C=RU','CN=Егоров Владислав Николаевич, INN=445566778899, C=RU','2024-01-10 00:00:00','2026-07-09 23:59:00','B3C4D5E6F7A8B9C0D1E2F3A4B5C6D7E8F9A0B1C2','B3C4D5E6F7A8B9C0D1E2F3A4B5C6D7E8F9A0B1C2D3E4F5A6B7C8D9E0F1A2B3C4','-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA...\n-----END PUBLIC KEY-----','digitalSignature','None','2025-08-02 13:09:08','2026-07-05 20:43:37'),(16,5,'S00200445','CN=УЦ ПАО \"Сбербанк\", C=RU','evweadv','2025-07-29 23:40:00','2025-08-31 23:40:00','ауЦА','Ауа','аУА','АУАУА','Ауа','2025-08-03 20:40:33','2025-08-03 20:40:33'),(19,12,'5634562','52472457','7247','2026-04-08 19:13:00','2026-04-22 19:13:00','','','','','','2026-04-12 16:13:38','2026-04-16 01:04:22'),(20,12,'11:C1:7B:00:86:AB:56:86:4C:A4:B7:D2:D5:7B:98:C8','CN=TrueMark.ru, O=ООО \"ОПЕРАТОР-ЦРПТ\", C=RU, ST=77 г. Москва, L=Москва','CN=TrueMark.ru, O=ООО \"ОПЕРАТОР-ЦРПТ\", C=RU, ST=77 г. Москва, L=Москва','2020-03-22 04:20:00','2030-03-22 04:20:00','63:F9:46:A4:FC:C3:BB:B7:65:AB:BF:FF:A3:97:82:C2:72:71:15:98','D8:93:B1:E6:B2:03:AD:BE:7B:2B:F4:2F:EB:84:3B:8C:1A:D7:8B:61:61:09:D2:5F:71:A1:8C:C4:44:C3:21:15',NULL,'Digital Signature, Certificate Sign, CRL Sign','тест','2026-04-15 14:43:50','2026-04-15 14:43:50'),(21,12,'11:C1:7B:00:86:AB:56:86:4C:A4:B7:D2:D5:7B:98:C9','CN=TrueMark.ru, O=ООО \"ОПЕРАТОР-ЦРПТ\", C=RU, ST=77 г. Москва, L=Москва','CN=TrueMark.ru, O=ООО \"ОПЕРАТОР-ЦРПТ\", C=RU, ST=77 г. Москва, L=Москва','2020-03-22 04:20:00','2030-03-22 04:20:00','63:F9:46:A4:FC:C3:BB:B7:65:AB:BF:FF:A3:97:82:C2:72:71:15:98','D8:93:B1:E6:B2:03:AD:BE:7B:2B:F4:2F:EB:84:3B:8C:1A:D7:8B:61:61:09:D2:5F:71:A1:8C:C4:44:C3:21:15',NULL,'Digital Signature, Certificate Sign, CRL Sign','апрол','2026-04-15 14:44:24','2026-04-15 14:44:24'),(23,7,'11:C1:7B:00:86:AB:56:86:4C:A4:B7:D2:D5:7B:98:11','CN=TrueMark.ru, O=ООО \"ОПЕРАТОР-ЦРПТ\", C=RU, ST=77 г. Москва, L=Москва','CN=TrueMark.ru, O=ООО \"ОПЕРАТОР-ЦРПТ\", C=RU, ST=77 г. Москва, L=Москва','2020-03-22 04:20:00','2030-03-22 04:20:00','63:F9:46:A4:FC:C3:BB:B7:65:AB:BF:FF:A3:97:82:C2:72:71:15:98','D8:93:B1:E6:B2:03:AD:BE:7B:2B:F4:2F:EB:84:3B:8C:1A:D7:8B:61:61:09:D2:5F:71:A1:8C:C4:44:C3:21:15',NULL,'Digital Signature, Certificate Sign, CRL Sign','ву','2026-04-15 14:50:03','2026-04-15 14:50:03'),(24,1,'11:C1:7B:00:86:AB:56:86:4C:A4:B7:D2:D5:7B:98:99','CN=TrueMark.ru, O=ООО \"ОПЕРАТОР-ЦРПТ\", C=RU, ST=77 г. Москва, L=Москва','CN=TrueMark.ru, O=ООО \"ОПЕРАТОР-ЦРПТ\", C=RU, ST=77 г. Москва, L=Москва','2020-03-22 04:20:00','2030-03-22 04:20:00','63:F9:46:A4:FC:C3:BB:B7:65:AB:BF:FF:A3:97:82:C2:72:71:15:98','D8:93:B1:E6:B2:03:AD:BE:7B:2B:F4:2F:EB:84:3B:8C:1A:D7:8B:61:61:09:D2:5F:71:A1:8C:C4:44:C3:21:15',NULL,'Digital Signature, Certificate Sign, CRL Sign','','2026-04-15 14:50:47','2026-04-15 14:50:47'),(26,14,'11:C1:7B:00:86:AB:56:86:4C:A4:B7:D2:D5:7B:98:C123','CN=TrueMark.ru, O=ООО \"ОПЕРАТОР-ЦРПТ\", C=RU, ST=77 г. Москва, L=Москва','CN=TrueMark.ru, O=ООО \"ОПЕРАТОР-ЦРПТ\", C=RU, ST=77 г. Москва, L=Москва','2020-03-22 04:20:00','2030-03-22 04:20:00','63:F9:46:A4:FC:C3:BB:B7:65:AB:BF:FF:A3:97:82:C2:72:71:15:98','D8:93:B1:E6:B2:03:AD:BE:7B:2B:F4:2F:EB:84:3B:8C:1A:D7:8B:61:61:09:D2:5F:71:A1:8C:C4:44:C3:21:15',NULL,'Digital Signature, Certificate Sign, CRL Sign','ывапр','2026-04-15 22:13:23','2026-04-15 22:13:23'),(29,14,'11:C1:7B:00:86:AB:54235:A4:B7:D2:D5:7B:98:C8','CN=TrueMark.ru, O=ООО \"ОПЕРАТОР-ЦРПТ\", C=RU, ST=77 г. Москва, L=Москва','CN=TrueMark.ru, O=ООО \"ОПЕРАТОР-ЦРПТ\", C=RU, ST=77 г. Москва, L=Москва','2020-03-22 04:20:00','2026-07-08 04:20:00','63:F9:46:A4:FC:C3:BB:B7:65:AB:BF:FF:A3:97:82:C2:72:71:15:98','D8:93:B1:E6:B2:03:AD:BE:7B:2B:F4:2F:EB:84:3B:8C:1A:D7:8B:61:61:09:D2:5F:71:A1:8C:C4:44:C3:21:15',NULL,'Digital Signature, Certificate Sign, CRL Sign','','2026-04-15 22:19:29','2026-07-05 20:43:13'),(31,1,'11:C1:7B:00:86:AB:56:86:4C:A4:B7:D2:D5:7B:98:1234','CN=TrueMark.ru, O=ООО \"ОПЕРАТОР-ЦРПТ\", C=RU, ST=77 г. Москва, L=Москва','CN=TrueMark.ru, O=ООО \"ОПЕРАТОР-ЦРПТ\", C=RU, ST=77 г. Москва, L=Москва','2020-03-22 04:20:00','2030-03-22 04:20:00','63:F9:46:A4:FC:C3:BB:B7:65:AB:BF:FF:A3:97:82:C2:72:71:15:98','D8:93:B1:E6:B2:03:AD:BE:7B:2B:F4:2F:EB:84:3B:8C:1A:D7:8B:61:61:09:D2:5F:71:A1:8C:C4:44:C3:21:15',NULL,'Digital Signature, Certificate Sign, CRL Sign','','2026-04-20 16:08:59','2026-04-20 16:08:59'),(32,14,'11:C1:7B:00:86:AB:56:86:4C:A4:B7:D2:D5:7B:98:C23456','CN=TrueMark.ru, O=ООО \"ОПЕРАТОР-ЦРПТ\", C=RU, ST=77 г. Москва, L=Москва','CN=TrueMark.ru, O=ООО \"ОПЕРАТОР-ЦРПТ\", C=RU, ST=77 г. Москва, L=Москва','2020-03-22 04:20:00','2030-03-22 04:20:00','63:F9:46:A4:FC:C3:BB:B7:65:AB:BF:FF:A3:97:82:C2:72:71:15:98','D8:93:B1:E6:B2:03:AD:BE:7B:2B:F4:2F:EB:84:3B:8C:1A:D7:8B:61:61:09:D2:5F:71:A1:8C:C4:44:C3:21:15',NULL,'Digital Signature, Certificate Sign, CRL Sign','','2026-04-20 16:09:37','2026-04-20 16:09:37'),(33,15,'02','CN=Test NC CA 2','O=Good NC Test Certificate 2','2016-07-09 11:48:00','2116-07-10 11:48:00','31:A0:A2:EB:B6:F1:E3:52:4F:D5:9D:04:E4:D6:A8:E4:48:3E:3F:74','99:A7:14:BF:EA:41:99:EB:EE:BF:D6:31:5C:EB:02:C7:62:4B:52:37:D9:28:31:41:16:86:68:4F:3C:EE:FA:9B',NULL,'keyEncipherment','','2026-04-20 16:26:26','2026-04-20 16:26:26'),(34,2,'123456789','CN=Test NC CA 2','O=Good NC Test Certificate 2','2016-07-09 11:48:00','2116-07-10 11:48:00','31:A0:A2:EB:B6:F1:E3:52:4F:D5:9D:04:E4:D6:A8:E4:48:3E:3F:74','99:A7:14:BF:EA:41:99:EB:EE:BF:D6:31:5C:EB:02:C7:62:4B:52:37:D9:28:31:41:16:86:68:4F:3C:EE:FA:9B',NULL,'','','2026-07-05 20:48:10','2026-07-05 20:48:10');
/*!40000 ALTER TABLE `certificates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(255) NOT NULL,
  `position` varchar(255) DEFAULT NULL,
  `department` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `employee_number` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `telegram_id` varchar(50) DEFAULT NULL,
  `role` enum('admin','viewer') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `employee_number` (`employee_number`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES (1,'Андреев Алишер Иванович','Ведущий инженер','IT-отдел','i.ivanov@company.ru','+79001234567','EMP00123','2025-08-02 13:09:04','2026-09-18 18:42:28','NULL',NULL),(2,'Петров Пётр Петрович','Главный бухгалтер','Финансы','pet.petrov@company.ru','+79001112233','EMP00124','2025-08-02 13:09:08','2025-08-02 13:09:08',NULL,NULL),(3,'Сидорова Анна Сергеевна','HR-менеджер','Кадры','a.sidorova@company.ru','+79002223344','EMP00125','2025-08-02 13:09:08','2025-08-02 13:09:08',NULL,NULL),(4,'Козлов Дмитрий Алексеевич','Руководитель отдела','IT-отдел','d.kozlov@company.ru','+79003334455','EMP00126','2025-08-02 13:09:08','2025-08-02 13:09:08',NULL,NULL),(5,'Морозова Елена Викторовна','Аналитик данных','Аналитика','e.morozova@company.ru','+79004445566','EMP00127','2025-08-02 13:09:08','2025-08-02 13:09:08',NULL,NULL),(6,'Новиков Артём Романович','Инженер-программист','IT-отдел','a.novikov@company.ru','+79005556677','EMP00128','2025-08-02 13:09:08','2025-08-02 13:09:08',NULL,NULL),(7,'Васильева Ольга Павловна','Юрист','Правовой отдел','o.vasilieva@company.ru','+79006667788','EMP00129','2025-08-02 13:09:08','2025-08-02 13:09:08',NULL,NULL),(8,'Федоров Михаил Юрьевич','Специалист по безопасности','Безопасность','m.fedorov@company.ru','+79007778899','EMP00130','2025-08-02 13:09:08','2025-08-02 13:09:08',NULL,NULL),(9,'Лебедева Татьяна Игоревна','Директор по развитию','Руководство','t.lebedeva@company.ru','+79008889900','EMP00131','2025-08-02 13:09:08','2025-08-02 13:09:08',NULL,NULL),(10,'Смирнов Роман Владимирович','Тестировщик','IT-отдел','r.smirnov@company.ru','+79009990011','EMP00132','2025-08-02 13:09:08','2025-08-02 13:09:08',NULL,NULL),(11,'Кузнецова Наталья Олеговна','Экономист','Финансы','n.kuznetsova@company.ru','+79000001122','EMP00133','2025-08-02 13:09:08','2025-08-02 13:09:08',NULL,NULL),(12,'Попов Сергей Михайлович','Системный администратор','IT-отдел','s.popov@company.ru','+79001112234','EMP00134','2025-08-02 13:09:08','2025-08-02 13:09:08',NULL,NULL),(13,'Орлова Дарья Александровна','PR-менеджер','Маркетинг','d.orlova@company.ru','+79002223345','EMP00135','2025-08-02 13:09:08','2025-08-02 13:09:08',NULL,NULL),(14,'Егоров Владислав Николаевич','Разработчик','IT-отдел','v.egorov@company.ru','+79003334456','EMP00136','2025-08-02 13:09:08','2026-09-18 18:42:57','0','admin'),(15,'Антонова Мария Дмитриевна','Специалист по кадрам','Кадры','m.antonova@company.ru','+79004445567','EMP00137','2025-08-02 13:09:08','2026-09-18 18:42:57','0','admin');
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `registration_keys`
--

DROP TABLE IF EXISTS `registration_keys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `registration_keys` (
  `id` int NOT NULL AUTO_INCREMENT,
  `emp_id` int NOT NULL,
  `uniqkey` varchar(64) NOT NULL,
  `is_used` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `used_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniqkey` (`uniqkey`),
  KEY `idx_uniqkey` (`uniqkey`),
  KEY `idx_emp_id` (`emp_id`),
  CONSTRAINT `registration_keys_ibfk_1` FOREIGN KEY (`emp_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `registration_keys`
--

LOCK TABLES `registration_keys` WRITE;
/*!40000 ALTER TABLE `registration_keys` DISABLE KEYS */;
INSERT INTO `registration_keys` VALUES (1,5,'EP2026-DIANA-K7X9',1,'2026-03-07 17:11:26','2026-03-07 17:55:19'),(2,7,'EP2026-OL-K7X9',1,'2026-04-15 17:58:43','2026-04-15 18:00:31'),(3,11,'EP2026-NEW11-T5W8',1,'2026-07-06 00:01:19','2026-07-06 00:02:38'),(4,14,'EP2026-NEW14-T5W8',0,'2026-07-06 00:03:51',NULL);
/*!40000 ALTER TABLE `registration_keys` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `userreg`
--

DROP TABLE IF EXISTS `userreg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `userreg` (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'Уникальный ID пользователя системы',
  `emp_id` int NOT NULL COMMENT 'Ссылка на сотрудника (employees.id)',
  `username` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Логин для входа (например, login@company)',
  `email` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Email (должен быть уникальным)',
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Хеш пароля (pbkdf2:sha256 или bcrypt)',
  `role` enum('admin','operator','viewer') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'viewer' COMMENT 'Роль в системе управления',
  `is_active` tinyint(1) DEFAULT '1' COMMENT 'Активен ли аккаунт (для блокировки без удаления)',
  `telegram_id` bigint DEFAULT NULL COMMENT 'Telegram ID для привязки бота (если используется)',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP COMMENT 'Дата регистрации',
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Дата последнего обновления',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `telegram_id` (`telegram_id`),
  KEY `fk_userreg_employee` (`emp_id`),
  CONSTRAINT `fk_userreg_employee` FOREIGN KEY (`emp_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `userreg`
--

LOCK TABLES `userreg` WRITE;
/*!40000 ALTER TABLE `userreg` DISABLE KEYS */;
INSERT INTO `userreg` VALUES (1,12,'testlogin','pshhh.04@mail.ru','pbkdf2:sha256:1000000$421BXbqLnZsWoBcB$8895ea65b06755b6d29b7a83cd9635bcb9cf40f00c948437bd72637c671038f8','admin',1,NULL,'2026-03-02 23:03:08','2026-03-07 22:04:52'),(2,15,'про','pshhh.sh@ya.ru','pbkdf2:sha256:1000000$GPLQSL9rpo5PkQ6S$40ff5ecbd24abc4f4b43ff7cce35719d7df8b49da9666eb4fab665f7d5f22797','operator',1,NULL,'2026-03-03 13:50:36','2026-03-03 13:50:36'),(3,5,'buttle','pshhh.2004@gmail.com','pbkdf2:sha256:1000000$voQjG5OsNqV1IaOz$1a1c0a9dff01080039263f75960bc29feea7658066e61eebf927b17109df0087','operator',1,NULL,'2026-03-07 17:55:19','2026-03-07 17:55:19'),(4,7,'132423','p4hd4@gmail.com','pbkdf2:sha256:1000000$Tk42lm3JmL5QuzWj$9356b43b26da1c0463e98daca9e7dcb6d3d9117e5586ef51a5b493d65a3ff171','operator',1,NULL,'2026-04-15 18:00:31','2026-04-15 18:00:31'),(5,11,'newlogintest11','vabjkmv@ma','pbkdf2:sha256:1000000$VYruJTHyLzu446GK$27bf853bd062bf30b1d0af8e8d40326f1c88cfb8eb6ffe996d3617d4f20e2d8a','operator',1,NULL,'2026-07-06 00:02:38','2026-07-06 00:02:38');
/*!40000 ALTER TABLE `userreg` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-19  0:00:02
