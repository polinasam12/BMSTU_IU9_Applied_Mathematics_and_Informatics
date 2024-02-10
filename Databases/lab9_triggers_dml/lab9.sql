USE master;
GO
IF DB_ID (N'Library') IS NOT NULL 
DROP DATABASE Library;
GO

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

USE Library;
GO
if OBJECT_ID(N'Authors') is NOT NULL 
DROP Table Authors;
GO

CREATE TABLE Authors
(
    Author_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
    Surname VARCHAR(20) NULL,
    FirstName VARCHAR(20) NULL,
    Patronymic VARCHAR(20) NULL,
    Date_of_birth DATE NULL
);

INSERT INTO Authors
    (Surname,FirstName,Patronymic,Date_of_birth)
VALUES
    ('Tolstoy','Leo','Nikolayevich','1828-09-09'),
    ('Chekhov','Anton','Pavlovich','1860-01-17'),
    ('Gogol','Nikolai','Vasilyevich','1809-03-20'),
    ('Dickens','Charles',NULL,'1812-02-07'),
    ('Shakespeare','William',NULL,'1564-04-23'),
    ('Wilde','Oscar',NULL,'1854-10-16'),
    ('London','Jack',NULL,'1876-01-12'),
    ('Conan Doyle','Arthur',NULL,'1859-05-22')
GO

SELECT * FROM Authors;
GO

CREATE TABLE Books
(
    Book_ID INT IDENTITY(1,1) NOT NULL,
    Author_ID INT NULL, -- FOREIGN KEY REFERENCES Authors (Author_ID),
    ISBN VARCHAR(20) NULL,
    Book_name VARCHAR(32) NULL,  -- уникльный ключ
    Publishing_house VARCHAR(20) NULL,
    Year_of_issue INT NULL,
    -- Number_of_copies INT NOT NULL CHECK (Number_of_copies >= 1), --Проверка CHECK
    Number_of_copies INT NULL ,   -- вычисление значений
    CONSTRAINT FK_Autors_Book FOREIGN KEY (Author_ID) REFERENCES Authors (Author_ID)
    ON UPDATE CASCADE ON DELETE CASCADE
);
GO

INSERT INTO Books
    (Author_ID,ISBN,Book_name,Publishing_house,Year_of_issue,Number_of_copies)
VALUES
    (1,'978-5-06-002611-5','War and Peace','ABC',2020,4),
    (3,'789-5-06-112611-5','Taras Bulba','dsdsdsdsd',2020,12),
    (5,'943-5-04-143092-1','Romeo and Juliet','Colleen Hoover',2020,7),
    (4,'978-5-04-122092-1','Oliver Twist','Ojsljhd',2019,11),
    (6,'433-3-03-676356-1','The Picture of Dorian Gray','Ojsljhd',2020,3),
    (2,'234-1-06-102611-5','Vishneviy Sad','asadsdww',1999,4), 
    (7,'214-1-26-102611-5','White Fang','asadsdww',1989,3),
    (7,'326-3-33-703611-5','Burning Daylight','asdds',2012,10),
    (8,'945-5-06-005411-4','Memoirs of Sherlock Holmes','XYZ',2000,1),
    (8,'942-5-26-005211-4','The Adventure of Sherlock Holmes','XYZ',2001,2);
GO


SELECT * FROM Books;
GO


CREATE VIEW Authors_Book_v AS
    SELECT
        Authors.Author_ID AS Author_ID,
        Authors.Surname AS Surname,
        Authors.Firstname AS Firstname,
        Books.Book_name AS Book_name,
        Books.ISBN AS ISBN
        -- Authors.Author_ID,
        -- Authors.Surname,
        -- Authors.Firstname,
        -- Books.Book_name,
        -- Books.ISBN
    FROM Authors INNER JOIN Books
        ON Authors.Author_ID = Books.Author_ID
    --WITH CHECK OPTION
GO



-- 1.Для одной из таблиц пункта 2 задания 7 создать триггеры на вставку, 
-- удаление и добавление, при выполнении заданных условий один из триггеров 
-- должен инициировать возникновение ошибки (RAISERROR / THROW).

PRINT '-----------------------------------------------------------------------'
PRINT '----- 9.1.1---- Trigger on INSERT with RAISERROR error condition ------'
PRINT '-----------------------------------------------------------------------'
IF OBJECT_ID(N'Insert_to_Books', N'TR') IS NOT NULL
	DROP TRIGGER Insert_to_Books
GO

CREATE TRIGGER Insert_to_Books
ON Books FOR INSERT
AS
    IF EXISTS (SELECT inserted.Book_ID FROM inserted WHERE inserted.Book_ID > 10)
        RAISERROR('Entry with "Books.Book_ID" > 10 were added', 10, 1);
GO
-----------------------------------------------------------------------------

INSERT INTO Books
    ( Author_ID, ISBN, Book_name, Publishing_house, Year_of_issue, Number_of_copies)
