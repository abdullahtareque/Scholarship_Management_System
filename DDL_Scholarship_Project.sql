USE master
--drop database Scholarship_Project
GO

DECLARE @syspath nvarchar(256);
SET @syspath = (SELECT SUBSTRING(physical_name, 1, CHARINDEX(N'master.mdf', LOWER(physical_name)) - 1)
      FROM master.sys.master_files
      WHERE database_id = 1 AND file_id = 1);
EXECUTE ('CREATE DATABASE Scholarship_Project
ON PRIMARY(NAME = Scholarship_Project_data, FILENAME = ''' + @syspath + 'Scholarship_Project_data.mdf'', SIZE = 30MB, MAXSIZE = Unlimited, FILEGROWTH = 5%)
LOG ON (NAME = Scholarship_Project_log, FILENAME = ''' + @syspath + 'Scholarship_Project_log.ldf'', SIZE = 15MB, MAXSIZE = 200MB, FILEGROWTH = 2MB)'
);
GO

USE Scholarship_Project
GO

------==================================================================================
---                             Create Schema
------==================================================================================
Create Schema sp
GO

------==================================================================================
----                            Create Table
------==================================================================================

USE Scholarship_Project
DROP TABLE IF EXISTS sp.Districts
Create TABLE sp.Districts
(
DistrictID INT PRIMARY KEY IDENTITY,
DistrictName NVARCHAR (50) NOT NULL,
DistrictsCode INT,
);
GO

USE Scholarship_Project
DROP TABLE IF EXISTS sp.School
Create TABLE sp.School
(
SchoolID INT PRIMARY KEY IDENTITY,
SchoolName NVARCHAR (50) NOT NULL,
District varchar(35)
);
GO

USE Scholarship_Project
DROP TABLE IF EXISTS sp.Class
Create TABLE sp.Class
(
ClassID INT PRIMARY KEY IDENTITY,
ClassName NVARCHAR (50) NOT NULL
);
GO

USE Scholarship_Project
DROP TABLE IF EXISTS sp.StudentRegistration
Create TABLE sp.StudentRegistration
(
RegistrationID INT PRIMARY KEY IDENTITY,
StudenFirstName VARCHAR (30) NOT NULL,
StudenLastName varchar(20) NOT NULL,
FathersName Varchar(30),
MothersName Varchar(30),
PsesentAddress nvarchar(60) CONSTRAINT CN_EmployeeAddress DEFAULT ('UNKNOWN'), 
PermanentAddress nvarchar(60) sparse,
MobileNo char(15) NOT NULL CHECK ((MobileNo like '[0][1][0-9][0-9][0-9] [0-9][0-9][0-9] [0-9][0-9][0-9]')),
--------------EmailAddress nvarchar(50) sparse,
DistrictID INT FOREIGN KEY REFERENCES sp.Districts (DistrictID),
SchoolID INT FOREIGN KEY REFERENCES sp.School(SchoolID) ON DELETE CASCADE,
ClassID INT FOREIGN KEY REFERENCES sp.Class(ClassID)
);

GO

USE Scholarship_Project
DROP TABLE IF EXISTS sp.Exam
Create TABLE sp.Exam
(
ExamID INT PRIMARY KEY IDENTITY,
RegistrationID INT FOREIGN KEY REFERENCES sp.StudentRegistration (RegistrationID),
ExamType Varchar (50) NOT NULL,
ClassStanderd varchar (30)
);
GO

DROP TABLE IF EXISTS sp.Result
Create TABLE sp.Result
(
ResultID INT PRIMARY KEY IDENTITY,
ExamID INT FOREIGN KEY REFERENCES sp.Exam(ExamID),
TotalMarks INT
);
GO

DROP TABLE IF EXISTS sp.Conditions
Create TABLE sp.Conditions
(
ConditionID INT PRIMARY KEY IDENTITY,
Catagory varchar (30),
Conditions varchar (30),
price money,
Discription nchar (30)
);
GO

DROP TABLE IF EXISTS sp.Scholarships
Create TABLE sp.Scholarships
(
ScholarshipsID INT IDENTITY,
ScholarshipsName Varchar (50) Not Null,
ResultID INT FOREIGN KEY REFERENCES sp.Result(ResultID),
ConditionID INT FOREIGN KEY REFERENCES sp.Conditions(ConditionID),
);

------==================================================================================
-------                               Alter Table
------==================================================================================

---ADD COLUMN
ALTER table sp.School
ADD SchooCode varchar(30);

Alter Table sp.StudentRegistration
ADD StudentBirthDate date
GO

--DElETE column 
Alter Table sp.School
Alter Column SchoolName Varchar (50);
Go

Alter Table sp.Conditions
Alter Column Discription Varchar (50);
Go

Alter Table sp.School
Drop column SchooCode
Go

------==================================================================================
--                      Index(clustered,non-clustered)
------==================================================================================
---Clustered---
CREATE Clustered Index CI_Scholarships ON sp.Scholarships(ScholarshipsID);
GO

----NonClustered---
CREATE NonClustered Index NCI_Class ON sp.Class(ClassName);
GO

------==================================================================================
--                           View With Encryption
------==================================================================================

CREATE View vw_School
--With Encryption
As
Select SchoolID, SchoolName, District
From sp.School;
GO

------==================================================================================
--                          View with Schemabinding
------==================================================================================
Create View vw_Class
With Schemabinding
As
Select ClassID, ClassName
From sp.Class
GO


------==================================================================================
---                    Scalar Function, Tabular Function
------==================================================================================

--- Scalar Function---
CREATE FUNCTION fn_Conditions()
RETURNS int
AS
BEGIN
	Return(Select SUM(RegistrationID) From sp.StudentRegistration)
END
GO

---- Tabular Function---
CREATE FUNCTION fn_GetByName()
RETURNS TABLE
AS 
RETURN (SELECT * FROM sp.Conditions WHERE ConditionID=1)
GO

------==================================================================================
-----                         Procedure Create (Search By Name)
------==================================================================================
Create PROC sp_SearchName
@Name nvarchar(20)
AS
Select StudenFirstName, StudenLastName 
From sp.StudentRegistration
Where StudenFirstName like @Name +'%'  or StudenLastName like @Name +'%'
GO

EXEC sp_SearchName 'Abdullah'

Select * From sp.StudentRegistration
GO

------==================================================================================
--                CREATE, Insert, Update, Delete By Store Procedure
------==================================================================================
-- Store Procedure For CREATE
DROP PROC IF EXISTS sp_School_1
GO
CREATE PROC sp_School_1
(
	@SchoolID int,
	@SchoolName NVARCHAR (50),
	@District varchar(35)
)
AS
BEGIN
	INSERT INTO sp.School ( SchoolID,SchoolName,District)
	Values(@SchoolID,@SchoolName,@District)
END
GO

------==================================================================================
---  SingleTable Stored Procedure--Insert, Update, Delete=  With IF Exists, And Operator
------==================================================================================

CREATE PROC sp_School_01
	@SchoolID INT,
	@SchoolName NVARCHAR (50),
	@District varchar,
	@message varchar(50) output
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		 IF EXISTS
			(SELECT * FROM sp.School WHERE @SchoolID = SchoolID AND SchoolName=@SchoolName)
			Update sp.School
			SET  District = @District
			WHERE @SchoolID = SchoolID AND SchoolName=@SchoolName;
		ELSE 
			INSERT INTO sp.School (SchoolName)
			VALUES(@SchoolName)
			SET @message = 'Inserted Successfully!!! Wellcome!!!'
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		PRINT 'Something happened wrong!!!'
	END CATCH
END
GO

------==================================================================================
---          Multiple Table Stored Procedure-- Insert, Update, Delete
------==================================================================================

CREATE PROC sp_Scholarship
	@SchoolID INT,
	@SchoolName NVARCHAR (50),
	@District varchar,
	@ClassID INT,
	@ClassName NVARCHAR (50),
	@tablename varchar (20),
	@operationname varchar (20)
 AS
	BEGIN
	--sp.School--
	IF @tablename = 'sp.School' AND @operationname = 'Insert'
	BEGIN
		INSERT INTO  sp.School( SchoolID,SchoolName,District)
		VALUES (@SchoolID,@SchoolName,@District)
	END
	IF @tablename = 'sp.School' AND @operationname = 'Update'
	BEGIN
		Update sp.School SET  SchoolName = @SchoolName , District = @District 
		WHERE @SchoolID = SchoolID 
	END
	IF @tablename = 'sp.School' AND @operationname = 'Delete'
	BEGIN
		DELETE FROM sp.School WHERE @SchoolID = SchoolID 
	END
	--sp.Class--
	IF @tablename = 'sp.Class' AND @operationname = 'Insert'
	BEGIN
		INSERT INTO  sp.Class(ClassName)
		VALUES (@ClassName)
	END
	IF @tablename = 'sp.Class' AND @operationname = 'Update'
	BEGIN
		Update sp.Class SET  ClassName = @ClassName
		WHERE @ClassID = ClassID
	END
	IF @tablename = 'sp.Class' AND @operationname = 'Delete'
	BEGIN
		DELETE FROM sp.Class WHERE @ClassID = ClassID
	END
END
GO

------==================================================================================
---            CREATE for Trigger, After Trigger Insert,Update,delete
------==================================================================================

DROP TABLE IF EXISTS sp.ScholarshipsAudit
CREATE TABLE Tr_ScholarshipsAudit
(
ScholarshipsID Int Not Null,
ScholarshipsName Varchar (50) Not Null,
AuditAction Varchar (100),
AuditActionTiem Datetime 
);
GO

--- After Trigger Insert---
CREATE TRIGGER trg_AfterInsert ON sp.Scholarships
FOR INSERT
AS
DECLARE
	@ScholarshipsID Int,
	@ScholarshipsName Varchar (50),
	@auditaction Varchar (100),
	@auditactiontiem Datetime

	SELECT @ScholarshipsID = i.ScholarshipsID FROM INSERTED i;
	SELECT @ScholarshipsName = i.ConditionID FROM INSERTED i;
	SET @auditaction = 'Inserted Record After Insert Trigger Fired!!!'

INSERT INTO ScholarshipsAudit (ScholarshipsID, ScholarshipsName, AuditAction, AuditActionTiem)
		Values (@ScholarshipsID, @ScholarshipsName, @auditaction, GETDATE())
PRINT 'Inserted Trigger Fired !!!'
GO


--- After Trigger Update---
CREATE TRIGGER trg_AfterUpdate ON sp.Scholarships
After Update
AS
DECLARE
	@ScholarshipsID Int,
	@ScholarshipsName Varchar (50),
	@auditaction Varchar (100),
	@auditactiontiem Datetime

		SELECT @ScholarshipsID = i.ScholarshipsID FROM INSERTED i;
		SELECT @ScholarshipsName = i.ConditionID FROM INSERTED i;
	SET @auditaction = 'Updated Record After Insert Trigger Fired!!!'

INSERT INTO ScholarshipsAudit (ScholarshipsID, ScholarshipsName, AuditAction, AuditActionTiem)
		Values (@ScholarshipsID, @ScholarshipsName, @auditaction, GETDATE())
PRINT 'After Updated Trigger Fired !!!'
GO

--- After Trigger delete---
CREATE TRIGGER trg_AfterDelete ON sp.Scholarships
FOR Delete
AS
DECLARE
	@ScholarshipsID Int,
	@ScholarshipsName Varchar (50),
	@auditaction Varchar (100),
	@auditactiontiem Datetime

		SELECT @ScholarshipsID = i.ScholarshipsID FROM INSERTED i;
		SELECT @ScholarshipsName = i.ConditionID FROM INSERTED i;
		SET @auditaction = 'Deleted Record ------- After Insert Trigger Fired!!!'

INSERT INTO ScholarshipsAudit (ScholarshipsID, ScholarshipsName, AuditAction, AuditActionTiem)
		Values (@ScholarshipsID, @ScholarshipsName, @auditaction, GETDATE())
PRINT 'After Deleted Trigger Fired !!!'
GO

------==================================================================================
---                               Instead of Trigger 
------==================================================================================

USE Scholarship_Project
GO

Create Trigger trg_UpdateDelete on sp.Scholarships
Instead of Update, Delete
AS
Declare @rowcount int
Set @rowcount=@@ROWCOUNT
IF(@rowcount>1)
				BEGIN
				Raiserror('You cannot Update or Delete more than 1 Record',16,1)
				END
Else 
	Print 'Update or Delete Successful'
GO

Insert into sp.Scholarships (ScholarshipsName) Values ('math olympiad');

Delete From sp.Scholarships Where ScholarshipsID=1;
GO
Select * From sp.Scholarships
GO

------==================================================================================
---                      DROP TRIGGER, DISABLE TRIGGER,ENABLE TRIGGER 
------==================================================================================
DROP TRIGGER trg_AfterUpdate
GO

ALTER TABLE sp.Scholarships DISABLE TRIGGER trg_AfterInsert
GO

ALTER TABLE sp.Scholarships ENABLE TRIGGER trg_AfterInsert
GO

------==================================================================================
---                              DROP TABLE, TRUNCATE
------==================================================================================
CREATE TABLE sp.Students
(
StudentID Int Primary Key Identity,
StudentName varchar (20) ,
StudentAdd varchar (20) Null,
);
GO

----DROP TABLE
DROP TABLE sp.Students
GO

----TRUNCATE
TRUNCATE TABLE sp.Students
GO

------==================================================================================
----                            Create Sequence
------==================================================================================
Create Sequence sp.Seq_payment
as int
  START WITH 1
  INCREMENT BY 1
  MINVALUE 1
  MAXVALUE 1000
  NO CYCLE


------==================================================================================
---                              -- Marge--
------==================================================================================
USE Scholarship_Project
CREATE TABLE Student_TB 
(
    StudentID INT PRIMARY KEY,
	StudentName VARCHAR(255) NOT NULL,
    StudentAge Date Default Getdate()
	 

);
GO

CREATE TABLE Student_Temp
(
    StudentID INT PRIMARY KEY IDENTITY,
    StudentName VARCHAR(255) NOT NULL,
    StudentAge Date DEFAULT GETDATE ()
);
GO

MERGE Student_TB AS C
USING Student_Temp AS S
ON (C.StudentID= S.StudentID)
WHEN MATCHED 
   THEN UPDATE SET C.StudentName = S.StudentName, C.StudentAge=S.StudentAge
WHEN NOT MATCHED BY TARGET
   THEN INSERT (StudentID, StudentName, StudentAge) VALUES (s.StudentID, s.StudentName,s.StudentAge)
WHEN NOT MATCHED BY SOURCE
   THEN DELETE;
GO

------==================================================================================
---                               Temporary Table
------==================================================================================

----Local Table
CREATE TABLE #Examcenter
(
ExamcenterID INT PRIMARY KEY IDENTITY,
ExamcenterName varchar (30) NOT NULL
);
GO

----Global Table
CREATE TABLE ##StudentInpo
(
StudentInpoID INT PRIMARY KEY IDENTITY,
StudentName varchar (30) NOT NULL,
StudentInpo datetime
);
GO

Select * from #Examcenter
Go
Select * from ##StudentInpo
Go

------==================================================================================
---                           Temporary Variable Table
------==================================================================================

----Local Temporary Variable Table
DECLARE @Examcenter Table
(
ID int,
UserName VARCHAR (30) NULL,
UserAddresss Varchar (60) NOT NULL
)
go

----GLobal Temporary Variable Table
DECLARE @@StudentInpo Table
(
ID int,
UserName VARCHAR (30) NULL,
UserAddresss Varchar (60) NOT NULL
)
go
