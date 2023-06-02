--================================================================================================================
--                                  DML_Scholarship_Project
--================================================================================================================
USE Scholarship_Project
GO

select * from sp.Districts
select * from sp.School
select * from sp.Class
select * from sp.StudentRegistration
select * from sp.Exam
select * from sp.Result
select * from sp.Conditions
select * from sp.Scholarships
GO

--================================================================================================================
--                                       INSERT Table
--================================================================================================================

INSERT INTO sp.Districts (DistrictName)
					VALUES ('Dhaka'), ('CTG'), ('Kholna'), ('Borishal'), ('Faridpur'), ('Gazipur'), ('Dhaka'),
					('Mymensingh'),('Rajshahi'),('Rangpur'),('Sylhet'),('Jashore'),('Tangail'),('Rajbari'),
					('Faridpur'),('Gazipur'),('Gopalganj'),('Madaripur'),('Munshiganj'),('Narayanganj'),('Narsingdi');
GO

INSERT INTO sp.School (SchoolName,District)
					VALUES ('Rajuk Uttara Model College','Dhaka'),
							('Ideal School and College','Dhaka'),
							('Monipur High School','Dhaka'),
							('Viqarunnisa Noon School & College','Dhaka'),
							('Rajuk Uttara Model College','Dhaka'),
							('Rajuk Uttara Model College','Dhaka'),
							('Rajuk Uttara Model College','Dhaka'),
							('Rajuk Uttara Model College','Dhaka'),
							('Rajuk Uttara Model College','Dhaka'),
							('Rajuk Uttara Model College','Dhaka'),
							('Rajuk Uttara Model College','Dhaka'),
							('Rajuk Uttara Model College','Dhaka'),
							('Shamsul Haque Khan School and College','Dhaka'),
							('Shamsul Haque Khan School and College','Dhaka'),
							('Shamsul Haque Khan School and College','Dhaka'),
							('Ideal School and College','Dhaka'),
							('Ideal School and College','Dhaka'),
							('Ideal School and College','Dhaka'),
							('Ideal School and College','Dhaka'),
							('Ideal School and College','Dhaka'),
							('Ideal School and College','Dhaka');
GO

INSERT INTO sp.Class (ClassName)
					VALUES ('Class 6'),('Class 7'),('Class 8'),('Class 9'),('Class 10');
GO

INSERT INTO sp.StudentRegistration (StudenFirstName,StudenLastName,FathersName,MothersName,PsesentAddress,PermanentAddress,MobileNo,DistrictID,SchoolID,ClassID)
					VALUES ('MD.','Rahat', 'MD. Faruk','Kawsar' ,'Dhaka Bangladesh','Dhaka Bangladesh','01860 736 356',1,1,1),
							('MD.','Faruk', 'MD. Afjol','Khaleda' ,'Dhaka Bangladesh','Borishal Bangladesh','01960 636 356',2,2,2),
							('MD.','korim', 'MD. Faruk','Saleha' ,'Dhaka Bangladesh','Dhaka Bangladesh','01870 736 656',3,3,3),
							('MD.','Borhan', 'MD. Kamrul','Sadiya' ,'Dhaka Bangladesh','Ctg Bangladesh','01880 736 356',4,4,4)
GO

INSERT INTO sp.Exam (RegistrationID,ExamType,ClassStanderd)
					VALUES (2,'Mathematical Olympiad','Class 6 Standerd'),(3,'Mathematical Olympiad','Class 7 Standerd'),
							(4,'Mathematical Olympiad','Class 8 Standerd'),(5,'Mathematical Olympiad','Class 9 Standerd');
GO

INSERT INTO sp.Result (ExamID,TotalMarks)
					VALUES (1,70), (2,80),(3,92),(4,85);
GO

INSERT INTO sp.Conditions (Catagory,Conditions,  price, Discription)
					VALUES ('A Catagory','If Total Marks >=90',100000,'Best'),
							('B Catagory','If Total Marks >=80 and <90',80000,'Better'),
							('C Catagory','If Total Marks >=70 and <80',50000,'Good');
GO

INSERT INTO sp.Scholarships (ScholarshipsName,ResultID,ConditionID)
					VALUES ('Bangladesh National Math Camp',6,3),
							('Bangladesh National Math Camp',7,4),
							('Bangladesh National Math Camp',8,5);
GO

--================================================================================================================
--                                 Insert with store procedure
--================================================================================================================
EXEC sp_School_1 101,'Chittagong Collegiate School', 'Ice Factory Road, Chittagong'
GO

