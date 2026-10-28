-- DBMS practical - Experiment 6
-- Staff member, division and assignment database
-- Create the database
CREATE DATABASE IF NOT EXISTS EnterpriseDB;

USE EnterpriseDB;
-- 1. Create the tables
-- Divisions
CREATE TABLE IF NOT EXISTS Division (
    division_id INT PRIMARY KEY,
    division_name VARCHAR(50) NOT NULL
);


-- Assignments
CREATE TABLE IF NOT EXISTS Assignment (
    assignment_id INT PRIMARY KEY,
    assignment_name VARCHAR(100) NOT NULL,
    funding DECIMAL(12,2),
    division_id INT,
    FOREIGN KEY (division_id) REFERENCES Division(division_id)
);


-- Staff members
CREATE TABLE IF NOT EXISTS StaffMember (
    staff_id INT PRIMARY KEY,
    staff_name VARCHAR(50) NOT NULL,
    monthly_pay DECIMAL(10,2),
    joining_date DATE,
    division_id INT,
    assignment_id INT,
    FOREIGN KEY (division_id) REFERENCES Division(division_id),
    FOREIGN KEY (assignment_id) REFERENCES Assignment(assignment_id)
);
-- 2. Add divisions
INSERT INTO Division (division_id, division_name) VALUES
(1, 'Engineering'),
(2, 'People Operations'),
(3, 'Accounts'),
(4, 'Outreach'),
(5, 'Logistics');
-- 3. Add assignments
INSERT INTO Assignment (assignment_id, assignment_name, funding, division_id) VALUES
(101, 'Network Upgrade', 175000, 1),
(102, 'Data Insights', 225000, 1),
(103, 'Hiring Tracker', 95000, 2),
(104, 'Budget Monitor', 135000, 3),
(105, 'Brand Promotion', 105000, 4),
(106, 'Warehouse Planner', 195000, 5),
(107, 'Customer App', 155000, 1),
(108, 'Wellness Initiative', 79000, 2);
-- 4. Add 30 staff members
INSERT INTO StaffMember
(staff_id, staff_name, monthly_pay, joining_date, division_id, assignment_id)
VALUES
(1, 'Nitin', 71000, '2022-01-10', 1, 101),
(2, 'Harsh', 80000, '2021-03-15', 1, 102),
(3, 'Mohan', 68000, '2023-06-20', 1, 107),
(4, 'Siddharth', 88000, '2020-08-12', 1, 101),
(5, 'Ritesh', 77000, '2022-11-05', 1, 102),
(6, 'Kunal', 74000, '2024-02-18', 1, 107),

(7, 'Pooja', 58000, '2022-04-11', 2, 103),
(8, 'Shruti', 54000, '2023-01-22', 2, 108),
(9, 'Nandini', 68000, '2021-07-19', 2, 103),
(10, 'Komal', 58000, '2022-09-30', 2, 108),
(11, 'Ritika', 50000, '2024-03-14', 2, 103),
(12, 'Alisha', 62000, '2020-12-01', 2, 108),

(13, 'Sameer', 79000, '2021-02-17', 3, 104),
(14, 'Vivek', 71000, '2022-05-09', 3, 104),
(15, 'Amit', 87000, '2019-10-21', 3, 104),
(16, 'Pranav', 74000, '2023-08-13', 3, 104),
(17, 'Rahul', 71000, '2021-11-28', 3, 104),
(18, 'Tarun', 59000, '2024-01-09', 3, 104),

(19, 'Isha', 60000, '2022-02-25', 4, 105),
(20, 'Mahi', 71000, '2021-06-16', 4, 105),
(21, 'Ankita', 60000, '2023-04-10', 4, 105),
(22, 'Simran', 74000, '2020-09-07', 4, 105),
(23, 'Neha', 54000, '2024-02-05', 4, 105),
(24, 'Palak', 74000, '2022-12-19', 4, 105),