VALUES
    (8, '548-5-06-002611-5',  'The Hound of the Baskervilles', 'ABC', 2000, 5),
    (1, '548-5-06-002611-5',  'Anna Karenina', 'Asdf', 1999, 30)
    --(12, '511-5-06-002611-5',  'Three sisters', 'Asdf', 1980, 24)
GO

----------------------------------------------------------------------------
SELECT * FROM Books
GO


PRINT '-----------------------------------------------------------------------'
PRINT '-------- 9.1.2 ---- Trigger on UPDATE ---------------------------------'
PRINT '-----------------------------------------------------------------------'

IF OBJECT_ID(N'Update_of_Books', N'TR') IS NOT NULL
	DROP TRIGGER Update_of_Books
GO

CREATE TRIGGER Update_of_Books
	ON Books
	FOR UPDATE
	AS
		PRINT 'table Books has been updated'
GO
------- UPDATE -------------------------------------------------------------
UPDATE Books
SET Book_name = 'The Lost World'
WHERE Book_name = 'The Hound of the Baskervilles'
GO

----------------------------------------------------------------------------
SELECT * FROM Books
GO


PRINT '-----------------------------------------------------------------------'
PRINT '-------- 9.1.3 ---- Trigger on DELETE ---------------------------------'
PRINT '-----------------------------------------------------------------------'

IF OBJECT_ID(N'Delete_from_Books', N'TR') IS NOT NULL
	DROP TRIGGER Delete_from_Books
GO

CREATE TRIGGER Delete_from_Books
ON Books
AFTER DELETE 
as
    PRINT 'Deleted from Books'
go

DELETE FROM Books WHERE Book_name = 'Anna Karenina';
GO 

SELECT * FROM Books
GO




DISABLE TRIGGER Insert_to_Books ON Books;
DISABLE TRIGGER Update_of_Books ON Books;
DISABLE TRIGGER Delete_from_Books ON Books;
GO


-- 2.Для представления пункта 2 задания 7создать триггеры на вставку, 
-- удаление и добавление, обеспечивающие возможность выполнения операций с данными непосредственно через представление.

PRINT '-----------------------------------------------------------------------'
PRINT '-------- 9.2.1 ---- Trigger INSTEAD OF INSERT in VIEW -----------------'
PRINT '-----------------------------------------------------------------------'
GO 

IF OBJECT_ID ('VIEW_INSERT', 'TR')  IS NOT NULL
	DROP TRIGGER VIEW_INSERT;
GO
-------------------------------------------
CREATE TRIGGER VIEW_INSERT
    ON Authors_Book_v
    INSTEAD OF INSERT
    AS
    BEGIN

        -- таблица с авторами, которых раньше не было
        DECLARE @author_not_exist_tbl TABLE (
            Author_ID INT NULL, 
            Surname VARCHAR(20) NULL,
            FirstName VARCHAR(20) NULL, 
            Book_name VARCHAR(32) NULL ,         
            ISBN VARCHAR(20) NULL
        )

        -- таблица с авторами
        DECLARE @author_exist_tbl TABLE (
            Author_ID INT NULL, 
            Surname VARCHAR(20) NULL,
            FirstName VARCHAR(20) NULL, 
            Book_name VARCHAR(32) NULL ,         
            ISBN VARCHAR(20) NULL
        )

        -- вставим во временную таблицу книги с авторами, которых раньше не было 
        INSERT INTO @author_not_exist_tbl (Author_ID,Surname,FirstName,Book_name, ISBN)
            SELECT a.Author_ID, i.Surname, i.Firstname, i.Book_name, i.ISBN 
            FROM Authors as a RIGHT JOIN inserted AS i
            ON a.Surname = i.Surname  AND a.Firstname = i.Firstname
            WHERE a.Author_ID IS NULL



        PRINT '--- @temp_table ---'
        SELECT * FROM @author_not_exist_tbl

        -- найдем уникальных авторов из тех, тоторые не присутствовали ранее в таблице Authors
        -- и вставим их в Authors
        INSERT INTO Authors (Surname, Firstname)
        SELECT DISTINCT Surname, Firstname FROM @author_not_exist_tbl

        PRINT '--- updated Authors ---'
        SELECT * FROM Authors


        -- вставим во временную таблицу книги с авторами, которые уже есть в таблице Authors 
        INSERT INTO @author_exist_tbl (Author_ID,Surname,FirstName,Book_name, ISBN)
            SELECT a.Author_ID, i.Surname, i.Firstname, i.Book_name, i.ISBN 
            FROM Authors as a RIGHT JOIN inserted AS i
            ON a.Surname = i.Surname  AND a.Firstname = i.Firstname
            WHERE a.Author_ID IS NOT NULL


        -- вставим новые книги авторов, которые уже присутствовали в таблице Authors
        -- 

        PRINT '--- @author_exist_tbl ---'
        SELECT * FROM @author_exist_tbl

        INSERT INTO Books (Author_ID,Book_name, ISBN)
        SELECT DISTINCT Author_ID,Book_name, ISBN FROM @author_exist_tbl

    END