Select * From sp.School
GO
--================================================================================================================
--                                 Insert with View
--================================================================================================================
--Insert
INSERT INTO vw_Class (ClassName)
							VALUES ('Class 6'),('Class 7'),('Class 8');
GO

SELECT * FROM vw_Class
GO
--================================================================================================================
--                                 Update with View
--================================================================================================================
--Update
UPDATE vw_Class
SET ClassName = 'Class 10' WHERE ClassID=6
GO

--================================================================================================================
--                                 Delete with View
--================================================================================================================
--Delete
DELETE FROM vw_Class WHERE ClassID=6
GO

--================================================================================================================
--                                                  Distinct
--================================================================================================================
SELECT DISTINCT D.DistrictName
FROM sp.Districts D
GO

--================================================================================================================
--                                       Insert Into Copy Data From Another Table
--================================================================================================================

SELECT * 
INTO #tempconditions
FROM sp.Conditions
GO

SELECT * FROM #tempconditions
GO
--================================================================================================================
--                                               Truncate table
--================================================================================================================

TRUNCATE TABLE #tempconditions
GO

--================================================================================================================
--				   Query From Multiple Table With Join/Corralation Name -- 
--================================================================================================================

--================================================================================================================
--										INNER JOIN
--================================================================================================================
SELECT s.StudenFirstName,s.StudenLastName,C.ClassName,sc.SchoolName,s.MobileNo,s.DistrictID,s.PermanentAddress,s.PsesentAddress
FROM sp.StudentRegistration S
INNER JOIN sp.School sc ON sc.SchoolID = s.SchoolID
INNER JOIN sp.Exam E ON E.RegistrationID = s.RegistrationID
INNER JOIN sp.Class C ON C.ClassID = s.ClassID
ORDER BY s.ClassID 
GO

SELECT s.StudenFirstName+ ' ' +s.StudenLastName AS [Student Name],C.ClassName,sc.SchoolName,s.MobileNo,s.DistrictID,s.PermanentAddress,s.PsesentAddress
FROM sp.StudentRegistration S
INNER JOIN sp.School sc ON sc.SchoolID = s.SchoolID
INNER JOIN sp.Exam E ON E.RegistrationID = s.RegistrationID
INNER JOIN sp.Class C ON C.ClassID = s.ClassID
ORDER BY s.ClassID 
GO

--================================================================================================================
--											LEFT JOIN
--================================================================================================================
SELECT *
FROM sp.StudentRegistration St
LEFT JOIN sp.School S ON st.SchoolID = S.SchoolID
ORDER BY s.SchoolID
GO

--================================================================================================================
--											RIGHT JOIN
--================================================================================================================
SELECT S.SchoolName
FROM sp.StudentRegistration SR
RIGHT JOIN sp.School S ON SR.SchoolID = S.SchoolID
ORDER BY s.SchoolID
GO

--================================================================================================================
--											Full JOIN
--================================================================================================================
SELECT *
FROM sp.Exam E
Full Outer Join sp.Result R
On E.ExamID = R.ExamID
GO

--================================================================================================================
--											Cross JOIN
--================================================================================================================

SELECT  *
FROM sp.Exam E
Cross Join sp.Result R
GO

--================================================================================================================
--											Self JOIN
--================================================================================================================
SELECT DISTINCT St1.StudenLastName, St1.SchoolID
FROM sp.StudentRegistration St1
Join sp.StudentRegistration St2
On St1.ClassID = St1.ClassID
GO

--================================================================================================================
---                Query  With Basic Six Clause (SELECT/FROM/WHERE/GROUP BY/HAVING/ORDER BY),
--                         Arithmetic Operators and Comparison Operators etc  
--================================================================================================================
SELECT c.ClassName ,COUNT (st.SchoolID) AS [TotalStudent]
FROM sp.StudentRegistration St 
join sp.Class C on c.ClassID = st.ClassID
WHERE NOT St.ClassID  BETWEEN 10 AND 5      --Between, AND
GROUP BY St.ClassID
HAVING COUNT (st.SchoolID) <= 2 --- Or <>/</>/=
GO

--Select Query  with AND , OR
-----------------------------
SELECT *
FROM sp.StudentRegistration St
Join Sp.School S
On S.SchoolID = St.SchoolID
WHERE St.ClassID >9  OR St.ClassID <3  AND S.SchoolID <5
GO


