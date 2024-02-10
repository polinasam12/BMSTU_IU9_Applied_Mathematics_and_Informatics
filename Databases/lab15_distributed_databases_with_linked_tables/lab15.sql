
--1. Создать в базах данных пункта 1 задания 13 связанные таблицы.
--2. Создать необходимые элементы базы данных (представления, триггеры), обеспечивающие работу
--с данными связанных таблиц (выборку, вставку, изменение, удаление).
USE master
GO
-----------------------------------------------
IF DB_ID (N'Lab15_1') IS NOT NULL 
DROP DATABASE Lab15_1
GO

CREATE DATABASE Lab15_1
     ON (
        NAME = Lab15_1,
        FILENAME = "C:\SQL\Lab151dat.mdf",
        SIZE = 10,
        MAXSIZE = UNLIMITED,
        FILEGROWTH = 5 %
        ) 
    LOG ON (
        NAME = LibraryLog,
        FILENAME = "C:\SQL\Lab151log.ldf",
        SIZE = 5MB,
        MAXSIZE = 25MB,
        FILEGROWTH = 5MB
        );
GO
----------------------------------------------------
IF DB_ID (N'Lab15_2') IS NOT NULL 
DROP DATABASE Lab15_2
GO

CREATE DATABASE Lab15_2
     ON (
        NAME = Lab15_2,
        FILENAME = "C:\SQL\Lab152dat.mdf",
        SIZE = 10,
        MAXSIZE = UNLIMITED,
        FILEGROWTH = 5 %
        ) 
    LOG ON (
        NAME = LibraryLog,
        FILENAME = "C:\SQL\Lab152log.ldf",
        SIZE = 5MB,
        MAXSIZE = 25MB,
        FILEGROWTH = 5MB
        );
GO
-----------------------------------------------
USE Lab15_1;
GO
if OBJECT_ID(N'Authors') is NOT NULL 
DROP Table Authors;
GO

CREATE TABLE Authors
(
    Author_ID INT NOT NULL, -- IDENTITY(1,1) 
    Surname VARCHAR(20) NOT NULL,
    FirstName VARCHAR(20) NOT NULL,
    Patronymic VARCHAR(20) NULL,
    Date_of_birth DATE NULL
);

INSERT INTO Authors(Author_ID,Surname,FirstName,Patronymic,Date_of_birth)
VALUES
    (1,'Tolstoy','Leo','Nikolayevich','1828-09-09'),
    (2,'Chekhov','Anton','Pavlovich','1860-01-17'),
    (3,'Gogol','Nikolai','Vasilyevich','1809-03-20'),
    (4,'Dickens','Charles',NULL,'1812-02-07'),
    (5,'Shakespeare','William',NULL,'1564-04-23'),
    (6,'Wilde','Oscar',NULL,'1854-10-16'),
    (7,'London','Jack',NULL,'1876-01-12'),
    (8,'Conan Doyle','Arthur',NULL,'1859-05-22')
GO

SELECT * FROM Authors
GO

USE Lab15_2
GO

IF OBJECT_ID (N'Books') IS NOT NULL
DROP TABLE Books;
GO

CREATE TABLE Books
(
    Book_ID INT  NOT NULL,
    Author_ID INT NULL, 
    ISBN VARCHAR(20) NULL,
    Book_name VARCHAR(32) NULL , 
    Publishing_house VARCHAR(20) NULL,
    Year_of_issue INT NULL,
    Number_of_copies INT NULL
);
GO

INSERT INTO Books
    (Book_ID,Author_ID,ISBN,Book_name,Publishing_house,Year_of_issue,Number_of_copies)
VALUES
    (1,1,'978-5-06-002611-5','War and Peace','ABC',2020,4),
    (2,3,'789-5-06-112611-5','Taras Bulba','dsdsdsdsd',2020,12),
    (3,5,'943-5-04-143092-1','Romeo and Juliet','Colleen Hoover',2020,7),
    (4,4,'978-5-04-122092-1','Oliver Twist','Ojsljhd',2019,11),
    (5,6,'433-3-03-676356-1','The Picture of Dorian Gray','Ojsljhd',2020,3),
    (6,2,'234-1-06-102611-5','Vishneviy Sad','asadsdww',1999,4), 
    (7,7,'214-1-26-102611-5','White Fang','asadsdww',1989,3),
    (8,7,'326-3-33-703611-5','Burning Daylight','asdds',2012,10),
    (9,8,'945-5-06-005411-4','Memoirs of Sherlock Holmes','XYZ',2000,1),
    (10,8,'942-5-26-005211-4','The Adventure of Sherlock Holmes','XYZ',2001,2);
