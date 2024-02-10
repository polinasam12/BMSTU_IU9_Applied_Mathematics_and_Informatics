USE master;
GO
IF DB_ID (N'Library') IS NOT NULL 
DROP DATABASE Library;
GO

---- создадим базу данных Library ------------------------------
CREATE DATABASE Library
     ON (
        NAME = LibraryData,
        FILENAME = "C:\SQL\Librarydat.mdf",
        SIZE = 10,
        MAXSIZE = UNLIMITED,
        FILEGROWTH = 5 %
        ) 
    LOG ON (
        NAME = LibraryLog,
        FILENAME = "C:\SQL\Librarylog.ldf",
        SIZE = 5MB,
        MAXSIZE = 25MB,
        FILEGROWTH = 5MB
        );
GO

-- Создаем таблицу Authors -----------------------------------------------------------------------------
USE Library;
GO
if OBJECT_ID(N'Authors') is NOT NULL 
DROP Table Authors;
GO

CREATE TABLE Authors
(
    Author_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,  -- автоинкрементный первичный ключ
    Surname VARCHAR(20) NOT NULL,
    Firstname VARCHAR(20) NOT NULL,
    Patronymic VARCHAR(20) NULL,
    Date_of_birth DATE
);



INSERT INTO Authors
    (
    Surname,
    Firstname,
    Patronymic,
    Date_of_birth
    )
VALUES
    (
        'Tolstoy',
        'Leo',
        'Nikolayevich',
        '1828-09-09'
    ),
    (
        'Chekhov',
        'Anton',
        'Pavlovich',
        '1860-01-17'
    ),
    (
        'Gogol',
        'Nikolai',
        'Vasilyevich',
        '1809-03-20'
    ),
    (
        'Dickens',
        'Charles',
        NULL,
        '1812-02-07'
    ),
    (
        'Shakespeare',
        'William',
        NULL,
        '1564-04-23'
    ),
    (
        'Wilde',
        'Oscar',
        NULL,
        '1854-10-16'
    ),
    (
        'London',
        'Jack',
        NULL,
        '1876-01-12'
    ),
    (
        'Conan Doyle',
        'Arthur',
        NULL,
        '1859-05-22'
    )
GO

SELECT * FROM Authors;
GO


USE Library;
GO
if OBJECT_ID(N'Book') is NOT NULL 
DROP Table Book;
GO

CREATE TABLE Book
(
    Book_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,  -- автоинкрементный первичный ключ
    Author_ID INT NULL DEFAULT (1000),
    ISBN VARCHAR(20) NOT NULL,
    Book_name VARCHAR(32) UNIQUE NOT NULL,  -- уникльный ключ
    Publishing_house VARCHAR(20) NOT NULL,
    Year_of_issue INT NOT NULL DEFAULT 1970,
    -- Number_of_copies INT NOT NULL CHECK (Number_of_copies >= 1), --Проверка CHECK
    Number_of_copies INT NOT NULL,
    Registration_Date DATE NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Autors_Book FOREIGN KEY (Author_ID) REFERENCES Authors (Author_ID) 
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT CHK_Number_of_copies CHECK (Number_of_copies > 0), -- ограничение CHECK

)
GO

INSERT INTO Book
    (
    Author_ID,
    ISBN,
    Book_name,
    Publishing_house,
    Year_of_issue,
    Number_of_copies
    )
VALUES
    (
        1,
        '978-5-06-002611-5',
        'War and Peace',
        'ABC',
        2020,
        1
    ),
    (
        3,
        '789-5-06-112611-5',
        'Taras Bulba',
        'dsdsdsdsd',
        2020,
        20
    ),
    (
        5,
        '943-5-04-143092-1',
        'Romeo and Juliet',
        'Colleen Hoover',
        2020,
        20
    ),
    (
        4,
        '978-5-04-122092-1',
        'Oliver Twist',
        'Ojsljhd',
        2019,
        20
    ),
    (
        6,
        '433-3-03-676356-1',
        'The Picture of Dorian Gray',
        'Ojsljhd',
        1890,
        20
    ),
    (
        2,
        '234-1-06-102611-5',
        'Vishneviy Sad',
        'asadsdww',
        1999,
        20
    ), 
    (
        7,
        '214-1-26-102611-5',
        'White Fang',
        'asadsdww',
        1989,
        24
    ),
    (
        7,
        '326-3-33-703611-5',
        'Burning Daylight',
        'asdds',
        2012,
        12
    ),
    (
        8,
        '945-5-06-005411-4',
        'Memoirs of Sherlock Holmes',
        'XYZ',
        2012,
        1
    ),
    (
        8,
        '942-5-26-005211-4',
        'The Adventure of Sherlock Holmes',
        'XYZ',
        2012,
        5
    )
GO

SELECT * FROM Book;
GO

USE Library
GO

-- 1.Создать представление на основе одной из таблиц задания 6.

CREATE VIEW Authors_v AS SELECT Author_ID, Surname FROM Authors
-- WHERE Surname = 'Tolstoy'
GO

SELECT * FROM Authors_v
GO

--2.Создать представление на основе полей обеих связанных таблиц задания 6.
CREATE VIEW Authors_Book_v AS
    SELECT
        Authors.Author_ID, Authors.Surname, Authors.Firstname, Book.Book_name
    FROM Authors INNER JOIN Book
        ON Authors.Author_ID = Book.Author_ID
		-- WHERE Book.Book_name = 'The Picture of Dorian Gray'
    WITH CHECK OPTION
GO

SELECT * FROM Authors_Book_v
GO

-- 3.Создать индекс для одной из таблиц задания 6, включив в него дополнительные неключевые поля.

DROP INDEX IF EXISTS Book_name_idx  
    ON Book
GO

CREATE INDEX Book_name_idx 
    ON Book (Book_name)
  INCLUDE (Publishing_house, Year_of_issue);
GO

SELECT Book_name, Publishing_house, Year_of_issue
FROM Book
WHERE Book_name = 'The Picture of Dorian Gray' AND Year_of_issue > 1850

--4.Создать индексированное представление.

--Set the options to support indexed views.
SET NUMERIC_ROUNDABORT OFF;
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT,
   QUOTED_IDENTIFIER, ANSI_NULLS ON;

IF OBJECT_ID ('Auth_v', 'view') IS NOT NULL
DROP VIEW Auth_v;
GO

CREATE VIEW Auth_v
	WITH SCHEMABINDING AS                                 
	SELECT dbo.Authors.Author_ID, dbo.Authors.Surname, dbo.Authors.Firstname     
	FROM dbo.Authors;                                       
GO

CREATE UNIQUE CLUSTERED INDEX Index1
	ON Auth_v (Author_ID);
GO

SELECT * FROM Auth_v
GO