SELECT S.SchoolName, COUNT(st.RegistrationID) AS [TotalStudent] 
FROM sp.StudentRegistration St
Join sp.School s on st.SchoolID = s.SchoolID
WHERE s.SchoolName like ('[a-z]%')      ------------------====  like
GROUP BY S.SchoolName
HAVING COUNT(st.RegistrationID)> 0
ORDER BY S.SchoolName ASC
GO

--================================================================================================================
--=====                                      OFFSET, FETCH
--================================================================================================================ 
SELECT *
FROM sp.Districts 
WHERE DistrictID <> 0
ORDER BY DistrictID ASC
	OFFSET 1 ROWS
	FETCH NEXT 3 ROWS ONLY; --===== OFFSET, FETCH
GO

--================================================================================================================
--                             Top Clause with TIES
--================================================================================================================

SELECT TOP 10 WIth TIES SchoolID , SchoolName,District -- With TIES
FROM sp.School
WHERE District Is NOT Null -- OR IS NULL
ORDER BY SchoolID DESC
GO

--================================================================================================================
--                              Top Clause with Percent
--================================================================================================================

SELECT TOP 10 Percent SchoolID , SchoolName,District --Top Clause with Percent
FROM sp.School
WHERE District Is NOT Null -- OR IS NULL
ORDER BY SchoolID DESC
GO

--================================================================================================================
--											CAST,CONVERT,TRY_CONVERT
--================================================================================================================

SELECT 'Today :' + CAST(GETDATE() AS VARCHAR)
SELECT 'Today :' + CONVERT(VARCHAR, GETDATE(),1)  AS VARCHARDATE_1
SELECT 'Today :' + TRY_CONVERT (VARCHAR, GETDATE(), 7) AS VARCHARDATE_07
SELECT 'Today :' + TRY_CONVERT (VARCHAR, GETDATE(), 10) AS VARCHARDATE_10
SELECT 'Today :' + TRY_CONVERT (VARCHAR, GETDATE(), 12) AS VARCHARDATE_12
GO


Select DATEDIFF (yy, CAST('10/12/1990' as datetime), GETDATE()) As Years,
DATEDIFF (MM, CAST('10/12/1990' as datetime), GETDATE()) As Months,
DATEDIFF (DD, CAST('10/12/1990' as datetime), GETDATE ()) As Days
GO

--================================================================================================================
--									   DATE/TIME Function
--================================================================================================================

-- DATE/TIME Function- 
SELECT DATEDIFF(yy, CAST('02/09/2020' AS Datetime), GETDATE()) AS YEARS
SELECT DATEDIFF(MM, CAST('01/09/2021' AS Datetime), GETDATE()) %12 AS Months
SELECT DATEDIFF(DD, CAST('02/09/2021' AS Datetime), GETDATE())%30 AS YEARS
GO

--Isdate
SELECT ISDATE('2030-10-21')
--Datepart
SELECT DATEPART(MONTH,'2030-07-21')
--Datename
SELECT DATENAME(MONTH,'2030-01-21')
--Sysdatetime
SELECT Sysdatetime()
--UTC
SELECT GETUTCDATE()
--Datediff
SELECT DATEDIFF (YEAR, '2015-12-01', '2016-09-30')
GO

 --================================================================================================================
--								           Numaric Function
--================================================================================================================

SELECT FLOOR(price) AS [FLOOR], price 
from sp.Conditions

SELECT CEILING (price) AS CEILING, price 
from sp.Conditions

DECLARE @price money = 25.49
SELECT FLOOR(@price) AS FLOORRESULT, ROUND(@price,-1) AS ROUNDRESULT
GO

DECLARE @price decimal (10,2)
SET @price = 15.755
SELECT ROUND(@price,1)		
SELECT ROUND(@price,-1)		
SELECT ROUND(@price,2)		
SELECT ROUND(@price,-2)		
SELECT ROUND(@price,3)		
SELECT ROUND(@price,-3)		
SELECT CEILING(@price)		
SELECT FLOOR(@price)
GO

--================================================================================================================
--									        Union
--================================================================================================================
--Union
		SELECT S.SchoolName
		FROM sp.School S
		WHERE s.SchoolID < 5 
UNION
		SELECT ClassName 
		FROM sp.Class C

--UNION ALL
	 SELECT S.SchoolName
			FROM sp.School S
			WHERE s.SchoolID < 5 
UNION ALL
			SELECT ClassName 
			FROM sp.Class C
GO

--================================================================================================================
--                                         Sub Query
--================================================================================================================

