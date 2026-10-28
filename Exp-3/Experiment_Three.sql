-- DBMS practical - Experiment 3
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
(101, 'Network Upgrade', 179000, 1),
(102, 'Data Insights', 225000, 1),
(103, 'Hiring Tracker', 95000, 2),
(104, 'Budget Monitor', 135000, 3),
(105, 'Brand Promotion', 105000, 4),
(106, 'Warehouse Planner', 195000, 5),
(107, 'Customer App', 158000, 1),
(108, 'Wellness Initiative', 79000, 2);


-- 4. Add 30 staff members

INSERT INTO StaffMember
(staff_id, staff_name, monthly_pay, joining_date, division_id, assignment_id)
VALUES
(1, 'Nitin', 71000, '2022-01-10', 1, 101),
(2, 'Harsh', 80000, '2021-03-15', 1, 102),
(3, 'Mohan', 68000, '2023-06-20', 1, 107),
(4, 'Siddharth', 85000, '2020-08-12', 1, 101),
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
(18, 'Tarun', 62000, '2024-01-09', 3, 104),

(19, 'Isha', 63000, '2022-02-25', 4, 105),
(20, 'Mahi', 71000, '2021-06-16', 4, 105),
(21, 'Ankita', 63000, '2023-04-10', 4, 105),
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
    COUNT(*) AS total_staff,
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
        WHEN monthly_pay >= 60000 THEN 'Medium Salary'
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


-- End of Experiment 3

