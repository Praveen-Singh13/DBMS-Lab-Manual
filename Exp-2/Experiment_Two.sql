-- Experiment 2
-- Converting an ER diagram into relational tables
-- Retail inventory and purchase system

-- 1. Create the database

DROP DATABASE IF EXISTS RetailHub;
CREATE DATABASE RetailHub;
USE RetailHub;


-- 2. Members

CREATE TABLE Member (
    Member_ID INT PRIMARY KEY AUTO_INCREMENT,
    Member_Name VARCHAR(100) NOT NULL,
    Email_Address VARCHAR(100) NOT NULL UNIQUE,
    Login_Key VARCHAR(100) NOT NULL,
    Registered_On DATE NOT NULL
);


-- 3. Member contact numbers
-- A member can have more than one contact number.

CREATE TABLE Member_Contact (
    Member_ID INT NOT NULL,
    Contact_Number VARCHAR(15) NOT NULL,

    PRIMARY KEY (Member_ID, Contact_Number),

    FOREIGN KEY (Member_ID)
        REFERENCES Member(Member_ID)
        ON DELETE CASCADE
);


-- 4. Vendors

CREATE TABLE Vendor (
    Vendor_ID INT PRIMARY KEY AUTO_INCREMENT,
    Vendor_Name VARCHAR(100) NOT NULL,
    Email_Address VARCHAR(100) NOT NULL UNIQUE,
    Phone_Number VARCHAR(15) NOT NULL UNIQUE
);


-- 5. Departments

CREATE TABLE Department (
    Department_ID INT PRIMARY KEY AUTO_INCREMENT,
    Department_Name VARCHAR(100) NOT NULL UNIQUE,
    Details VARCHAR(255)
);


-- 6. Items

CREATE TABLE Item (
    Item_ID INT PRIMARY KEY AUTO_INCREMENT,
    Item_Name VARCHAR(150) NOT NULL,
    Unit_Cost DECIMAL(10,2) NOT NULL,
    Available_Units INT NOT NULL DEFAULT 0,
    Department_ID INT NOT NULL,
    Vendor_ID INT,

    CONSTRAINT chk_item_price
        CHECK (Unit_Cost >= 0),

    CONSTRAINT chk_item_stock
        CHECK (Available_Units >= 0),

    FOREIGN KEY (Department_ID)
        REFERENCES Department(Department_ID)
        ON DELETE CASCADE,

    FOREIGN KEY (Vendor_ID)
        REFERENCES Vendor(Vendor_ID)
        ON DELETE SET NULL
);


-- 7. Item specializations
-- Some items are gadgets and some are apparel.

CREATE TABLE Gadget_Item (
    Item_ID INT PRIMARY KEY,
    Coverage_Years INT NOT NULL,

    FOREIGN KEY (Item_ID)
        REFERENCES Item(Item_ID)
        ON DELETE CASCADE,

    CHECK (Coverage_Years >= 0)
);


CREATE TABLE Apparel_Item (
    Item_ID INT PRIMARY KEY,
    Fit_Size VARCHAR(10) NOT NULL,
    Fabric_Type VARCHAR(50),

    FOREIGN KEY (Item_ID)
        REFERENCES Item(Item_ID)
        ON DELETE CASCADE
);


-- 8. Member locations
-- A location belongs to a particular member.

CREATE TABLE Location (
    Member_ID INT NOT NULL,
    Location_ID INT NOT NULL,
    Location_Type VARCHAR(20) NOT NULL,
    Building_No VARCHAR(50) NOT NULL,
    Street_Name VARCHAR(100),
    Town VARCHAR(50) NOT NULL,
    Region VARCHAR(50) NOT NULL,
    Postal_Code VARCHAR(10) NOT NULL,

    PRIMARY KEY (Member_ID, Location_ID),

    FOREIGN KEY (Member_ID)
        REFERENCES Member(Member_ID)
        ON DELETE CASCADE
);


-- 9. Purchases
-- Each purchase is linked to one member and one location.

CREATE TABLE Purchases (
    Purchase_ID INT PRIMARY KEY AUTO_INCREMENT,
    Member_ID INT NOT NULL,
    Location_ID INT NOT NULL,
    Purchase_Date DATE NOT NULL,
    Grand_Total DECIMAL(12,2) NOT NULL,
    Purchase_Status VARCHAR(30) NOT NULL DEFAULT 'Placed',

    CONSTRAINT chk_purchase_total
        CHECK (Grand_Total >= 0),

    FOREIGN KEY (Member_ID, Location_ID)
        REFERENCES Location(Member_ID, Location_ID)
        ON DELETE CASCADE
);


-- 10. Items included in each purchase

