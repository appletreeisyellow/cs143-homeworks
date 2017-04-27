# 1(a)
CREATE TABLE Laptop AS
	CHECK weight <= 3;

# 1(b)
CREATE TRIGGER setnull_trigger AFTER INSERT ON Laptop
	REFERENCING NEW ROW AS nrow
	FOR EACH ROW
	WHEN (nrow.weight > 3)
	BEGIN ATOMIC
		SET nrow.weight = NULL WHERE model=nrow.model;
	END;


# 2(a)
CREATE VIEW EmployeeNames(enames) AS
	SELECT ename
	FROM Employees;

CREATE VIEW DepInfo(dept, avgsalary) AS
	SELECT dept, AVG(salary)
	FROM Employees
	GROUP BY dept;

# 2(b)
GRANT SELECT, DELETE
ON EmployeeNames
TO Mike;

GRANT SELECT
ON DepInfo
TO Mike;

# 2(c)
Yes. For example, if Joe wants to find salary of Peter, he can 
delete all tupples in EmployeeNames except Peter. Now DepInfo
only left the salary of Peter. 

# 2(d)
UPDATE DepInfo SET avgsalary = 100 WHERE dept = 'sales'

# 2(e)
GRANT SELECT, UPDATE
ON Employees
TO Joe
WITH GRANT OPTION;


GRANT SELECT, UPDATE
ON EmployeeNames
TO Joe
WITH GRANT OPTION;

No, because I did not grant Joe SELECT permission on DepInfo.

# 2(f)
REVOKE SELECT 
ON EmployeeNames
FROM Joe CASCADE;

Views remain after the executation of REVOKE statement:
EmployeeNames, StaffNames

# 3
Combination of 4 item_name, 3 color, 3 size = 4 * 3 * 3 = 36
The following 13 tuples will be added to the result 
shirt, dark, all
shirt, pastel, all
shirt, white, all
shirt, all, all
dress, dark, all
dress, pastel, all
dress, white, all
dress, all, all
pant, dark, all
pant, pastel, all
pant, white, all
pant, all, all 
all, all, all

Total tuples = 36 + 13 = 49 tuples


# 4

SELECT Outlook, Temperature, Humidity, Wind, PlayTennis, COUNT(*)
FROM table
GROUP BY ROLLUP(Outlook, Temperature, Humidity, Wind, PlayTennis)

Outlook: null, Overcast, Rain, Sunny
Tempeture: null, Cool, Hot, Mild
Humidity: null, High, Normal
Wind: null, Weak, Strong
PlayTennis: null, no, yes

The result of query:

null, null, null, null, null, 14
Overcast, null, null, null, null, 4
Overcast, Cool, null, null, null, 1
Overcast, Cool, Normal, null, null, 1
Overcast, Cool, Normal, Strong, null, 1
Overcast, Cool, Normal, Strong, yes, 1
Overcast, Hot, null, null, null, 2
Overcast, Hot, High, null, null, 1
Overcast, Hot, High, Weak, null, 1
Overcast, Hot, High, Weak, yes, 1
Overcast, Hot, Normal, null, null, 1
Overcast, Hot, Normal, Weak, null, 1
Overcast, Hot, Normal, Weak, yes, 1
Rain, null, null, null, null, 5


# 5
(a) capacity of the disk = 6 surfaces/disk * 10000 tracks/surface * 500 sectors/track * 1024 bytes/sector * 1 KB / 1024 bytes = 30GB/disk
(b) 1/6000 RPM = 0.01 sec/rev
    avg rotational time = 0.01 sec/rev * 0.5 rev = 5 ms
    Assume transfer time = 0.02 ms
    avg time to find random sector = 10 ms + 5 ms + 0.02 ms= 15.2 ms
(c) size of one class = 2 + 5 * 4 + 30 + 20 = 72 bytes
    number of classes in one sector = 1024 / 72 = 14 classes/sector
    number of sector needed for 1000 classes = 1000 / 14 = 72 sectors
(d) time = 10 ms + 5 ms + 72 * 0.02 ms = 16.44 ms
(e) time = 24 * (10 ms + 5 ms + 3 * 0.02 ms) = 361.44 ms
(f) 10 classes are offered every year. Since classes are not clustered by the search key, 
    10 classes are stored randomly. 
    time = 10 * (10 ms + 5 ms + 0.02 ms) = 150.2 ms
    Yes, it is helpful to create a B+tree to run this query