GO
------------------------------------------------------------------------

INSERT INTO Authors_Book_v
    --(Authors.Surname, Authors.Firstname, Books.Book_name, Books.ISBN )
    (Surname, Firstname, Book_name, ISBN )
VALUES
    ('Tolstoy','Leo','Anna Karenina','123-4-44-002411-1'),
    ('Tolstoy','Leo','The Prisoner of the Caucasus','534-4-43-102411-1'),
    ('Gogol','Nikolai','THE NIGHT BEFORE CHRISTMAS','333-4-44-322411-1'),
    ('Gogol','Nikolai','Viy','329-4-44-002411-1'),
    ('Ivanov', 'Ivan', 'Ivanov Book 1', '454-4-44-002411-1'),
    ('Ivanov', 'Ivan', 'Ivanov Book 2', '454-4-44-002411-2'),
    ('Ivanov', 'Ivan', 'Ivanov Book 3', '454-4-44-002411-3'),
    ('Ivanov', 'Ivan', 'Ivanov Book 4', '454-4-44-002411-4'),
    ('Petrov', 'Petr', 'Petrov Book', '454-4-44-002411-5'),
    ('Petrov', 'Petr', 'Petrov Book', '454-4-44-002411-5'),
    ('Petrov', 'Petr', 'Petrov Book', '454-4-44-002411-5'),
    ('Vasiliev', 'Vasiliy', 'Vasiliev Book', '454-4-44-002411-6')
GO



SELECT * FROM Authors_Book_v
SELECT * FROM Authors
SELECT * FROM Books
GO

PRINT '-----------------------------------------------------------------------'
PRINT '-------- 9.2.2 ---- Trigger INSTEAD OF UPDATE in VIEW -------------------------'
PRINT '-----------------------------------------------------------------------'
GO

IF OBJECT_ID ('VIEW_UPDATE', 'TR')  IS NOT NULL
	DROP TRIGGER VIEW_UPDATE;
GO

CREATE TRIGGER VIEW_UPDATE
    ON Authors_Book_v
    INSTEAD OF UPDATE
    AS
    BEGIN
		IF UPDATE (ISBN)
            BEGIN
                RAISERROR('error!', 16, 1)
                ROLLBACK TRANSACTION --Откатывает явные или неявные транзакции до начала или до точки сохранения транзакции.
                RETURN
            END

        IF UPDATE(Surname)
            BEGIN

                UPDATE Authors
                SET Surname = i.Surname
                FROM inserted AS i JOIN deleted AS d
                ON i.Author_ID = d.Author_ID
                WHERE Authors.Author_ID = d.Author_ID
            END

        IF UPDATE(Firstname)
            BEGIN

                UPDATE Authors
                SET Firstname = i.Firstname
                FROM inserted AS i JOIN deleted AS d
                ON i.Author_ID = d.Author_ID
                WHERE Authors.Author_ID = d.Author_ID

            END

        IF UPDATE(Book_name)
            BEGIN

                UPDATE Books
                SET Book_name = i.Book_name
                FROM inserted AS i JOIN deleted AS d
                ON i.ISBN = d.ISBN
                WHERE Books.ISBN = d.ISBN

            END
    END
GO

UPDATE Authors_Book_v SET Book_name = 'Revizor' 
WHERE ISBN = '978-5-06-002611-5'


UPDATE Authors_Book_v SET Surname = 'Surname 2' 
WHERE Author_ID = 2

UPDATE Authors_Book_v SET Firstname = 'Firstname 5' 
WHERE Author_ID = 5


SELECT * FROM Authors_Book_v
SELECT * FROM Authors
SELECT * FROM Books
GO

PRINT '----------------------------------------------------------------------------'
PRINT '-------- 9.2.3 ---- Trigger INSTEAD OF DELETE in VIEW ----------------------'
PRINT '----------------------------------------------------------------------------'
GO

IF OBJECT_ID ('VIEW_DELETE', 'TR')  IS NOT NULL
	DROP TRIGGER VIEW_DELETE;
GO

CREATE TRIGGER VIEW_DELETE
    ON Authors_Book_v
    INSTEAD OF DELETE
    AS
        BEGIN

            DELETE FROM Books WHERE ISBN IN (SELECT ISBN FROM deleted)

            DELETE FROM Authors WHERE Author_ID IN (SELECT Author_ID FROM deleted)

        END
GO


DELETE FROM Authors_Book_v WHERE ISBN = '789-5-06-112611-5'
GO

DELETE FROM Authors_Book_v WHERE Author_ID = 9
GO



SELECT * FROM Authors_Book_v
SELECT * FROM Authors
SELECT * FROM Books
GO