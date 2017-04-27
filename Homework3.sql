# 1(a)
CREATE TABLE Laptop AS
	CHECK weight <= 3;

# 1(b)
CREATE TRIGGER setnull_trigger BEFORE INSERT ON Laptop
	REFERENCING NEW ROW AS nrow
	FOR EACH ROW
	WHEN (nrow.weight > 3)
	BEGIN ATOMIC
		SET nrow.weight = NULL;
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
CREATE ROLE secretary;
GRANT secretary TO Mike;

GRANT SELECT
ON EmployeeNames
TO secretary;

GRANT SELECT
ON DepInfo
TO secretary;

GRANT DELETE 
ON EmployeeNames # TODO: authorize secretary to fire people from which table?
TO secretary;

# 2(c)
Yes, my answer to the previous question ensure this.
My secretary cannot find out salaries of some individuals. 
He can only find the average salary of a department.

# 2(d)
CREATE ROLE boss
GRANT boss to Joe;

GRANT UPDATE, INSERT, DELETE
ON Employees
TO boss
WITH GRANT OPTION;


GRANT UPDATE, INSERT, DELETE
ON EmployeeNames
TO boss
WITH GRANT OPTION;

Yes, Joe can read the DeptInfo view.



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

null, null, null, null, null, 14
Overcast, null, null, null, null, 4
Overcast, Cool, null, null, null, 1
Overcast, Cool, High, null, null, 0
Overcast, Cool, High, Weak, null, 0
Overcast, Cool, High, Weak, no, 0
Overcast, Cool, High, Weak, yes, 0
Overcast, Cool, High, Strong, null, 0
Overcast, Cool, High, Strong, no, 0
Overcast, Cool, High, Strong, yes, 0
Overcast, Cool, Normal, null, null, 1
Overcast, Cool, Normal, Weak, null, 0
Overcast, Cool, Normal, Weak, no, 0
Overcast, Cool, Normal, Weak, yes, 0
Overcast, Cool, Normal, Strong, null, 1
Overcast, Cool, Normal, Strong, no, 0
Overcast, Cool, Normal, Strong, yes, 1
Overcast, Hot, null, null, null, 2
Overcast, Hot, High, null, null, 1
Overcast, Hot, High, Weak, null, 1
Overcast, Hot, High, Weak, no, 0
Overcast, Hot, High, Weak, yes, 1
Overcast, Hot, High, Strong, null, 0
Overcast, Hot, High, Strong, no, 0
Overcast, Hot, High, Strong, yes, 0
Overcast, Hot, Normal, null, null, 1
Overcast, Hot, Normal, Weak, null, 1
Overcast, Hot, Normal, Weak, no, 0
Overcast, Hot, Normal, Weak, yes, 1
Overcast, Hot, Normal, Strong, null, 0
Overcast, Hot, Normal, Strong, no, 0
Overcast, Hot, Normal, Strong, yes, 0

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










