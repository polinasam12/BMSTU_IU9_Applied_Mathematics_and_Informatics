USE master;
GO

-- 1.создать базу данных, спроектированную в рамках лабораторной работы №4, 
-- используя изученные в лабораторных работах 5-10 средства SQL Server 2012:
--    1.1 поддержания создания и физической организации базы данных;
--    1.2 различных категорий целостности;
--    1.3 представления и индексы;
--    1.4 хранимые процедуры, функции и триггеры;

IF DB_ID (N'Lab11') IS NOT NULL 
DROP DATABASE Lab11
GO


CREATE DATABASE Lab11
     ON (
        NAME = Lab11Data,
        FILENAME = "C:\SQL\Lab11dat.mdf",
        SIZE = 10,
        MAXSIZE = UNLIMITED,
        FILEGROWTH = 5 %
        ) 
    LOG ON (
        NAME = Lab11Log,
        FILENAME = "C:\SQL\Lab11log.ldf",
        SIZE = 5MB,
        MAXSIZE = 25MB,
        FILEGROWTH = 5MB
        );
GO

USE Lab11
GO
if OBJECT_ID(N'Authors') is NOT NULL 
DROP Table Authors;
GO

--- Таблица Authors ---

CREATE TABLE Authors
(
    Author_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
    Surname VARCHAR(20) NULL,
    FirstName VARCHAR(20) NULL,
    Patronymic VARCHAR(20) NULL,
    --Date_of_birth DATE NULL
);
GO


ALTER TABLE Authors
  ADD Date_of_birth DATE NULL
GO

ALTER TABLE Authors
  ALTER COLUMN Surname VARCHAR(20) NULL
GO







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
    ('Conan Doyle','Arthur', NULL,'1859-05-22')
GO





SELECT * FROM Authors;
GO



--- Таблица Sections ---

CREATE TABLE Section
(
    Section_ID INT PRIMARY KEY NOT NULL,
    Section_name VARCHAR(20) NULL,
    Description VARCHAR(32) NULL,

);

INSERT INTO Section
    (Section_ID,Section_name,Description)
VALUES
    (1,'Russian literature','Russian'),
    (2,'English literature','English')
GO

SELECT * FROM Section
GO


--- Таблица Books ---