CREATE TABLE PurchaseItem (
    Purchase_ID INT NOT NULL,
    Item_ID INT NOT NULL,
    Units INT NOT NULL,
    Item_Rate DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (Purchase_ID, Item_ID),

    CONSTRAINT chk_units
        CHECK (Units > 0),

    CONSTRAINT chk_item_rate
        CHECK (Item_Rate >= 0),

    FOREIGN KEY (Purchase_ID)
        REFERENCES Purchases(Purchase_ID)
        ON DELETE CASCADE,

    FOREIGN KEY (Item_ID)
        REFERENCES Item(Item_ID)
        ON DELETE CASCADE
);


-- 11. Payment records

CREATE TABLE PaymentRecord (
    Transaction_ID INT PRIMARY KEY AUTO_INCREMENT,
    Purchase_ID INT NOT NULL UNIQUE,
    Transaction_Method VARCHAR(30) NOT NULL,
    Transaction_Status VARCHAR(30) NOT NULL,
    Reference_Code VARCHAR(100) UNIQUE,
    Transaction_Date DATE,

    FOREIGN KEY (Purchase_ID)
        REFERENCES Purchases(Purchase_ID)
        ON DELETE CASCADE
);


-- 12. Shipment details

CREATE TABLE Shipment (
    Shipment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Purchase_ID INT NOT NULL UNIQUE,
    Shipment_Date DATE,
    Shipment_Status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    Shipment_Code VARCHAR(100) UNIQUE,

    FOREIGN KEY (Purchase_ID)
        REFERENCES Purchases(Purchase_ID)
        ON DELETE CASCADE
);


-- 13. Add a few members

INSERT INTO Member
(Member_Name, Email_Address, Login_Key, Registered_On)
VALUES
('Neha Mehta', 'neha.mehta@gmail.com', 'neha456', '2026-03-05'),
('Vikram Rao', 'vikram.rao@gmail.com', 'vikram456', '2026-03-12'),
('Kavya Nair', 'kavya.nair@gmail.com', 'kavya456', '2026-03-20'),
('Arjun Malhotra', 'arjun.malhotra@gmail.com', 'arjun456', '2026-03-28');


-- 14. Add member contact numbers

INSERT INTO Member_Contact
(Member_ID, Contact_Number)
VALUES
(1, '9812345670'),
(1, '9765432108'),
(2, '9823456711'),
(3, '9834567822'),
(4, '9845678933');


-- 15. Add vendors

INSERT INTO Vendor
(Vendor_Name, Email_Address, Phone_Number)
VALUES
('Digital Point India', 'digitalpoint@gmail.com', '9100000001'),
('Style Corner India', 'stylecorner@gmail.com', '9100000002'),
('Comfort Living India', 'comfortliving@gmail.com', '9100000003');


-- 16. Add departments

INSERT INTO Department
(Department_Name, Details)
VALUES
('Gadgets', 'Smart devices and electronic accessories'),
('Apparel', 'Casual wear for men and women'),
('Home Decor', 'Useful products for comfortable homes');


-- 17. Add items

INSERT INTO Item
(Item_Name, Unit_Cost, Available_Units, Department_ID, Vendor_ID)
VALUES
('Bluetooth Speaker', 1899.00, 45, 1, 1),
('Wireless Mouse', 1299.00, 60, 1, 1),
('Denim Jacket', 2199.00, 35, 2, 2),
('Fitness Band', 2799.00, 28, 1, 1),
('Decorative Wall Clock', 999.00, 50, 3, 3);


-- 18. Add gadget details

INSERT INTO Gadget_Item
(Item_ID, Coverage_Years)
VALUES
(1, 2),
(2, 1),
(4, 1);


-- 19. Add apparel details

INSERT INTO Apparel_Item
(Item_ID, Fit_Size, Fabric_Type)
VALUES
(3, 'M', 'Denim');


-- 20. Add member locations

INSERT INTO Location
(Member_ID, Location_ID, Location_Type, Building_No,
 Street_Name, Town, Region, Postal_Code)
VALUES
(1, 1, 'Home', 'B-214', 'Park Street', 'Kolkata',
 'West Bengal', '700016'),

(1, 2, 'Office', 'Suite 408', 'Lake View Road', 'Kolkata',
 'West Bengal', '700029'),

(2, 1, 'Home', 'C-118', 'Park Avenue', 'Pune',
 'Maharashtra', '411001'),

(3, 1, 'Home', 'A-307', 'Marine Road', 'Kochi',
 'Kerala', '682011'),

(4, 1, 'Home', 'D-512', 'Ridge Road', 'Jaipur',
 'Rajasthan', '302001');


-- 21. Add purchases

INSERT INTO Purchases
(Member_ID, Location_ID, Purchase_Date, Grand_Total, Purchase_Status)
VALUES
(1, 1, '2026-09-02', 1899.00, 'Placed'),

