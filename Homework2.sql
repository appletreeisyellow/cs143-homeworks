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

SELECT person-name
FROM Work
WHERE salary > ALL (	SELECT Work.salary
						FROM Employee JOIN Work ON Employee.person-name = Work.person-name
						WHERE Employee.city IN ('Los Angeles')
					);



SELECT person-name
FROM Work
WHERE EXISTS (	SELECT person-name
				FROM Work
				WHERE salary > (SELECT MAX(Work.salary)
								FROM Employee JOIN Work ON Employee.person-name = Work.person-name
								WHERE Employee.city = 'Los Angeles')
				);


# 2(b)

SELECT DISTINCT manager-name
FROM Manage
WHERE EXISTS (	SELECT	DISTINCT Manage.manager-name
				FROM Manage 
				INNER JOIN Work e ON Manage.person-name = e.person-name
				INNER JOIN Work m ON Manage.manager-name = m.person-name
				WHERE m.salary > e.salary
				); # it these INNER joins correct?

SELECT DISTINCT manager-name
FROM Manage
WHERE manager-name IN (	SELECT DISTINCT manager-name
						FROM (
								SELECT Manage.manager-name AS manager-name, m.salary AS manager-salary, MIN(e.salary) AS min-employ-salary
								FROM Manage 
								INNER JOIN Work e ON Manage.person-name = e.person-name
								INNER JOIN Work m ON Manage.manager-name = m.person-name
								GROUP BY manager-name
							) # Can I do this?
						WHERE manager-salary > min-employ-salary
						);


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
WHERE NOT EXISTS (	SELECT s.name
					FROM MovieStar s
					INNER JOIN MovieExec e ON s.name = e.name
					);

# 4(a)
SELECT AVG(speed)
FROM Desktop;

# 4(b)
SELECT AVG(price)
FROM ComputerProduct
WHERE model IN (SELECT model
				FROM Laptop
				WHERE weight < 2)
;

# 4(c)
SELECT AVG(price)
FROM ComputerProduct
WHERE manufacturer = 'Dell';

# 4(d)
CREATE VIEW ModelSpeed(model, speed) AS
	SELECT model, speed
	FROM Desktop
	UNION
	SELECT model, speed
	FROM Laptop
;

SELECT speed, AVG(speed)
FROM ModelSpeed s 
INNER JOIN ComputerProduct p ON s.model = p.modelCount
GROUP BY speed;

# 4(e)
CREATE VIEW ManuModelCount(manu, modelCount) AS
	SELECT manufacturer, COUNT(model)
	FROM ComputerProduct
	GROUP BY manufacturer
;

SELECT manu
FROM ManuModelCount m
WHERE m.modelCount >= 3;


# 5(a)
INSERT INTO ComputerProduct 
	VALUES ('HP', 1200, 1000);

INSERT INTO Desktop
	VALUES (1200, 1.2, 256, 80);

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
WHERE model IN IBMbelow1000;

# 5(c)
UPDATE Laptop
SET weight = 1 + weight
WHERE model IN (SELECT model
				FROM ComputerProduct
				WHERE manufacturer = 'Gateway');
 
# 6(a)
CREATE VIEW NonCS(sid) AS # the students who takes non-CS classes
	SELECT sid
	FROM Enroll
	WHERE dept <> 'CS'
;

SELECT sid
FROM Enroll
WHERE dept = 'CS' AND NOT IN NonCS;

# 6(b)
CREATE VIEW CScnum(cnum) AS # the course nums of all CS classes
	SELECT cnum
	FROM Enroll
	WHERE dept = 'CS'
;

CREATE VIEW CSsid_cnum(sid, cnum) AS # CS cnum and all the students who take CS classes
	SELECT sid, cnum
	FROM Enroll
	WHERE dept = 'CS'
;

# idea: All Students Who Take CS classes - Students Who Don't take All CS classes
CREATE VIEW StudentsWhoTakeCS AS
	SELECT DISTINCT sid
	FROM CSsid_cnum
;


CREATE VIEW StudentWhoDontTakeAllCS(sid, cnum) AS
	SELECT s.sid, cs.cnum
	FROM StudentsWhoTakeCS s CROSS JOIN CS cs
	EXCEPT
	CSsid_cnum
;

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
	GROUP BY sid
;

CREATE VIEW CScount(sid, count) AS
	SELECT COUNT(DISTINCT cnum)
	FROM Enroll
	WHERE dept = 'CS'
	GROUP BY sid
;

SELECT all.sid
FROM AllClassesCount all INNER JOIN CScount cs ON all.sid = cs.sid
WHERE all.count = cs.count;



# Find the students who are enrolled in all the CS classes 
# idea: find the student who take the same count of CS classes as the count of all CS classes
CREATE VIEW CScount(count) AS # count the number of CS classes offered in this quarter
	SELECT COUNT(DISTINCT cnum)
	FROM Enroll
	WHERE dept = 'CS'
;

CREATE VIEW StudentCScount(sid, count) AS
	SELECT COUNT(DISTINCT cnum)
	FROM Enroll
	WHERE dept = 'CS'
	GROUP BY sid
;

SELECT s.sid
FROM StudentCScount s, CScount c
WHERE s.count = c.count;






