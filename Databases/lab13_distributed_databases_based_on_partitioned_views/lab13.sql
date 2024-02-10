use master
go

-- 1.Создать две базы данных на одном экземпляре СУБД SQL Server 2012.

DROP DATABASE IF EXISTS Lab13_1
GO
DROP DATABASE IF EXISTS Lab13_2
GO
create database Lab13_1 on (
        NAME = Lab13_1_Samokhvalova,
        FILENAME = 'C:\SQL\Lab13_1_Samokhvalova.mdf',
        SIZE = 10,
        MAXSIZE = 30,
        FILEGROWTH = 5
    ) log on (
        NAME = Lab13_1log,
        FILENAME = 'C:\SQL\Lab13_1log_Samokhvalova.ldf',
        SIZE = 5,
        MAXSIZE = 20,
        FILEGROWTH = 5
    );
go
create database Lab13_2 on (
        NAME = Lab13_2_Samokhvalova,
        FILENAME = 'C:\SQL\Lab13_2_Samokhvalova.mdf',
        SIZE = 10,
        MAXSIZE = 30,
        FILEGROWTH = 5
    ) log on (
        NAME = Lab13_2log,
        FILENAME = 'C:\SQL\Lab13_2log_Samokhvalova.ldf',
        SIZE = 5,
        MAXSIZE = 20,
        FILEGROWTH = 5
    );
go

-- 2.Создать в базах данных п.1. горизонтально фрагментированные таблицы.

USE Lab13_1
GO
DROP TABLE IF EXISTS Books
GO
CREATE TABLE Books
(
    Book_ID INT NOT NULL Primary KEY CHECK (Book_ID <= 10),
    Author_ID INT NULL,
    ISBN VARCHAR(20) NULL,
    Book_name VARCHAR(32) NULL,
    Publishing_house VARCHAR(20) NULL,
    Year_of_issue INT NULL,
    Number_of_copies INT NULL,
);
GO

INSERT INTO Books
    VALUES  
        (1,1,'978-5-06-002611-5','War and Peace','ABC',2020,3),
        (2,3,'789-5-06-112611-5','Taras Bulba','dsdsdsdsd',2020,4),
        (3,5,'943-5-04-143092-1','Romeo and Juliet','Colleen Hoover',2020,9)
GO

SELECT * FROM Books
GO

------------------------------------------------------
USE Lab13_2
GO
DROP TABLE IF EXISTS Books
GO
CREATE TABLE Books
(
    Book_ID INT NOT NULL Primary KEY CHECK (Book_ID > 10),
    Author_ID INT NULL,
    ISBN VARCHAR(20) NULL,
    Book_name VARCHAR(32) NULL,
    Publishing_house VARCHAR(20) NULL,
    Year_of_issue INT NULL,
    Number_of_copies INT NULL,
);
GO

INSERT INTO Books
    VALUES  
        (11,4,'978-5-04-122092-1','Oliver Twist','Ojsljhd',2019,14),
        (12,6,'433-3-03-676356-1','The Picture of Dorian Gray','Ojsljhd',2020,10),
        (13,2,'234-1-06-102611-5','Vishneviy Sad','asadsdww',1999,7)
GO

SELECT * FROM Books
GO


--3. Создать секционированные представления, обеспечивающие работу с данными таблиц
--(выборку, вставку, изменение, удаление).


PRINT '--- Lab13_1 BookView ---'
USE Lab13_1;
GO

IF OBJECT_ID(N'BookView') IS NOT NULL
    DROP VIEW BooksView;
GO

CREATE VIEW BooksView
AS
    SELECT * FROM Lab13_1.dbo.Books
    UNION ALL
    SELECT * FROM Lab13_2.dbo.Books
GO
SELECT * FROM BooksView;
GO



PRINT '--- Lab13_2 BookView ---'
USE Lab13_2;
GO

IF OBJECT_ID(N'BookView') IS NOT NULL
    DROP VIEW BooksView;
GO

CREATE VIEW BooksView
AS
    SELECT * FROM lab13_1.dbo.Books
    UNION ALL
    SELECT * FROM lab13_2.dbo.Books
GO
SELECT * FROM BooksView;
GO

----------------------------------------------------------------------

PRINT '-------------------------------------------------------------------------------'
PRINT '----------- INSERT ------------------------------------------------------------'
PRINT '-------------------------------------------------------------------------------'
INSERT INTO Lab13_1.dbo.BooksView 
    VALUES
        (4,7,'214-1-26-102611-5','White Fang','asadsdww',1989,14),
        (5,7,'326-3-33-703611-5','Burning Daylight','asdds',2012,4)
GO

INSERT INTO Lab13_2.dbo.BooksView 
    VALUES
        (14,9,'945-5-06-005411-4','Memoirs of Sherlock Holmes','XYZ',2000,5),
        (15,9,'942-5-26-005211-4','The Adventure of Sherlock Holmes','XYZ',2001,7);
GO

SELECT * FROM BooksView ;
GO
PRINT '-------------------------------------------------------------------------------'
PRINT '----------- UPDATE ------------------------------------------------------------'
PRINT '-------------------------------------------------------------------------------'
UPDATE BooksView
    SET Book_name = 'AAAAAAAAAAA'
    WHERE Book_ID = 3
GO
SELECT * FROM BooksView ;
GO
PRINT '-------------------------------------------------------------------------------'
PRINT '----------- DELETE ------------------------------------------------------------'
PRINT '-------------------------------------------------------------------------------'
DELETE FROM BooksView
WHERE Book_ID = 1
GO
SELECT * FROM BooksView;
GO