(25, 'Akhil', 79000, '2021-01-12', 5, 106),
(26, 'Varun', 77000, '2020-04-23', 5, 106),
(27, 'Gaurav', 71000, '2022-07-18', 5, 106),
(28, 'Yuvraj', 62000, '2023-05-29', 5, 106),
(29, 'Manish', 80000, '2019-08-31', 5, 106),
(30, 'Abhishek', 68000, '2024-01-20', 5, 106);
-- 5. Selection
-- Show staff members earning more than 74,000.
SELECT *
FROM StaffMember
WHERE monthly_pay > 74000;
-- 6. Projection
-- Show only staff names and their monthly pay.
SELECT staff_name, monthly_pay
FROM StaffMember;
-- 7. Aggregate functions
-- Find the count, average, highest, lowest and total pay.
SELECT
    COUNT(*) AS total_employees,
    AVG(monthly_pay) AS average_pay,
    MAX(monthly_pay) AS highest_pay,
    MIN(monthly_pay) AS lowest_pay,
    SUM(monthly_pay) AS total_pay
FROM StaffMember;
-- 8. Group by
-- Find the staff count and average pay for each division.
SELECT
    d.division_name,
    COUNT(e.staff_id) AS staff_count,
    AVG(e.monthly_pay) AS average_pay
FROM Division d
JOIN StaffMember e
    ON d.division_id = e.division_id
GROUP BY d.division_id, d.division_name;
-- 9. Having
-- Show divisions where the average pay is above 71,000.
SELECT
    d.division_name,
    AVG(e.monthly_pay) AS average_pay
FROM Division d
JOIN StaffMember e
    ON d.division_id = e.division_id
GROUP BY d.division_id, d.division_name
HAVING AVG(e.monthly_pay) > 71000;
-- 10. Case expression
-- Put staff members into pay groups.
SELECT
    staff_name,
    monthly_pay,
    CASE
        WHEN monthly_pay >= 79000 THEN 'High Salary'
        WHEN monthly_pay >= 79000 THEN 'Medium Salary'
        ELSE 'Low Salary'
    END AS pay_category
FROM StaffMember;
-- 11. Order by
-- List staff members from the highest pay to the lowest.
SELECT staff_name, monthly_pay
FROM StaffMember
ORDER BY monthly_pay DESC;
-- 12. Join
-- Show each staff member with their division and assignment.
SELECT
    e.staff_name,
    d.division_name,
    p.assignment_name,
    e.monthly_pay
FROM StaffMember e
JOIN Division d
    ON e.division_id = d.division_id
JOIN Assignment p
    ON e.assignment_id = p.assignment_id
ORDER BY d.division_name, e.staff_name;
-- End of the previous section
-- DBMS practical - Experiment 5: views and hierarchy
-- Views, view updates and a recursive CTE
USE EnterpriseDB;
-- 1. Add supervisor_id to the staff table
ALTER TABLE StaffMember
ADD COLUMN supervisor_id INT NULL;

ALTER TABLE StaffMember
ADD CONSTRAINT fk_staff_supervisor
FOREIGN KEY (supervisor_id) REFERENCES StaffMember(staff_id);
-- 2. Set up the staff hierarchy
-- Each division starts with one head.
-- The other staff members report to someone above them.
-- Engineering
UPDATE StaffMember SET supervisor_id = NULL WHERE staff_id = 1;
UPDATE StaffMember SET supervisor_id = 1 WHERE staff_id = 2;
UPDATE StaffMember SET supervisor_id = 2 WHERE staff_id = 3;
UPDATE StaffMember SET supervisor_id = 3 WHERE staff_id = 4;
UPDATE StaffMember SET supervisor_id = 4 WHERE staff_id = 5;
UPDATE StaffMember SET supervisor_id = 5 WHERE staff_id = 6;

-- People Operations
UPDATE StaffMember SET supervisor_id = NULL WHERE staff_id = 7;
UPDATE StaffMember SET supervisor_id = 7 WHERE staff_id = 8;
UPDATE StaffMember SET supervisor_id = 8 WHERE staff_id = 9;
UPDATE StaffMember SET supervisor_id = 9 WHERE staff_id = 10;
UPDATE StaffMember SET supervisor_id = 10 WHERE staff_id = 11;
UPDATE StaffMember SET supervisor_id = 11 WHERE staff_id = 12;

-- Accounts
UPDATE StaffMember SET supervisor_id = NULL WHERE staff_id = 13;
UPDATE StaffMember SET supervisor_id = 13 WHERE staff_id = 14;
UPDATE StaffMember SET supervisor_id = 14 WHERE staff_id = 15;
UPDATE StaffMember SET supervisor_id = 15 WHERE staff_id = 16;
UPDATE StaffMember SET supervisor_id = 16 WHERE staff_id = 17;
UPDATE StaffMember SET supervisor_id = 17 WHERE staff_id = 18;