GO

SELECT * FROM Books
GO




--2. Создать необходимые элементы базы данных (представления, триггеры), обеспечивающие работу
--с данными связанных таблиц (выборку, вставку, изменение, удаление).
USE Lab15_1
GO

IF OBJECT_ID(N'AuthorsBooksView') IS NOT NULL
    DROP VIEW AuthorsBooksView;
GO

CREATE VIEW AuthorsBooksView
AS
    SELECT b.Book_ID, a.Surname, a.FirstName, a.Patronymic, b.Book_name
    FROM Lab15_1.dbo.Authors a
    INNER JOIN Lab15_2.dbo.Books b
    ON a.Author_ID = b.Author_ID
GO
SELECT * FROM AuthorsBooksView;
GO

USE Lab15_2
GO

IF OBJECT_ID(N'AuthorsBooksView') IS NOT NULL
    DROP VIEW AuthorsBooksView;
GO

CREATE VIEW AuthorsBooksView
AS
    SELECT b.Book_ID, a.Surname, a.FirstName, a.Patronymic, b.Book_name
    FROM Lab15_1.dbo.Authors a
    INNER JOIN Lab15_2.dbo.Books b
    ON a.Author_ID = b.Author_ID
GO
SELECT * FROM AuthorsBooksView;
GO



PRINT '--------- Insert to Authors in Lab15_1 -----------------------------------------------'
GO

USE Lab15_1
GO


IF OBJECT_ID(N'InsertAuthor',N'TR') IS NOT NULL
	DROP TRIGGER InsertAuthor
go

CREATE TRIGGER InsertAuthor
	ON Authors
	INSTEAD OF INSERT 
AS
	BEGIN
		IF EXISTS (SELECT a.Author_ID
                FROM Lab15_1.dbo.Authors AS a, inserted AS i
                WHERE a.FirstName = i.FirstName AND a.Surname = i.Surname)
			BEGIN
				RAISERROR (N'"FirstName" and "Surname" already exist the same author cannot be added', 16, 1);
                ROLLBACK
			END
        ELSE
            INSERT INTO lab15_1.dbo.Authors(Author_ID,Surname, FirstName, Patronymic, Date_of_birth)
            SELECT Author_ID,Surname, FirstName, Patronymic, Date_of_birth FROM inserted
	END
GO


INSERT INTO Authors
VALUES
    (15,'Tolstoy','Leo','Nikolayevich','1828-09-09'),
    (9,'Turgenev','Ivan','Sergeevich','1818-10-28'),
    (10,'Lermontov','Mikhail','Yurevich','1814-10-03')
GO



SELECT * FROM Authors
GO



PRINT '--------- Delete Author in Lab15_1 -----------------------------------------------'
GO

USE Lab15_1
GO


CREATE TRIGGER DeleteAuthor
	ON Authors
	INSTEAD OF DELETE
AS
	BEGIN

		DELETE a FROM Lab15_1.dbo.Authors AS a INNER JOIN deleted AS d ON a.Author_ID = d.Author_ID
        DELETE b FROM Lab15_2.dbo.Books AS b INNER JOIN deleted AS d ON b.Author_ID = d.Author_ID
	END
go

SELECT * FROM Lab15_1.dbo.Authors
GO
SELECT * FROM Lab15_2.dbo.Books
GO


DELETE Lab15_1.dbo.Authors
WHERE Surname = 'Conan Doyle'
GO


SELECT * FROM Lab15_1.dbo.Authors;
SELECT * FROM Lab15_2.dbo.Books;
GO



PRINT '--------- Update Authors in Lab15_1 -----------------------------------------------'
GO

USE Lab15_1
GO
CREATE TRIGGER UpdateAuthor
	ON Authors
	INSTEAD of UPDATE
	AS
	BEGIN

		IF UPDATE(Author_ID)
			RAISERROR('"Author_ID" can not be modified', 16, 1);

		IF UPDATE(Surname)
		BEGIN
			UPDATE Authors
				SET Surname = (SELECT Surname FROM inserted)
				WHERE Authors.Author_ID = (SELECT Author_ID from inserted)
                PRINT '"Surname" has been updated'
		END
        IF UPDATE(Firstname)
		BEGIN
			UPDATE Authors
				SET Firstname = (SELECT Firstname FROM inserted)
				WHERE Authors.Author_ID = (SELECT Author_ID FROM inserted)
                PRINT '"Firstname" was updated'
		END
	END
