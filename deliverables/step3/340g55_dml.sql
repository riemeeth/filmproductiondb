-- Database Manipulation queries for a partially implemented portfolio project
-- CS340 Group 55 Daniel Joseph Ethan Riemer
------------------------------------------------------------------------------
--
-- PRODUCTIONS PAGE
-- get all productions for productions page
SELECT productionID as ID, 
    showName as Name,
    contactName as 'Contact Name',
    contactEmail as Email,
    addressLine1 as 'Address Line 1',
    addressLine2 as 'Address Line 2',
    city as City,
    state as State,
    zipCode as 'Zip Code',
    Studios.studioName as Studio
FROM Productions
     INNER JOIN Studios ON Productions.studioID = Studios.studioID
ORDER BY productionID ASC;

-- add new production
SELECT studioName, studioID
FROM Studios;
INSERT INTO Productions (
    showName, 
    contactName, 
    contactEmail,
    addressLine1, 
    addressLine2, 
    city, 
    state, 
    zipCode, 
    studioID
)
VALUES (
     :showName, 
     :contactName, 
     :contactEmail, 
     :addressLine1, 
     :addressLine2,
     :city,
     :state,
     :zipCode,
     :studioID_from_dropdown
);

-- update productions
SELECT studioName, studioID
FROM Studios;
SELECT * 
FROM Productions
WHERE productionID = :productionID_from_browse_page;
UPDATE Productions
SET showName = :showName,
    contactName = :contactName,
    contactEmail = :contactEmail,
    addressLine1 = :addressLine1,
    addressLine2 = :addressLine2, 
    city = :city,
    state = :state,
    zipCode = :zipCode, 
    studioID = :studioID_from_dropwdown
WHERE productionID = :productionID_from_edit_form;

-- delete production
DELETE FROM Productions
WHERE productionID = :productionID_from_browse_page;

--
-- PRODUCTS PAGE
-- get all products for product page
SELECT productID as ID,
    productName as Name,
    cost as Cost,
    retailPrice as 'Retail Price',
    vendors.vendorName as Vendor
FROM products
    INNER JOIN vendors ON products.vendorid = vendors.vendorid
ORDER BY productID ASC;
-- add new product
SELECT vendorName,
    vendorID
FROM vendors;
INSERT INTO products (productName, cost, retailPrice, vendorID)
VALUES (
        :productName,
        :cost,
        :retailPrice,
        :vendorID_from_dropdown
    );
--
-- SALES REP PAGE
-- get all sales reps for sales rep page
SELECT salesRepID as ID,
    salesRepName as Name,
    salesRepEmail as Email
FROM SalesReps
ORDER BY salesRepID ASC;

-- add a sales rep
INSERT INTO SalesReps (salesRepName, salesRepEmail)
VALUES (
        :salesRepName_input,
        :salesRepEmail_input
    );
    
-- edit sales rep
SELECT *
FROM SalesReps
WHERE salesRepID = :salesRepID_from_browse_page;
UPDATE SalesReps
SET salesRepName = :salesRepName,
    salesRepEmail = :salesRepEmail
WHERE salesRepID = :salesRepID_from_browse_page;

-- delete sales rep
DELETE FROM SalesReps
WHERE salesRepID = :salesRepID_from_browse_page;

--
-- STUDIOS PAGE
-- get all studios for studio page
SELECT studioID as ID,
    studioName as Studio,
    contactName as 'Studio Contact',
    contactEmail as Email,
    addressLine1 as 'Address Line 1',
    addressLine2 as 'Address Line 2',
    city as City,
    state as State,
    zipCode as Zip
FROM studios;
-- get all productions for one studio
SELECT productionID as ID,
    studios.studioName as Studio,
    showName as 'Show Name',
    productions.contactName as 'Production Contact',
    productions.contactEmail as Email,
    productions.addressLine1 as 'Address Line 1',
    productions.addressLine2 as 'Address Line 2',
    productions.city as City,
    productions.state as State,
    productions.zipCode as Zip