-- Outreach
UPDATE StaffMember SET supervisor_id = NULL WHERE staff_id = 19;
UPDATE StaffMember SET supervisor_id = 19 WHERE staff_id = 20;
UPDATE StaffMember SET supervisor_id = 20 WHERE staff_id = 21;
UPDATE StaffMember SET supervisor_id = 21 WHERE staff_id = 22;
UPDATE StaffMember SET supervisor_id = 22 WHERE staff_id = 23;
UPDATE StaffMember SET supervisor_id = 23 WHERE staff_id = 24;

-- Logistics
UPDATE StaffMember SET supervisor_id = NULL WHERE staff_id = 25;
UPDATE StaffMember SET supervisor_id = 25 WHERE staff_id = 26;
UPDATE StaffMember SET supervisor_id = 26 WHERE staff_id = 27;
UPDATE StaffMember SET supervisor_id = 27 WHERE staff_id = 28;
UPDATE StaffMember SET supervisor_id = 28 WHERE staff_id = 29;
UPDATE StaffMember SET supervisor_id = 29 WHERE staff_id = 30;
-- 3. Create a division pay summary view
CREATE OR REPLACE VIEW division_pay_summary AS
SELECT
    d.division_id,
    d.division_name,
    COUNT(e.staff_id) AS staff_count,
    AVG(e.monthly_pay) AS average_pay,
    MIN(e.monthly_pay) AS minimum_pay,
    MAX(e.monthly_pay) AS maximum_pay,
    SUM(e.monthly_pay) AS total_pay
FROM Division d
JOIN StaffMember e
    ON d.division_id = e.division_id
GROUP BY d.division_id, d.division_name;


-- Check the division pay summary
SELECT *
FROM division_pay_summary;
-- 4. Create a staff hierarchy view
-- Show each staff member and their immediate supervisor
CREATE OR REPLACE VIEW staff_hierarchy AS
SELECT
    e.staff_id,
    e.staff_name,
    e.division_id,
    d.division_name,
    e.supervisor_id,
    m.staff_name AS supervisor_name,
    e.monthly_pay
FROM StaffMember e
JOIN Division d
    ON e.division_id = d.division_id
LEFT JOIN StaffMember m
    ON e.supervisor_id = m.staff_id;


-- Check the staff hierarchy
SELECT *
FROM staff_hierarchy
ORDER BY division_id, staff_id;
-- 5. Test updating the staff hierarchy view
UPDATE staff_hierarchy
SET monthly_pay = monthly_pay + 1000
WHERE staff_id = 6;


-- Check the updated pay
SELECT
    staff_id,
    staff_name,
    monthly_pay
FROM StaffMember
WHERE staff_id = 6;
-- 6. Test updating the division pay summary view
UPDATE division_pay_summary
SET average_pay = average_pay + 1000
WHERE division_id = 1;
-- 7. Recursive CTE for the supervision chain
-- Start with division heads and follow the supervisor links
WITH RECURSIVE supervision_chain AS (

    -- Starting query
    SELECT
        e.staff_id,
        e.staff_name,
        e.supervisor_id,
        1 AS level,
        CAST(e.staff_name AS CHAR(500)) AS supervision_path
    FROM StaffMember e
    WHERE e.supervisor_id IS NULL

    UNION ALL

    -- Repeat for the next level
    SELECT
        e.staff_id,
        e.staff_name,
        e.supervisor_id,
        rc.level + 1,
        CONCAT(rc.supervision_path, ' -> ', e.staff_name)
    FROM StaffMember e
    JOIN supervision_chain rc
        ON e.supervisor_id = rc.staff_id
)

SELECT
    staff_id,
    staff_name,
    supervisor_id,
    level,
    supervision_path
FROM supervision_chain
ORDER BY supervision_path;
-- End of the previous section
-- DBMS practical - Experiment 6
-- Stored procedure, triggers, error handling and pay audit
USE EnterpriseDB;
-- 1. Create the pay audit table
CREATE TABLE IF NOT EXISTS Staff_Pay_Audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    staff_id INT NOT NULL,
    old_pay DECIMAL(10,2),
    new_pay DECIMAL(10,2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action VARCHAR(30)
);
-- 2. Remove old triggers and the procedure
-- This lets the script be run again during practical work.
DROP TRIGGER IF EXISTS validate_staff_pay;
DROP TRIGGER IF EXISTS validate_staff_pay_update;
DROP TRIGGER IF EXISTS audit_pay_update;

