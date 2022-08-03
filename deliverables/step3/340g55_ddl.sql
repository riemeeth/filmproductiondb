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
    `studioID`,
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
    1,
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
    2,
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
    3,
    'Disney Studios LLC',
    'Evan Handoles',
    'evanh@disney.com',
    '321 Disney Lane',
    'Buidling 7',
    'Los Angeles',
    'CA',
    '91210'
  ),
  (
    4,
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
    5,
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
    7,
    'Blackhawl Studios INC',
    'Gary Roche',
    'garyr@blackhawlstds.com',
    '12089 South 5th Ave',
    '',
    'Atlanta',
    'GA',
    '30316'
  );
INSERT INTO `Productions` (
    `productionID`,
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
    1,
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
    2,
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
    3,
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
    NULL,
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
    5,
    NULL,
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
    6,
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
    7,
    1,
    'Holy Moly Tony!',
    'Chad Winkle',
    'chadw@netflixprod.com',
    '124 Gastron Blvd',
    'Trailer 4',
    'Salt Lake City',
    'UT',
    '12903'
  );
INSERT INTO `SalesReps` (`salesRepID`, `salesRepName`, `salesRepEmail`)
VALUES (1, 'Dan Joseph', 'danj@sales.com'),
  (2, 'Mike Row', 'mikem@sales.com'),
  (3, 'Nicole Lans', 'nicolel@sales.com'),
  (4, 'Amanda Stone', 'amandas@sales.com'),
  (5, 'John Francis', 'johnf@sales.com'),
  (6, 'Ethan Reimer', 'ethanr@sales.com');
INSERT INTO `TermsCodes` (`termsCodeID`, `termCode`, `termName`)
VALUES (1, '10', 'NET10'),
  (2, '15', 'NET15'),
  (3, '20', 'NET20'),
  (4, '30', 'NET30'),
  (5, '60', 'NET60'),
  (6, '90', 'NET90'),
  (7, '120', 'NET120'),
  (8, '180', 'NET180'),
  (9, '365', 'NET365');
INSERT INTO `Vendors` (
    `vendorID`,
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
    1,
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
    2,
    'Zaxel',
    'Glenjamin Zansers',
    'glenjaminz@zaxel.com',
    '16 Boulevard NE',
    '',
    'Hoboken',
    'NJ',
    '00926'
  ),
  (
    3,
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
    4,
    'Callaham Automoto',
    'Dave Callaham',
    'davec@callaham.com',
    '1 Newburgh Blvd',
    '',
    'Boston',
    'MA',
    '29756'
  );
INSERT INTO `Products` (
    `productID`,
    `productName`,
    `cost`,
    `retailPrice`,
    `vendorID`
  )
VALUES (1, 'Wireless Sticks', '139.09', '499.99', 1),
  (2, 'Blomight', '1298.12', '4999.99', 4),
  (3, 'Machanio', '45.12', '103.45', 1),
  (4, 'Screws', '0.01', '1.00', 3),
  (5, 'Mustache Feet', '421.99', '505.10', 1),
  (
    6,
    'Grip to Ground Adapter',
    '249.99',
    '349.99',
    1
  ),
  (7, 'Electric Eels', '205.10', '401.33', 4),
  (
    8,
    'Premium Burlap Cargo Shorts',
    '34.93',
    '192.09',
    2
  );
INSERT INTO `Orders` (
    `orderID`,
    `productionID`,
    `termsCodeID`,
    `salesRepID`,
    `orderDate`,
    `purchaseOrder`
  )
VALUES (1, 1, 1, 2, '2022-07-08 22:08:15', '1903'),
  (2, 1, 1, 2, '2022-06-12 22:08:45', '12984'),
  (3, 4, 2, 4, '2022-07-08 22:11:32', '14A12'),
  (4, 5, 3, 1, '2022-07-09 17:17:14', 'A103'),
  (5, 5, 4, 1, '2022-07-09 17:17:14', 'A104'),
  (6, 6, 5, 4, '2022-07-09 17:18:58', '2148'),
  (7, 6, 6, 5, '2022-07-09 17:18:58', '1210'),
  (8, 7, 4, 6, '2022-07-18 00:36:06', 'A098');
INSERT INTO `OrderDetails` (
    `orderDetailsID`,
    `orderID`,
    `productID`,
    `orderQty`,
    `unitPrice`,
    `totalAmount`
  )
VALUES (1, 1, 2, 1, '99.00', '99.00'),
  (2, 3, 1, 2, '40.00', '80.00'),
  (3, 2, 4, 100, '1.00', '100.00'),
  (4, 4, 6, 1, '349.00', '349.00'),
  (5, 4, 3, 2, '200.00', '400.00'),
  (6, 5, 5, 1, '124.00', '124.00'),
  (7, 6, 6, 1, '400.00', '400.00'),
  (8, 7, 5, 2, '200.00', '400.00'),
  (9, 7, 3, 2, '11.00', '22.00'),
  (10, 8, 7, 12, '302.99', '3635.88'),
  (11, 8, 4, 100, '1.00', '100.00');
SET FOREIGN_KEY_CHECKS = 1;
COMMIT;