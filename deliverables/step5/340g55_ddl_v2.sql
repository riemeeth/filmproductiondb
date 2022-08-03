--
-- CS340 Step 2 Draft Group 55 Daniel Joseph Ethan Reimer 
--
-- Date: 07/14/2022
-- Based on source code from CS340 Modules 2, 3, & 4.
-- Written by Prof. Danielle Safonte & Prof. Michael Curry
--
SET FOREIGN_KEY_CHECKS = 0;
SET AUTOCOMMIT = 0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
-- -----------------------------------------------------
-- Table `Studios`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Studios`;
CREATE TABLE IF NOT EXISTS `Studios` (
  `studioID` INT(11) NOT NULL AUTO_INCREMENT,
  `studioName` VARCHAR(45) NOT NULL,
  `contactName` VARCHAR(45) NOT NULL,
  `contactEmail` VARCHAR(256) NOT NULL UNIQUE,
  `addressLine1` VARCHAR(50) NOT NULL,
  `addressLine2` VARCHAR(50) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `state` VARCHAR(45) NOT NULL,
  `zipCode` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`studioID`)
);
-- -----------------------------------------------------
-- Table `Productions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Productions`;
CREATE TABLE IF NOT EXISTS `Productions` (
  `productionID` INT(11) NOT NULL AUTO_INCREMENT,
  `studioID` INT(11) NULL,
  `showName` VARCHAR(45) NOT NULL,
  `contactName` VARCHAR(45) NOT NULL,
  `contactEmail` VARCHAR(256) NOT NULL UNIQUE,
  `addressLine1` VARCHAR(50) NOT NULL,
  `addressLine2` VARCHAR(50) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `state` VARCHAR(45) NOT NULL,
  `zipCode` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`productionID`),
  INDEX `StudioID_idx` (`studioID` ASC) VISIBLE,
  CONSTRAINT `StudioID` FOREIGN KEY (`studioID`) REFERENCES `Studios` (`studioID`) ON DELETE
  SET NULL ON UPDATE CASCADE
);
-- -----------------------------------------------------
-- Table `SalesReps`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `SalesReps`;
CREATE TABLE IF NOT EXISTS `SalesReps` (
  `salesRepID` INT(11) NOT NULL AUTO_INCREMENT,
  `salesRepName` VARCHAR(45) NOT NULL,
  `salesRepEmail` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`salesRepID`)
);
-- -----------------------------------------------------
-- Table `TermsCodes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `TermsCodes`;
CREATE TABLE IF NOT EXISTS `TermsCodes` (
  `termsCodeID` INT(11) NOT NULL AUTO_INCREMENT,
  `termCode` VARCHAR(45) NOT NULL,
  `termName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`termsCodeID`)
);
-- -----------------------------------------------------
-- Table `Orders`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Orders`;
CREATE TABLE IF NOT EXISTS `Orders` (
  `orderID` INT(11) NOT NULL AUTO_INCREMENT,
  `productionID` INT(11) NULL,
  `termsCodeID` INT(11) NULL,
  `salesRepID` INT(11) NULL,
  `orderDate` DATETIME NOT NULL,
  `purchaseOrder` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`orderID`),
  INDEX `ProductionID_idx` (`productionID` ASC) VISIBLE,
  INDEX `SalesRepID_idx` (`salesRepID` ASC) VISIBLE,
  INDEX `TermsCodeID_idx` (`termsCodeID` ASC) VISIBLE,
  CONSTRAINT `ProductionID` FOREIGN KEY (`productionID`) REFERENCES `Productions` (`productionID`) ON DELETE
  SET NULL ON UPDATE NO ACTION,
    CONSTRAINT `SalesRepID` FOREIGN KEY (`salesRepID`) REFERENCES `SalesReps` (`salesRepID`) ON DELETE
  SET NULL ON UPDATE NO ACTION,
    CONSTRAINT `TermsCodeID` FOREIGN KEY (`termsCodeID`) REFERENCES `TermsCodes` (`termsCodeID`) ON DELETE NO ACTION ON UPDATE NO ACTION
);
-- -----------------------------------------------------
-- Table `Vendors`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Vendors`;
CREATE TABLE IF NOT EXISTS `Vendors` (
  `vendorID` INT(11) NOT NULL AUTO_INCREMENT,
  `vendorName` VARCHAR(45) NOT NULL,
  `contactName` VARCHAR(45) NOT NULL,
  `contactEmail` VARCHAR(256) NOT NULL UNIQUE,
  `addressLine1` VARCHAR(50) NOT NULL,
  `addressLine2` VARCHAR(50) NOT NULL,
  `city` VARCHAR(45) NOT NULL,
  `state` VARCHAR(45) NOT NULL,
  `zipCode` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`vendorID`)
);
-- -----------------------------------------------------
-- Table `Products`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `Products`;
CREATE TABLE IF NOT EXISTS `Products` (
  `productID` INT(11) NOT NULL AUTO_INCREMENT,
  `productName` VARCHAR(45) NOT NULL,
  `cost` DECIMAL(19, 2) NOT NULL,
  `retailPrice` DECIMAL(19, 2) NOT NULL,
  `vendorID` INT(11) NULL,
  PRIMARY KEY (`productID`),
  INDEX `VendorID_idx` (`vendorID` ASC) VISIBLE,
  CONSTRAINT `VendorID` FOREIGN KEY (`vendorID`) REFERENCES `Vendors` (`vendorID`) ON DELETE
  SET NULL ON UPDATE NO ACTION
);
-- -----------------------------------------------------
-- Table `OrderDetails`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `OrderDetails`;
CREATE TABLE IF NOT EXISTS `OrderDetails` (
  `orderDetailsID` INT(11) NOT NULL AUTO_INCREMENT,
  `orderID` INT(11) NOT NULL,
  `productID` INT(11) NOT NULL,
  `orderQty` INT(11) NOT NULL,
  `unitPrice` DECIMAL(19, 2) NOT NULL,
  `totalAmount` DECIMAL(19, 2) NOT NULL,
  PRIMARY KEY (`orderDetailsID`),
  INDEX `OrderID_idx` (`orderID` ASC) VISIBLE,
  INDEX `ProductID_idx` (`productID` ASC) VISIBLE,
  CONSTRAINT `OrderID` FOREIGN KEY (`orderID`) REFERENCES `Orders` (`orderID`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `ProductID` FOREIGN KEY (`productID`) REFERENCES `Products` (`productID`) ON DELETE NO ACTION ON UPDATE NO ACTION
);
-- -----------------------------------------------------
-- SAMPLE DATA
-- -----------------------------------------------------
INSERT INTO `Studios` (
    `studioName`,
    `contactName`,
    `contactEmail`,
    `addressLine1`,
    `addressLine2`,
    `city`,
    `state`,
    `zipCode`
  )
VALUES (
    'Netflix Productions',
    'Wendy Czerkawski',
    'wendyc@netflix.com',
    '100 Netflix Way',
    '2nd Floor',
    'Los Angeles',
    'CA',
    '91210'
  ),
  (
    'Marvel Productions',
    'John Bubins',
    'johnb@marvel.com',
    '999 Marvel Way',
    '',
    'Los Angeles',
    'CA',
    '91210'
  ),
  (
    'Disney Studios LLC',
    'Evan Handoles',
    'evanh@disney.com',
    '321 Disney Lane',
    'Building 7',
    'Los Angeles',
    'CA',
    '91210'
  ),
  (
    'TPS Productions',
    'Tyler Terry',
    'tylert@tpsprod.com',
    '420 TPS Studios Lane',
    '',
    'Atlanta',
    'GA',
    '30318'
  ),
  (
    'Steiner Studios',
    'Brett Hartman',
    'bretth@steinerstudios.com',
    '9007 Astoria Blvd',
    'Bungalow 71',
    'New York',
    'NY',
    '10016'
  ),
  (
    'Blackhawl Studios INC',
    'Gary Roche',
    'garyr@blackhawlstds.com',
    '12089 South 5th Ave',
    '',
    'Atlanta',
    'GA',
    '30316'
  ),
  (
    'Green Lantern Studios',
    'John Logan',
    'johnl@greenlantern.com',
    '15-21 9th Ave',
    'Suite 400',
    'New York',
    'NY',
    '10116'
  );
INSERT INTO `Productions` (
    `studioID`,
    `showName`,
    `contactName`,
    `contactEmail`,
    `addressLine1`,
    `addressLine2`,
    `city`,
    `state`,
    `zipCode`
  )
VALUES (
    3,
    'Great Baking Show',
    'Abdul Rena',
    'abdulr@netflix.com',
    '89 Peachtree Tr.',
    '',
    'Atlanta',
    'GA',
    '30316'
  ),
  (
    3,
    'Real Housedogs Season 24',
    'Butch Uppercut',
    'butchu@netflix.com',
    '345 Blackhall Studio Way',
    'Building 43',
    'Atlanta',
    'GA',
    '30031'
  ),
  (
    4,
    'Avengers 17: How Hawkeye Got His Groove Back',
    'Lance Steel',
    'lances@marvel.com',
    '1001 Veterans Pkwy',
    'Building 2, 3rd Floor',
    'Los Angeles',
    'CA',
    '90210'
  ),
  (
    4,
    'Madeas Nose Job',
    'Pyler Terry',
    'pylert@tpsprod.com',
    '123 TPS Way',
    '',
    'Altanta',
    'GA',
    '30103'
  ),
  (
    4,
    'Madea vs Gout',
    'Myler Sterry',
    'mylers@tpsprod.com',
    '123 TPS Way',
    '',
    'Atlanta',
    'GA',
    '30103'
  ),
  (
    5,
    'Sneak King X Glee',
    'Madeline Kury',
    'madelinek@disney.com',
    '2013 East 89th Ave',
    'Suite 721',
    'New York',
    'NY',
    '10019'
  ),
  (
    1,
    'Holy Moly Tony!',
    'Chad Winkle',
    'chadw@netflixprod.com',
    '124 Gastron Blvd',
    'Trailer 4',
    'Salt Lake City',
    'UT',
    '12903'
  ),
  (
    7,
    'We Walkin',
    'Grant Jonmpkins',
    'grantj@wewalkinprod.com',
    '12345 Main St',
    '',
    'Altarna',
    'NM',
    '87101'
  );
INSERT INTO `SalesReps` (`salesRepName`, `salesRepEmail`)
VALUES ('Dan Joseph', 'danj@sales.com'),
  ('Mike Row', 'mikem@sales.com'),
  ('Nicole Lans', 'nicolel@sales.com'),
  ('Amanda Stone', 'amandas@sales.com'),
  ('John Francis', 'johnf@sales.com'),
  ('Ethan Reimer', 'ethanr@sales.com'),
  ('Kat Steiner', 'kats@sales.com');
INSERT INTO `TermsCodes` (`termCode`, `termName`)
VALUES ('10', 'NET10'),
  ('15', 'NET15'),
  ('20', 'NET20'),
  ('30', 'NET30'),
  ('60', 'NET60'),
  ('90', 'NET90');
INSERT INTO `Vendors` (
    `vendorName`,
    `contactName`,
    `contactEmail`,
    `addressLine1`,
    `addressLine2`,
    `city`,
    `state`,
    `zipCode`
  )
VALUES (
    'Pectrole',
    'Mordon Gore',
    'mordong@pectrole.com',
    '4123 Glaser Ave',
    'Suite 109',
    'New Donk City',
    'NM',
    '76293'
  ),
  (
    'Zinael',
    'Glenjamin Zansers',
    'glenjaminz@zaxel.com',
    '16 Boulevard NE',
    '',
    'Hoboken',
    'NJ',
    '00926'
  ),
  (
    'Lomos',
    'Shlomo Merchenski',
    'shlomom@lomos.com',
    '8765 31st Ave',
    'Suite 910',
    'New York',
    'NY',
    '10016'
  ),
  (
    'Callaham Automoto',
    'Dave Callaham',
    'davec@callaham.com',
    '1 Newburgh Blvd',
    '',
    'Boston',
    'MA',
    '29756'
  ),
  (
    'Luckee Ten Cents',
    'Big Jim Hampton',
    'bigjim@ltc.com',
    'PO Box 129',
    '',
    'San Francsico',
    'CA',
    '90210'
  );
INSERT INTO `Products` (
    `productName`,
    `cost`,
    `retailPrice`,
    `vendorID`
  )
VALUES ('Wireless Sticks', '139.09', '499.99', 1),
  ('Blomight', '1298.12', '4999.99', 4),
  ('Machanio', '45.12', '103.45', 1),
  ('Screws', '0.01', '1.00', 3),
  ('Mustache Feet', '421.99', '505.10', 1),
  (
    'Grip to Ground Adapter',
    '249.99',
    '349.99',
    1
  ),
  ('Electric Eels', '205.10', '401.33', 4),
  (
    'Premium Burlap Cargo Shorts',
    '34.93',
    '192.09',
    2
  ),
  ('Cat Chasers', '12.99', '99.99', 1),
  ('C-47', '1.99', '3.99', 4);
INSERT INTO `Orders` (
    `productionID`,
    `termsCodeID`,
    `salesRepID`,
    `orderDate`,
    `purchaseOrder`
  )
VALUES (1, 1, 2, '2022-07-08 22:08:15', '1903'),
  (1, 1, 2, '2022-06-12 22:08:45', '12984'),
  (4, 2, 4, '2022-07-08 22:11:32', '14A12'),
  (5, 3, 1, '2022-07-09 17:17:14', 'A103'),
  (5, 4, 1, '2022-07-09 17:17:14', 'A104'),
  (6, 5, 4, '2022-07-09 17:18:58', '2148'),
  (6, 3, 3, '2022-07-09 17:18:58', '1210'),
  (7, 4, 6, '2022-07-18 00:36:06', 'A098');
INSERT INTO `OrderDetails` (
    `orderID`,
    `productID`,
    `orderQty`,
    `unitPrice`,
    `totalAmount`
  )
VALUES (2, 1, '1', '99.00', '99.00'),
  (1, 2, '2', '40.00', '80.00'),
  (4, 3, '100', '1.00', '100.00'),
  (6, 1, '1', '349.00', '349.00'),
  (3, 2, '2', '200.00', '400.00'),
  (5, 1, '1', '124.00', '124.00'),
  (5, 1, '1', '99.00', '99.00'),
  (4, 2, '2', '40.00', '80.00'),
  (3, 3, '100', '1.00', '100.00'),
  (3, 1, '1', '349.00', '349.00'),
  (2, 2, '2', '200.00', '400.00'),
  (2, 1, '1', '124.00', '124.00'),
  (4, 1, '1', '99.00', '99.00'),
  (3, 2, '2', '40.00', '80.00'),
  (2, 3, '100', '1.00', '100.00'),
  (2, 1, '1', '349.00', '349.00'),
  (1, 2, '2', '200.00', '400.00'),
  (1, 1, '1', '124.00', '124.00');
SET FOREIGN_KEY_CHECKS = 1;
COMMIT;