SELECT S.ClassID ,C.ClassName
FROM sp.StudentRegistration S
JOIN sp.Class C ON S.ClassID=C.ClassID
WHERE C.ClassID> ALL
(SELECT C.ClassID FROM sp.Class WHERE ClassID<0);
GO

--================================================================================================================
--                                     Common Table Expression (CTE)
--================================================================================================================
WITH cte_Cass  
AS (SELECT * FROM sp.Scholarships S WHERE s.ScholarshipsName  = 'Bangladesh National Math Camp')  
SELECT s.ConditionID, s.ResultID, s.ScholarshipsID, s.ScholarshipsName FROM sp.Scholarships s;  
GO

--================================================================================================================
-----                                           CUBE
--================================================================================================================

SELECT ClassID, COUNT(SchoolID) AS TotalStudent 
FROM sp.StudentRegistration
GROUP BY ClassID WITH CUBE
GO

--================================================================================================================
--                                            Rollup
--================================================================================================================
SELECT ClassID, COUNT(SchoolID) AS TotalSchool 
FROM sp.StudentRegistration
GROUP BY ClassID WITH Rollup
GO

--================================================================================================================
--                                         Grouping sets
--================================================================================================================

SELECT SchoolID, COUNT(ClassID) AS TotalClass
FROM sp.StudentRegistration
GROUP BY GROUPING SETS (SchoolID,ClassID)
GO

--================================================================================================================
--                                           Select Query with IN 
--================================================================================================================
SELECT * 
FROM sp.School
WHERE [SchoolName] IN ('Rajuk Uttara Model College')
GO

--================================================================================================================
--                                     Select Query with NOT IN 
--================================================================================================================
SELECT * 
FROM sp.School
WHERE [SchoolName] NOT IN ('Rajuk Uttara Model College')
GO

--================================================================================================================
--                                                  IIF
--================================================================================================================

SELECT C.Catagory, c.price, IIF(c.price<100000, '   ', 'A Catagory') AS Price
FROM sp.Conditions C;
GO

--================================================================================================================
--                                                 Choose
--================================================================================================================

SELECT C.Conditions, c.price,
CHOOSE(2, 'A Catagory', 'B Catagory', 'C Catagory') AS Catagory
FROM sp.Conditions C
WHERE c.price = 80000.00
GO

--================================================================================================================
--                                         Aggregate functions
--================================================================================================================

SELECT COUNT(C.ConditionID) Payments, SUM(C.price) TotalAmount, AVG(C.price) [AVG]
FROM sp.Conditions C
GO

SELECT COUNT(*) Classes
FROM sp.Class
GO

SELECT MIN(c.price) [Min Amount]
FROM sp.Conditions C
GO

SELECT MAX(c.price) [Max Amount]
FROM sp.Conditions C
GO

--================================================================================================================
--                                        Mathematical Operator
--================================================================================================================

SELECT 100+2 as [Sum]
GO
SELECT 104-2 as [Substraction]
GO
SELECT 100*3 as [Multiplication]
GO
SELECT 100/2 as [Divide]
GO
SELECT 100%3 as [Remainder]
GO

--================================================================================================================
--                                       All, ANY, Exists
--================================================================================================================

----All
SELECT S.ClassID ,C.ClassName
FROM sp.StudentRegistration S
JOIN sp.Class C ON S.ClassID=C.ClassID
WHERE C.ClassID> ALL
	(SELECT C.ClassID FROM sp.Class WHERE ClassID<0);
GO
----ANY
SELECT S.ClassID ,C.ClassName
FROM sp.StudentRegistration S
JOIN sp.Class C ON S.ClassID=C.ClassID
WHERE C.ClassID< ANY
	(SELECT C.ClassID FROM sp.Class WHERE ClassID<5);
GO

--Exists
SELECT *
FROM sp.School SC
WHERE NOT EXISTS
 (SELECT * FROM sp.StudentRegistration S WHERE S.SchoolID =SC.SchoolID);
GO

--================================================================================================================
--                                      Using the Wildcard & Like
--================================================================================================================
SELECT * 
FROM sp.School
WHERE SchoolName LIKE 'R%'
GO

SELECT *
FROM sp.School
WHERE SchoolName LIKE '%Id%';
GO

--================================================================================================================
--                                             While Loop
--================================================================================================================

DECLARE @x int
SET @x=5
WHILE @x<=10
BEGIN
		PRINT 'Value : ' + CAST(@x AS varchar)
		SET @x=@x+1
END
GO