FROM productions
    INNER JOIN studios ON studios.studioID = productions.studioID
WHERE productions.studioID = :studioID_from_dropdown;
-- add a studio
INSERT INTO studios (
        studioName,
        contactName,
        contactEmail,
        addressLine1,
        addressLine2,
        city,
        state,
        zipCode
    )
VALUES (
        :studioName,
        :contactName,
        :contactEmail,
        :addressLine1,
        :addressLine2,
        :city,
        :state,
        :zipCode
    );
-- delete a studio
DELETE FROM Studios
WHERE studioID = :studioID_from_browse_page;
-- edit a studio
SELECT *
FROM studios
WHERE studioID = :studioID_from_browse_page;
UPDATE studios
SET studioName = :studioName,
    contactName = :contactName,
    contactEmail = :contactEmail,
    addressLine1 = :addressLine1,
    addressLine2 = :addressLine2,
    city = :city,
    state = :state,
    zipCode = :zipCode
WHERE studioID = :studioID_from_edit_form;
--
-- VENDORS PAGE
-- get all vendors for vendor page
SELECT vendorID as ID,
    vendorName as Vendor,
    contactName as 'Vendor Contact',
    contactEmail as Email,
    addressLine1 as 'Address Line 1',
    addressLine2 as 'Address Line 2',
    city as City,
    state as State,
    zipCode as Zip
FROM vendors;
-- add a vendor
INSERT INTO vendors (
        vendorName,
        contactName,
        contactEmail,
        addressLine1,
        addressLine2,
        city,
        state,
        zipCode
    )
VALUES (
        :vendorName,
        :contactName,
        :contactEmail,
        :addressLine1,
        :addressLine2,
        :city,
        :state,
        :zipCode
    );
-- get all products from one vendor
SELECT productID as ID,
    vendors.vendorName as Vendor,
    productName as 'Product Name',
    cost as Cost,
    retailPrice as 'Retail Price'
FROM products
    INNER JOIN vendors ON vendors.vendorID = products.vendorID
WHERE products.vendorID = :vendorID_from_dropdown;
--
-- TERMSCODES PAGE
-- get all term codes for termscodes page
SELECT termsCodeID as ID,
    termCode as Code,
    termName as Name
FROM TermsCodes
ORDER BY termsCodeID ASC;

-- add a termscode
INSERT INTO TermsCodes (`TermCode`, `TermName`)
VALUES ('TermCode_input', 'TermName_input');

-- edit a termscode
SELECT *
FROM TermsCodes
WHERE termCodeID = :termsCodeID_from_browse_page;
UPDATE TermsCodes
SET termsCode = :termsCode,
    termName = :termName
WHERE termCodeID = :termCodeID_from_browse_page;

-- delete a termscode
DELETE FROM TermsCodes
WHERE TermCodeID = :termsCodeID_from_browse_page;

--
-- ORDER PAGE
-- get all orders for order page
SELECT DISTINCT(orders.orderid) as 'Order ID',
    productions.showName as Production,
    termscodes.termName as Terms,
    salesreps.salesRepName as 'Sales Rep',
    orderDate as 'Order Date',
    purchaseOrder as 'Purchase Order',
    (
        SELECT SUM(totalAmount)
        FROM orderdetails
        WHERE orders.orderid = orderdetails.orderid
    ) as 'Total Invoice Amount'
FROM orders
    INNER JOIN orderdetails ON orders.orderid = orderdetails.orderid
    INNER JOIN productions ON orders.productionid = productions.productionid
    INNER JOIN salesreps ON orders.salesrepid = salesreps.salesrepid
    INNER JOIN termscodes ON termscodes.termscodeid = orders.termscodeid
GROUP BY orders.orderid;
SELECT showName,
    productionID
FROM productions;
SELECT salesRepName,
    salesRepID
FROM salesreps;
SELECT termName,
    termscodeid