DROP PROCEDURE IF EXISTS transfer_staff;
-- 3. Check pay before inserting a staff member
-- Pay must stay within the allowed range.
DELIMITER //

CREATE TRIGGER validate_staff_pay
BEFORE INSERT ON StaffMember
FOR EACH ROW
BEGIN
    IF NEW.monthly_pay < 35000 OR NEW.monthly_pay > 175000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Pay must be between 35000 and 175000';
    END IF;
END//

DELIMITER ;
-- 4. Check pay before updating a staff member
-- Check the new pay before saving it.
DELIMITER //

CREATE TRIGGER validate_staff_pay_update
BEFORE UPDATE ON StaffMember
FOR EACH ROW
BEGIN
    IF NEW.monthly_pay < 35000 OR NEW.monthly_pay > 175000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Pay must be between 35000 and 175000';
    END IF;
END//

DELIMITER ;
-- 5. Record pay changes
-- Save the old and new pay after an update.
DELIMITER //

CREATE TRIGGER audit_pay_update
AFTER UPDATE ON StaffMember
FOR EACH ROW
BEGIN
    IF OLD.monthly_pay <> NEW.monthly_pay THEN
        INSERT INTO Staff_Pay_Audit
        (
            staff_id,
            old_pay,
            new_pay,
            action
        )
        VALUES
        (
            NEW.staff_id,
            OLD.monthly_pay,
            NEW.monthly_pay,
            'PAY UPDATE'
        );
    END IF;
END//

DELIMITER ;
-- 6. Procedure for moving a staff member
DELIMITER //

CREATE PROCEDURE transfer_staff(
    IN p_staff_id INT,
    IN p_new_division_id INT
)
BEGIN

    DECLARE v_staff_count INT DEFAULT 0;
    DECLARE v_division_count INT DEFAULT 0;
    DECLARE v_old_division_id INT;

    -- If anything fails, undo the transaction.
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Begin the transaction.
    START TRANSACTION;
-- Check whether the staff member exists.
SELECT COUNT(*)
    INTO v_staff_count
    FROM StaffMember
    WHERE staff_id = p_staff_id;

    IF v_staff_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Staff member does not exist';
    END IF;
-- Check whether the division exists.
SELECT COUNT(*)
    INTO v_division_count
    FROM Division
    WHERE division_id = p_new_division_id;

    IF v_division_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Division does not exist';
    END IF;
-- Find the staff member's current division.
SELECT division_id
    INTO v_old_division_id
    FROM StaffMember
    WHERE staff_id = p_staff_id;
-- Check if the staff member is already in the requested division.
IF v_old_division_id = p_new_division_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Staff member is already in this division';
    END IF;
-- Move the staff member.
UPDATE StaffMember
    SET division_id = p_new_division_id
    WHERE staff_id = p_staff_id;


    -- Save the changes.
    COMMIT;

END//

DELIMITER ;
-- 7. Test a successful transfer
-- Move staff member 6 to division 4.
CALL transfer_staff(6, 4);


-- Check the staff member's division.

SELECT
    e.staff_id,
    e.staff_name,
    d.division_name
FROM StaffMember e
JOIN Division d
    ON e.division_id = d.division_id
WHERE e.staff_id = 6;
-- 8. Test an invalid staff ID
-- Expected: Staff member does not exist
CALL transfer_staff(99, 4);
-- 9. Test an invalid division
-- Expected: Division does not exist
CALL transfer_staff(6, 99);
-- 10. Test the same division
-- Staff member 6 is already in division 4.
-- Expected: Staff member is already in this division
CALL transfer_staff(6, 4);
-- 11. Test an invalid pay value
-- Expected result: pay validation error.
UPDATE StaffMember
SET monthly_pay = 25000
WHERE staff_id = 6;
-- 12. Test a valid pay update
-- Expected result: update succeeds.
UPDATE StaffMember
SET monthly_pay = 88000
WHERE staff_id = 6;
-- 13. Display the pay audit log
SELECT
    audit_id,
    staff_id,
    old_pay,
    new_pay,
    changed_at,
    action
FROM Staff_Pay_Audit
ORDER BY audit_id;
-- End of Experiment 6