GO

-- UPDATE Lab15_1.dbo.Authors
-- SET Author_ID = 22
-- WHERE Author_ID = 2
-- GO

UPDATE Lab15_1.dbo.Authors
SET Surname = 'Walter', Firstname = 'Scott'
WHERE Surname = 'Dickens'
GO

SELECT * FROM Lab15_1.dbo.Authors;


PRINT '--------- Insert to Books in Lab15_2 -----------------------------------------------'
GO

USE Lab15_2
GO

IF OBJECT_ID(N'InsertBook',N'TR') IS NOT NULL
	DROP TRIGGER InsertBook
GO

CREATE TRIGGER InsertBook
	ON Books
	INSTEAD OF INSERT 
AS
	BEGIN
		IF EXISTS (SELECT b.Book_ID
					   FROM	Books AS b,
							inserted AS i
					   WHERE b.Book_name = i.Book_name)
			BEGIN
				RAISERROR('"Book_name" already exist', 16, 1);
			END
		ELSE
			IF EXISTS (SELECT b.Book_ID
						FROM Lab15_2.dbo.Books AS b, 
							  inserted AS i
					   WHERE b.Book_ID = i.Book_ID)
				BEGIN
					RAISERROR('"Book_name" already exist', 16, 1);
				END
			ELSE
				IF EXISTS (SELECT Author_ID 
						   FROM inserted 
						   WHERE Author_ID NOT IN 
						   (SELECT Author_ID FROM Lab15_1.dbo.Authors))
				BEGIN
					RAISERROR('Author with this "Author_ID" not exist', 16, 1);
				END
					
			ELSE
				INSERT INTO Books(Book_ID,Author_ID,ISBN,Book_name,Publishing_house,Year_of_issue,Number_of_copies)
				SELECT Book_ID,Author_ID,ISBN,Book_name,Publishing_house,Year_of_issue,Number_of_copies FROM inserted
	END
go



INSERT INTO Books
VALUES
    --(11,1,'978-5-06-002611-5','War and Peace','ABC',2020,4)
    (12,3,'644-4-06-565611-5','Revizor','dsdsdsdsd',2020,12)
    -- (13,5,'943-5-04-143092-1','Romeo and Juliet','Colleen Hoover',2020,7),
    -- (14,4,'978-5-04-122092-1','Oliver Twist','Ojsljhd',2019,11)
GO

SELECT * FROM Books

PRINT '--------- Delete from Books in Lab15_2 -----------------------------------------------'
GO

USE Lab15_2
GO

IF OBJECT_ID(N'DeleteBook',N'TR') IS NOT NULL
	DROP TRIGGER DeleteBook
go

CREATE TRIGGER DeleteBook
	ON Books
	INSTEAD OF DELETE
AS
	BEGIN
		DELETE b FROM Lab15_2.dbo.Books AS b INNER JOIN deleted AS d ON b.book_id = d.book_id
        PRINT 'Deleted from Books'
	END
go

DELETE Lab15_2.dbo.Books
WHERE Book_name = 'Vishneviy Sad'

SELECT * FROM Lab15_2.dbo.Books



PRINT '--------- Update Books in Lab15_2 -----------------------------------------------'
GO

USE Lab15_2
GO

IF OBJECT_ID(N'UpdateBook',N'TR') IS NOT NULL
	DROP TRIGGER UpdateBook
GO

CREATE TRIGGER UpdateBook 
    ON Books
    FOR UPDATE

AS


	IF UPDATE(Book_ID)
		BEGIN
			RAISERROR('You can not change Book_ID', 16, 1)
			ROLLBACK
		END

    IF UPDATE(Author_ID)
		BEGIN
		    RAISERROR('You can not change Author_ID', 16, 1)
			ROLLBACK
		END
GO


UPDATE Lab15_2.dbo.Books SET Book_name = 'XXXXXXXXX' WHERE Book_name = 'Romeo and Juliet'
GO
UPDATE Lab15_2.dbo.Books SET Author_ID = 1 WHERE Author_ID = 5
GO
UPDATE Lab15_2.dbo.Books SET Book_ID = 22 WHERE Book_Name = 'War and Peace'
GO

SELECT * FROM Lab15_1.dbo.Authors
GO

SELECT * FROM Lab15_2.dbo.Books
GO