CREATE TABLE Books
(
    Book_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,  -- автоинкрементный первичный ключ 
    ISBN VARCHAR(20) NULL UNIQUE,  -- уникльный ключ
    Book_name VARCHAR(32) NOT NULL ,  
    Publishing_house VARCHAR(20) NULL,
    Year_of_issue INT NULL,
    Section_ID INT NULL DEFAULT 1,
    Number_of_copies INT NULL  CHECK (Number_of_copies >= 1),   --Проверка CHECK
    CONSTRAINT FK_Book_Section FOREIGN KEY (Section_ID) REFERENCES Section (Section_ID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT CHK_Number_of_copies CHECK (Number_of_copies > 0), -- ограничение CHECK
);
GO


ALTER TABLE Books
  ALTER COLUMN Book_name VARCHAR(40) NOT NULL
GO



INSERT INTO Books
    (ISBN,Book_name,Publishing_house,Year_of_issue,Section_ID,Number_of_copies)
VALUES
    ('978-5-06-002611-5','War and Peace','ABC',1971,1, 12),
    ('789-5-06-112611-5','Taras Bulba','dsdsdsdsd',1978,1,2),
    ('943-5-04-143092-1','Romeo and Juliet','Colleen Hoover',1999,2,3),
    ('978-5-04-122092-1','Oliver Twist','Ojsljhd',2019,2,4),
    ('433-3-03-676356-1','The Picture of Dorian Gray','Ojsljhd',1985,2,24),
    ('234-1-06-102611-5','Vishneviy Sad','asadsdww',2000,1,4), 
    ('214-1-26-102611-5','White Fang','asadsdww',2022,2,12),
    ('326-3-33-703611-5','Burning Daylight','asdds',2012,2,6),
    ('945-5-06-005411-4','Memoirs of Sherlock Holmes','XYZ',1987,2,23),
    ('942-5-26-005211-4','The Adventure of Sherlock Holmes','XYZ',1988,2,32);
GO


SELECT * FROM Books;
GO



--- Таблица Issuance_of_books ---

CREATE TABLE Readers
(
    Reader_ID INT PRIMARY KEY NOT NULL, 
    Surname VARCHAR(20) NULL,
    FirstName VARCHAR(20) NULL,
    Patronymic VARCHAR(20) NULL,
    Date_of_birth DATE NULL,
    Address VARCHAR(32) NULL,
    Phone_number VARCHAR(15) NULL

);


INSERT INTO Readers
    (Reader_ID,Surname,FirstName,Patronymic,Date_of_birth,Address,Phone_number)
VALUES
    (1,'Gromov','Egor','Svyatoslavovich','1980-10-15','Moscow, Zelenaya str,1-1-1','8(222)2222222'),
    (2,'Maltseva','Ariana','Mikhailovna','1978-11-15','Moscow, Arbat str, 12-12-12','8(111)1111111'),
    (3,'Vladimirov','Egor','Bilalovich','1969-09-19','Tula, Glavnaya str, 1-2-3','8(123)1234567'),
    (4,'Zakharov','Matvey','Glebovich','2000-10-10','Perm, Novaya str, 12-11-10','8(899)8889900'),
    (5,'Gurova','Daria','Dmitrievna','1980-10-15','Moscow, Zelenaya str,1-1-1','8(222)2222222'),
    (6,'Shaposhnikova','Anastasia','Alexandrovna','1978-11-15','Moscow, Arbat str, 12-12-12','8(111)1111111'),
    (7,'Lebedeva','Victoria','Timofeevna','1969-09-19','Tula, Glavnaya str, 1-2-3','8(123)1234567'),
    (8,'Biryukov','Vladimir','Glebovich','2000-10-10','Perm, Novaya str, 12-11-10','8(899)8889900')
GO

SELECT * FROM Readers
GO



--- Таблица Issuance_of_books ---

CREATE TABLE Issuance_of_books
(
    Issue_ID INT PRIMARY KEY NOT NULL, 
    Date_of_issue VARCHAR(20) NULL,
    Date_of_return VARCHAR(20) NULL,
    Book_ID INT NOT NULL,
    Reader_ID INT NOT NULL,
    CONSTRAINT FK_Issuance_of_books_Books FOREIGN KEY (Book_ID) REFERENCES Books (Book_ID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_Issuance_of_books_Reader FOREIGN KEY (Reader_ID) REFERENCES Readers (Reader_ID)
        ON UPDATE CASCADE ON DELETE CASCADE,
);

INSERT INTO Issuance_of_books
    (Issue_ID,Date_of_issue,Date_of_return,Book_ID,Reader_ID)
VALUES
    (1,'2021-09-10','2021-10-10',7,4),
    (2,'2022-01-02','2022-03-03',4,1),
    (3,'2022-04-10','2022-06-10',3,3),
    (4,'2022-10-10',NULL,1,2),
    (5,'2022-09-10',NULL,8,8),
    (6,'2022-02-02',NULL,2,2),
    (7,'2022-04-10','2022-06-10',1,2),
    (8,'2022-10-10',NULL,1,2),
    (9,'2022-09-10','2022-10-10',2,7),
    (10,'2022-02-02','2022-02-03',1,1),
    (11,'2022-04-10',NULL,3,3),
    (12,'2022-10-10',NULL,1,2)

GO

SELECT * FROM Issuance_of_books
GO


--- Таблица Book_Author_Int ---

CREATE TABLE Book_Author_INT
(
    Book_ID INT NOT NULL,
    Author_ID INT NOT NULL,
    CONSTRAINT FK_Book_Author_INT FOREIGN KEY (Book_ID) REFERENCES Books (Book_ID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT FK_Autors_Book FOREIGN KEY (Author_ID) REFERENCES Authors (Author_ID)
        ON UPDATE CASCADE ON DELETE CASCADE,

);


INSERT INTO Book_Author_INT
    (Book_ID, Author_ID)
VALUES
    (1,1),
    (2,3),
    (3,5),
    (4,4),
    (5,6),
    (6,2),
    (7,7),
    (8,7),
    (9,8),
    (10,8)
GO

SELECT * FROM Book_Author_INT
GO






-- 1.3 представления и индексы --
PRINT '----------------------------------------------'
PRINT '-----------View Authors_Book_v---------------------------'
PRINT '----------------------------------------------'
GO

IF OBJECT_ID(N'Authors_Book_v') IS NOT NULL
    DROP VIEW Authors_Book_v
GO

CREATE VIEW Authors_Book_v
AS
    -- объединение Books, Authors, Book_Author_INT
    SELECT c.Book_ID, c.Author_ID,a.Surname, a.Firstname, a.Patronymic, b.ISBN, b.Book_name     
    FROM Books AS b join Book_Author_INT as c ON b.Book_ID = c.Book_ID
    JOIN Authors AS a ON a.Author_ID = c.Author_ID

GO
    
-- SELECT * FROM Authors_Book_v;
-- GO

PRINT '----------------------------------------------'
PRINT '-----------ReaderBookIssuanView---------------'
PRINT '----------------------------------------------'
GO

IF OBJECT_ID(N'ReaderBookIssuanView') IS NOT NULL
    DROP VIEW ReaderBookIssuanView;
GO

CREATE VIEW ReaderBookIssuanView
AS

    SELECT b.Book_ID, b.ISBN, b.Book_name, i.Date_of_issue, i.Date_of_return, 
            r.Surname,r.FirstName,r.Patronymic        
    FROM Books AS b join Issuance_of_books as i ON b.Book_ID = i.Book_ID
    JOIN Readers AS r ON r.Reader_ID = i.Reader_ID

GO
    
SELECT * FROM ReaderBookIssuanView;
GO

---- индексы ----

-- Создать индекс для одной из таблиц, включив в него дополнительные неключевые поля.

DROP INDEX IF EXISTS Book_name_idx  
    ON Books
GO

CREATE INDEX Book_name_idx 
    ON Books (Book_name)
  INCLUDE (Publishing_house, Year_of_issue);
GO


--Создать индексированное представление.

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

PRINT '---------------------'
PRINT '--- Indexing View ---'
PRINT '---------------------'
SELECT * FROM Auth_v
GO






-- 1.4 хранимые процедуры, функции и триггеры;

PRINT '------------------------'
PRINT '--- Stored procedure ---'
PRINT '------------------------'

IF OBJECT_ID ('dbo.proc1', 'P') IS NOT NULL
DROP PROCEDURE dbo.proc1;
GO

CREATE PROCEDURE dbo.proc1
    @procCursor CURSOR VARYING OUTPUT
AS
SET @procCursor = CURSOR
    FORWARD_ONLY STATIC FOR
        SELECT Author_ID, Firstname, Surname
FROM Authors;
OPEN @procCursor;   
GO

DECLARE @MyCursor1 CURSOR;
DECLARE @Cur1 INT;
DECLARE @Cur2 VARCHAR(20);
DECLARE @Cur3 VARCHAR(20);
EXEC dbo.proc1 @procCursor = @MyCursor1 OUTPUT;

FETCH NEXT FROM @MyCursor1 
    INTO @Cur1, @Cur2, @Cur3;
--позиционирование курсора

WHILE (@@FETCH_STATUS = 0)
    BEGIN;
    SELECT @Cur1 AS Author_ID, @Cur2 AS Firstname, @Cur3 AS Surname;
    FETCH NEXT FROM @Mycursor1 INTO @Cur1, @Cur2, @Cur3;
END;
CLOSE @MyCursor1;
DEALLOCATE @MyCursor1; 
GO


PRINT '------------------------'
PRINT '------- Functions ------'
PRINT '------------------------'
GO

-- возвращает список читателей, кто не вернул книги
CREATE FUNCTION ReadersDidNotReturnBook()
RETURNS TABLE
AS
    RETURN (
        SELECT b.Book_name, r.Surname, r.Firstname, r.Patronymic, r.Phone_number, i.Date_of_issue, i.Date_of_return
            FROM Readers as r RIGHT JOIN Issuance_of_books AS i
            ON r.Reader_ID = i.Reader_ID
            JOIN Books AS b ON b.Book_ID = i.Book_ID
            WHERE i.Date_of_return IS NULL
    )
GO
SELECT * FROM ReadersDidNotReturnBook()
GO

PRINT '-----------------------------------------------------------------------'
PRINT '-------- 9.2.1 ---- Trigger INSTEAD OF INSERT  -----------------'
PRINT '-----------------------------------------------------------------------'
GO


SELECT * FROM Authors_Book_v;
GO



IF OBJECT_ID ('Insert_Authors_Book_v', 'TR')  IS NOT NULL
	DROP TRIGGER Insert_Authors_Book_v;
GO
-------------------------------------------
CREATE TRIGGER Insert_Authors_Book_v
    ON Authors_Book_v
    INSTEAD OF INSERT
    AS
    BEGIN


        -- шаблон таблица с авторами, которых раньше не было
        DECLARE @author_not_exist_tbl TABLE (
            Author_ID INT NULL, 
            Surname VARCHAR(20) NULL,
            FirstName VARCHAR(20) NULL,
            Book_ID INT NULL, 
            Book_name VARCHAR(32) NULL ,         
            ISBN VARCHAR(20) NULL
        )

        -- шаблон таблица с авторами которые раньше были
        DECLARE @author_exist_tbl TABLE (
            Author_ID INT NULL, 
            Surname VARCHAR(20) NULL,
            FirstName VARCHAR(20) NULL,
            Book_ID INT NULL, 
            Book_name VARCHAR(32) NULL ,         
            ISBN VARCHAR(20) NULL
        )

        -- -- вставим во временную таблицу книги с авторами, которых раньше не было 
        INSERT INTO @author_not_exist_tbl (Author_ID,Surname,FirstName,Book_name,ISBN)
            SELECT a.Author_ID, i.Surname, i.Firstname,i.Book_name,i.ISBN 
            FROM Authors as a RIGHT JOIN inserted AS i
            ON a.Surname = i.Surname  AND a.Firstname = i.Firstname
            WHERE a.Author_ID IS NULL



        -- -- найдем уникальных авторов из тех, тоторые не присутствовали ранее в таблице Authors
        -- -- и вставим их в Authors
        INSERT INTO Authors (Surname, Firstname)
        SELECT DISTINCT Surname, Firstname FROM @author_not_exist_tbl

        PRINT '--- updated Authors ---'
        SELECT * FROM Authors


        -- вставим во временную таблицу книги с авторами, которые уже есть в таблице Authors 
        -- включая только что вставленных
        INSERT INTO @author_exist_tbl (Author_ID,Surname,FirstName,Book_name, ISBN)
            SELECT a.Author_ID, i.Surname, i.Firstname,i.Book_name, i.ISBN 
            FROM Authors as a RIGHT JOIN inserted AS i
            ON a.Surname = i.Surname  AND a.Firstname = i.Firstname
            WHERE a.Author_ID IS NOT NULL


        -- вставим новые книги авторов, которые уже присутствуют в таблице Authors


        INSERT INTO Books (Book_name, ISBN)
        SELECT DISTINCT Book_name, ISBN FROM @author_exist_tbl


        DECLARE @tmp_int_tbl TABLE (
            Book_ID INT,
            Author_ID INT
        )

        INSERT INTO @tmp_int_tbl
            SELECT Books.Book_ID, aex.Author_ID
            FROM Books  JOIN @author_exist_tbl AS aex
             ON Books.ISBN = aex.ISBN 
             

        PRINT '--- @tmp_int_tbl ----'
        SELECT * FROM @tmp_int_tbl

        INSERT INTO Book_Author_INT (Book_ID, Author_ID)
        SELECT DISTINCT * FROM @tmp_int_tbl

        

    END
GO
------------------------------------------------------------------------

INSERT INTO Authors_Book_v
    --(Authors.Surname, Authors.Firstname, Books.Book_name, Books.ISBN )
    (Surname,Firstname,Book_name,ISBN)
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
    ('Vasiliev', 'Vasiliy', 'Vasiliev Book', '454-4-44-006411-6')
GO


--  

UPDATE Books
SET Number_of_copies = 22, Section_ID = 1 WHERE ISBN = '123-4-44-002411-1' AND Book_name = 'Anna Karenina'
GO
UPDATE Books 
SET Number_of_copies = 12, Section_ID = 1 WHERE ISBN = '454-4-44-002411-1' AND Book_name = 'Ivanov Book 1'
UPDATE Books
SET Number_of_copies = 34, Section_ID = 1 WHERE ISBN = '454-4-44-002411-2' AND Book_name = 'Ivanov Book 2'
UPDATE Books 
SET Number_of_copies = 65, Section_ID = 1 WHERE ISBN = '454-4-44-002411-3' AND Book_name = 'Ivanov Book 3'
UPDATE Books 
SET Number_of_copies = 34, Section_ID = 1 WHERE ISBN = '454-4-44-002411-4' AND Book_name = 'Ivanov Book 4' 
UPDATE Books
SET Number_of_copies = 4, Section_ID = 1 WHERE ISBN = '454-4-44-002411-5' AND Book_name = 'Petrov Book' 
UPDATE Books
SET Number_of_copies = 34, Section_ID = 1 WHERE ISBN = '333-4-44-322411-1' AND Book_name = 'THE NIGHT BEFORE CHRISTMAS'
UPDATE Books 
SET Number_of_copies = 1, Section_ID = 1 WHERE ISBN = '534-4-43-102411-1' AND Book_name = 'The Prisoner of the Caucasus' 
UPDATE Books
SET Number_of_copies = 2, Section_ID = 1 WHERE ISBN = '454-4-44-006411-6' AND Book_name = 'Vasiliev Book' 
UPDATE Books
SET Number_of_copies = 5, Section_ID = 1 WHERE ISBN = '329-4-44-002411-1' AND Book_name = 'Viy' 
GO




SELECT * FROM Authors
SELECT * FROM Books
SELECT * FROM Book_Author_INT
SELECT * FROM Authors_Book_v
GO





-- 2.создание объектов базы данных должно осуществляться средствами DDL (CREATE/ALTER/DROP), 
-- в обязательном порядке иллюстрирующих следующие аспекты:
--    •добавление и изменение полей;
--    •назначение типов данных;
--    •назначение ограничений целостности (PRIMARY KEY, NULL/NOT NULL/UNIQUE, CHECK и т.п.);
--    •определение значений по умолчанию;



-- 3.в рассматриваемой базе данных должны быть тем или иным образом 
-- (в рамках объектов базы данных или дополнительно)созданы запросы DMLдля:
--    •выборки записей (команда SELECT);
--    •добавления новых записей (команда INSERT), как с помощью непосредственного указания значений, так и с помощью команды SELECT;
--    •модификации записей (команда UPDATE);
UPDATE Books
SET Number_of_copies = 100, Section_ID = 2 WHERE ISBN = '534-4-43-102411-1' 
GO

DELETE FROM Books WHERE ISBN = '329-4-44-002411-1'
GO



-- 4.запросы, созданные в рамках пп.2,3 должны иллюстрировать следующие возможности языка:
--    –удаление повторяющихся записей (DISTINCT);

SELECT DISTINCT Publishing_house FROM Books

--    –выбор, упорядочивание и именование полей (создание псевдонимов для полей и таблиц / представлений);

SELECT a.Surname, a.Firstname, b.Book_name
FROM Authors AS a JOIN Book_Author_INT AS ba
ON a.Author_ID = ba.Author_ID
JOIN Books AS b
ON b.Book_ID = ba.Book_ID


SELECT Book_name AS Name_book FROM Books

--    –соединение таблиц(INNER JOIN/LEFTJOIN / RIGHT JOIN / FULL OUTER JOIN);


-- JOIN без фильтрации WHERE, выводятся русские и английские книги
SELECT b.Book_name, s.Description
FROM Books AS b JOIN Section AS s
ON b.Section_ID = s.Section_ID


SELECT b.Book_name, s.Description
FROM Books AS b RIGHT JOIN Section AS s
ON b.Section_ID = s.Section_ID
WHERE s.Section_ID = 1



-- –условия выбора записей (в том числе, условия NULL/ LIKE/ BETWEEN/ IN/ EXISTS);

SELECT * FROM Books WHERE Book_name LIKE 'W%'

SELECT * FROM Books WHERE Number_of_copies BETWEEN 1 AND 10 ORDER BY Number_of_copies ASC




--    группировка записей (GROUP BY+ HAVING, использование функций агрегирования –COUNT / AVG / SUM / MIN / MAX);

-- выводит уникальные Publishing_house и количество каждого Publishing_house 
SELECT Publishing_house, Count(Publishing_house) AS 'Number of Publishing_house' FROM Books GROUP BY Publishing_house
GO
-- выводит количество копий книг для каждого Publishing_house 
SELECT Publishing_house, SUM(Number_of_copies) AS 'Number_of_copies' FROM Books GROUP BY Publishing_house
GO

SELECT Publishing_house, SUM(Number_of_copies) AS 'Number_of_copies' FROM Books GROUP BY Publishing_house HAVING SUM(Number_of_copies) > 10
GO

SELECT Publishing_house, MIN(Year_of_issue) AS 'Min_Year_of_issue' FROM Books GROUP BY Publishing_house
GO

SELECT Publishing_house, MAX(Year_of_issue) AS 'Max_Year_of_issue' FROM Books GROUP BY Publishing_house
GO



--    –объединение результатов нескольких запросов (UNION/ UNION ALL/ EXCEPT / INTERSECT);
--    –вложенные запросы.


SELECT * FROM Authors WHERE Author_ID BETWEEN 1 AND 3
UNION 
SELECT * FROM Authors WHERE Author_ID IN (5, 6)
ORDER BY Author_ID
GO

SELECT * FROM Authors WHERE Author_ID BETWEEN 2 AND 6
UNION ALL
SELECT * FROM Authors WHERE Author_ID IN (3, 5)
ORDER BY Author_ID
GO

SELECT * FROM Authors WHERE Author_ID BETWEEN 2 AND 6
EXCEPT
SELECT * FROM Authors WHERE Author_ID IN (3, 5)
ORDER BY Author_ID
GO

SELECT * FROM Authors WHERE Author_ID BETWEEN 2 AND 6
INTERSECT
SELECT * FROM Authors WHERE Author_ID IN (3, 5)
ORDER BY Author_ID
GO





