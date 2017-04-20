# 1(a)
SELECT person-name
FROM Work
WHERE salary < 20000;

# 1(b)
 π person-name (ϑ salary<20000 (Work))

# 1(c)
# Not the same. In the result of (a), a person's name may occure
# more than once. In the result of (b), every person's is unique.


# 2(a)
# use EXIST
SELECT person-name
FROM Work
WHERE EXISTS (	
	SELECT person-name
	FROM Work
	GROUP BY person-name
	HAVING SUM(salary) > (	
		SELECT SUM(w.salary)
		FROM Work w, Employee e 
		WHERE e.person-name = w.person-name
		AND e.city = 'Los Angeles'
		GROUP BY w.person-name
	)
);

# use IN
SELECT person-name
FROM Work
GROUP BY person-name
HAVING SUM(salary) > ALL (	
	SELECT SUM(w.salary)
	FROM Work w, Employee e 
	WHERE e.person-name = w.person-name
	AND e.city IN ('Los Angeles')
	GROUP BY w.person-name
);





# 2(b)
# use EXIST
SELECT DISTINCT manager-name
FROM Manage m1
WHERE EXISTS (	
	SELECT person-name
	FROM Manage m2
	WHERE m1.manager-name = m2.manager-name 
	AND (	
		SELECT SUM(salary) # manager salary 
		FROM Work w
		WHERE w.person-name = m2.manager-name 
		GROUP BY m2.person-name ) 
	> (
		SELECT SUM(salary) # employee salary
		FROM Work w 
		WHERE w.person-name = m2.person-name 
		GROUP BY m2.person-name
	)
);

# use IN
CREATE VIEW ManagerEmployeeSalary(m-name, e-name, e-salary) AS 
	SELECT m.manager-name, m.person-name, e.salary
	FROM Manage m, Work e
	WHERE m.person-name = e.person-name
;

CREATE VIEW ManagerMinEmployeeSalary(m-name, e-minSalary) AS 
# e-minSalary is the minimum salary among all the employee of one manager
	SELECT m-name, MIN(e-salary)
	FROM ManagerEmployeeSalary
	GROUP BY m-name
;

SELECT DISTINCT manager-name
FROM Manage m, Work w, ManagerMinEmployeeSalary me
WHERE m.manager-name = w.person-name 
AND M.manager-name = me.manager-name
AND w.salary > me.e-minSalary



# 3(a) i 
# using INTERSECT
SELECT name, address
FROM MovieStar
WHERE gender = 'F'

INTERSECT

SELECT name, address
FROM MovieExec
WHERE netWorth > 1000000;


# 3(a) ii
# without useing INTERSECT
SELECT name, address
FROM MovieStar s
INNER JOIN MovieExec e ON s.name = e.name
WHERE s.gender = 'F' AND e.netWorth > 1000000;



# 3(b) i
# using EXCEPT
SELECT name
FROM MovieStar

EXCEPT

SELECT name
FROM MovieExec;


# 3(b) ii
# without using EXCEPT

SELECT name
FROM MovieStar
WHERE NOT EXISTS (	
	SELECT s.name
	FROM MovieStar s
	INNER JOIN MovieExec e ON s.name = e.name
);

# 4(a)
SELECT AVG(speed)
FROM Desktop;

# 4(b)
SELECT AVG(price)
FROM ComputerProduct
WHERE model IN (
	SELECT model
	FROM Laptop
	WHERE weight < 2)
;

# 4(c)
SELECT AVG(price)
FROM ComputerProduct
WHERE manufacturer = 'Dell';

# 4(d)
SELECT AVG(c.price)
FROM Laptop l, ComputerProduct c
WHERE l.model = c.model
GROUP BY l.speed

# 4(e)
SELECT manufacturer
FROM ComputerProduct
GROUP BY manufacturer
HAVING COUNT(model) >= 3;

# 5(a)
INSERT INTO ComputerProduct 
	VALUES ('HP', 1200, 1000);

INSERT INTO Desktop
	VALUES (1200, '1.2GHz', '256MB', '80GB');

# 5(b)
CREATE VIEW IBMbelow1000(model) AS 
# the models that are from IBM and price below 1000
	SELECT model
	FROM ComputerProduct
	WHERE manufacturer = 'IBM' AND price < 1000
;

DELETE FROM Desktop
WHERE model IN IBMbelow1000;

DELETE FROM ComputerProduct
WHERE model IN IBMbelow1000 AND 
model NOT IN (	
	SELECT model
	FROM Laptop
);

# 5(c)
UPDATE Laptop
SET weight = 1 + weight
WHERE model IN (
	SELECT model
	FROM ComputerProduct
	WHERE manufacturer = 'Gateway'
);
 
# 6(a)
CREATE VIEW NonCS(sid) AS # the students who takes non-CS classes
	SELECT sid
	FROM Enroll
	WHERE dept <> 'CS';

SELECT sid
FROM Enroll
WHERE dept = 'CS' AND NOT IN NonCS;

# 6(b)
CREATE VIEW CScnum(cnum) AS # the course nums of all CS classes
	SELECT cnum
	FROM Enroll
	WHERE dept = 'CS';

CREATE VIEW CSsid_cnum(sid, cnum) AS # CS cnum and all the students who take CS classes
	SELECT sid, cnum
	FROM Enroll
	WHERE dept = 'CS';

# idea: All Students Who Take CS classes - Students Who Don't take All CS classes
CREATE VIEW StudentsWhoTakeCS AS
	SELECT DISTINCT sid
	FROM CSsid_cnum;


CREATE VIEW StudentWhoDontTakeAllCS(sid, cnum) AS
	SELECT s.sid, cs.cnum
	FROM StudentsWhoTakeCS s CROSS JOIN CS cs
	EXCEPT
	CSsid_cnum;

SELECT DISTINCT sid
FROM StudentsWhoTakeCS
EXCEPT
SELECT DISTINCT sid
FROM StudentWhoDontTakeAllCS;

# 6(c)

# Find the student who are only enrolled in the CS classes
# idea: compare the count of the student's all classes and CS classes, 
#       if the counts are the same, means this student only enrolled in CS classes
CREATE VIEW AllClassesCount(sid, count) AS
	SELECT COUNT(DISTINCT cnum)
	FROM Enroll
	GROUP BY sid;

CREATE VIEW CScount(sid, count) AS
	SELECT COUNT(DISTINCT cnum)
	FROM Enroll
	WHERE dept = 'CS'
	GROUP BY sid;

SELECT all.sid
FROM AllClassesCount all INNER JOIN CScount cs ON all.sid = cs.sid
WHERE all.count = cs.count;



# Find the students who are enrolled in all the CS classes 
# idea: find the student who take the same count of CS classes as the count of all CS classes
CREATE VIEW CScount(count) AS # count the number of CS classes offered in this quarter
	SELECT COUNT(DISTINCT cnum)
	FROM Enroll
	WHERE dept = 'CS';

CREATE VIEW StudentCScount(sid, count) AS
	SELECT COUNT(DISTINCT cnum)
	FROM Enroll
	WHERE dept = 'CS'
	GROUP BY sid;

SELECT s.sid
FROM StudentCScount s, CScount c
WHERE s.count = c.count;