FROM termscodes;
SELECT productID,
    productName
FROM products;
--
-- get all orders by production
SELECT DISTINCT(orders.orderid) as 'Order ID',
    productions.showName as Production,
    termscodes.termName as Terms,
    salesreps.salesRepName as 'Sales Rep',
    orderDate as 'Order Date',
    purchaseOrder as 'Purchase Number',
    (
        SELECT SUM(totalAmount)
        FROM orderdetails
        WHERE orders.orderid = orderdetails.orderid
    ) as 'Total Invoice Amount'
FROM orders
    INNER JOIN orderdetails ON orders.orderid = orderdetails.orderid
    INNER JOIN productions ON orders.productionid = productions.productionid
    INNER JOIN salesreps ON orders.salesrepid = salesreps.salesrepid
    INNER JOIN termscodes ON termscodes.termscodeid = orders.termscodeid
WHERE productions.productionid = :productionID_from_dropdown
GROUP BY orders.orderid;
--
-- get invoice by order
SELECT DISTINCT(orders.orderid) as 'Order ID',
    productions.showName as Production,
    termscodes.termName as Terms,
    salesreps.salesRepName as 'Sales Rep',
    orderDate as 'Order Date',
    purchaseOrder as 'Purchase Order',
    (
        SELECT SUM(totalAmount)
        FROM orderdetails
        WHERE orders.orderid = orderdetails.orderid
    ) as 'Total Invoice Amount'
FROM orders
    INNER JOIN orderdetails ON orders.orderid = orderdetails.orderid
    INNER JOIN productions ON orders.productionid = productions.productionid
    INNER JOIN salesreps ON orders.salesrepid = salesreps.salesrepid
    INNER JOIN termscodes ON termscodes.termscodeid = orders.termscodeid
WHERE orders.orderid = :orderID_from_browse_page;
SELECT DISTINCT(orderdetails.productID) as 'Product ID',
    products.productName as 'Product Name',
    orderQty as Quantity,
    unitPrice as 'Unit Price',
    (orderQty * unitPrice) as 'Total Amount'
FROM orderdetails
    INNER JOIN products ON products.productID = orderdetails.productid
WHERE orderid = :orderID_from_browse_page;
--
-- create an order
INSERT INTO `Orders` (
        `productionID`,
        `termsCodeID`,
        `salesRepID`,
        `orderDate`,
        `purchaseOrder`
    )
VALUES (
        ':productionID_from_dropdown',
        ':termsCodeID_from_dropdown',
        ':salesRepID_from_dropdown',
        ':orderDate_input',
        ':purchaseOrder_input'
    );
INSERT INTO `OrderDetails` (
        `productID`,
        `orderQty` `unitPrice` `totalAmount`
    )
WHERE orderID = orderID_from_creation_form;
VALUES (
        ':productID_from_dropdown',
        ':quantity_input' ':unitPrice_input' ':totalAmount_input'
    );
-- delete an order
DELETE FROM Orders
WHERE orderID = :orderID_from_browse_page;
-- update an order
UPDATE Orders
SET productionID = productionID_from_dropdown,
    termsCodeID = termsCodeID_from_dropdown,
    salesRepID = salesRepID_from_dropdown,
    orderDate = orderDate_input,
    purchaseOrder = purchaseOrder_input
WHERE orderID = orderID_from_edit_form;
-- add an item
INSERT INTO `OrderDetails` (`productID`, `orderQty`)
WHERE orderID = orderID_from_edit_form
VALUES (
        ':productID_from_dropdown',
        ':quantity_input'
    );
-- update line items
UPDATE OrderDetails
SET productID = productID_from_dropdown,
    orderQty = quantity_input,
    unitPrice = unitPrice_input,
    totalAmount = totalAmount_input
WHERE orderID = orderID_from_edit_form;
-- delete line items
DELETE FROM OrderDetails
WHERE orderDetailsID = :orderDetailsID_from_browse_page;