(2, 1, '2026-09-04', 1299.00, 'Shipped'),

(3, 1, '2026-09-06', 2199.00, 'Delivered');


-- 22. Add the items bought in each purchase

INSERT INTO PurchaseItem
(Purchase_ID, Item_ID, Units, Item_Rate)
VALUES
(1, 1, 1, 1899.00),
(2, 2, 1, 1299.00),
(3, 3, 1, 2199.00);


-- 23. Add payment information

INSERT INTO PaymentRecord
(Purchase_ID, Transaction_Method, Transaction_Status,
 Reference_Code, Transaction_Date)
VALUES
(1, 'Net Banking', 'Success', 'PAY20001', '2026-09-02'),

(2, 'Debit Card', 'Success', 'PAY20002', '2026-09-04'),

(3, 'Cash on Delivery', 'Pending', NULL, NULL);


-- 24. Add shipment information

INSERT INTO Shipment
(Purchase_ID, Shipment_Date, Shipment_Status, Shipment_Code)
VALUES
(1, '2026-09-06', 'Delivered', 'SHIP20001'),

(2, NULL, 'In Transit', 'SHIP20002'),

(3, '2026-09-11', 'Delivered', 'SHIP20003');


-- 25. Check the data in all tables

SELECT * FROM Member;

SELECT * FROM Member_Contact;

SELECT * FROM Vendor;

SELECT * FROM Department;

SELECT * FROM Item;

SELECT * FROM Gadget_Item;

SELECT * FROM Apparel_Item;

SELECT * FROM Location;

SELECT * FROM Purchases;

SELECT * FROM PurchaseItem;

SELECT * FROM PaymentRecord;

SELECT * FROM Shipment;


-- 26. Test the NOT NULL constraint

-- This should fail because a member name is required.

INSERT INTO Member
(Member_Name, Email_Address, Login_Key, Registered_On)
VALUES
(NULL, 'invalid.customer@gmail.com', 'invalid456', '2026-09-19');


-- 27. Test the UNIQUE constraint

-- This should fail because the email is already in use.

INSERT INTO Member
(Member_Name, Email_Address, Login_Key, Registered_On)
VALUES
('Existing Email User', 'neha.mehta@gmail.com', 'existing456', '2026-09-19');


-- 28. Test the PRIMARY KEY constraint

-- Member_ID 1 is already present in the table.

INSERT INTO Member
(Member_ID, Member_Name, Email_Address, Login_Key, Registered_On)
VALUES
(1, 'Repeated Member', 'repeated@gmail.com',
 'repeated456', '2026-09-19');


-- 29. Test the member foreign key

-- This member does not exist, so the insert should fail.

INSERT INTO Member_Contact
(Member_ID, Contact_Number)
VALUES
(999, '9899999999');


-- 30. Test the item foreign key

-- There is no department with ID 999.

INSERT INTO Item
(Item_Name, Unit_Cost, Available_Units, Department_ID, Vendor_ID)
VALUES
('Unlisted Item', 1599.00, 12, 999, 1);


-- 31. Test the purchase item foreign key

-- There is no item with ID 999.

INSERT INTO PurchaseItem
(Purchase_ID, Item_ID, Units, Item_Rate)
VALUES
(1, 999, 1, 1599.00);


-- 32. Check ON DELETE SET NULL

-- First check the vendor linked to item 1.

SELECT * FROM Item
WHERE Item_ID = 1;

-- Remove vendor 1.

DELETE FROM Vendor
WHERE Vendor_ID = 1;

-- The item remains, but its Vendor_ID should become NULL.

SELECT * FROM Item
WHERE Item_ID = 1;


-- 33. Check ON DELETE CASCADE

-- Remove department 3.

DELETE FROM Department
WHERE Department_ID = 3;

-- Items in that department should be removed automatically.

SELECT * FROM Item
WHERE Department_ID = 3;


-- 34. Check the purchase cascade

-- Remove purchase 1.

DELETE FROM Purchases
WHERE Purchase_ID = 1;

-- The related purchase item, payment, and shipment rows
-- should also be deleted.

SELECT * FROM PurchaseItem
WHERE Purchase_ID = 1;

SELECT * FROM PaymentRecord
WHERE Purchase_ID = 1;

SELECT * FROM Shipment
WHERE Purchase_ID = 1;


-- 35. Show purchase details using a join

SELECT
    O.Purchase_ID,
    C.Member_Name,
    P.Item_Name,
    OI.Units,
    OI.Item_Rate,
    O.Purchase_Status
FROM Purchases O
JOIN Member C
    ON O.Member_ID = C.Member_ID
JOIN PurchaseItem OI
    ON O.Purchase_ID = OI.Purchase_ID
JOIN Item P
    ON OI.Item_ID = P.Item_ID;
