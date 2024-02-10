USE MASTER
GO
DROP DATABASE IF EXISTS Lab14_1
GO
DROP DATABASE IF EXISTS Lab14_2
GO

create database Lab14_1 on (
        NAME = Lab141dat_Samokhvalova,
        FILENAME = 'C:\SQL\Lab141_Samokhvalova.mdf',
        SIZE = 10,
        MAXSIZE = 30,
        FILEGROWTH = 5
    ) log on (
        NAME = Lab141log,
        FILENAME = 'C:\SQL\Lab141log_Samokhvalova.ldf',
        SIZE = 5,
        MAXSIZE = 20,
        FILEGROWTH = 5
    );
go
create database Lab14_2 on (
        NAME = Lab142dat_Samokhvalova,
        FILENAME = 'C:\SQL\Lab142_Samokhvalova.mdf',
        SIZE = 10,
        MAXSIZE = 30,
        FILEGROWTH = 5
    ) log on (
        NAME = Lab142log,
        FILENAME = 'C:\SQL\Lab142log_Samokhvalova.ldf',
        SIZE = 5,
        MAXSIZE = 20,
        FILEGROWTH = 5
    );
go

-- 1.Создать в базах данных пункта 1 задания 13 таблицы, 
-- содержащие вертикально фрагментированные данные.


USE Lab14_1
GO
DROP TABLE IF EXISTS Books
GO

CREATE TABLE Books
(
    Book_ID INT NOT NULL Primary KEY,
    Author_ID INT NULL,
    ISBN VARCHAR(20) NULL,
    Book_name VARCHAR(32) NULL,
);
GO

INSERT INTO Books
    (Book_ID,Author_ID,ISBN,Book_name)
VALUES
    (1,1,'978-5-06-002611-5','War and Peace'),
    (2,3,'789-5-06-112611-5','Taras Bulba'),
    (3,5,'943-5-04-143092-1','Romeo and Juliet'),
    (4,4,'978-5-04-122092-1','Oliver Twist'),
    (5,6,'433-3-03-676356-1','The Picture of Dorian Gray'),
    (6,2,'234-1-06-102611-5','Vishneviy Sad');
GO

SELECT * FROM Books
GO



--------------------------------------------------------------------------------------------
USE Lab14_2
GO
DROP TABLE IF EXISTS Books
GO

CREATE TABLE Books
(
    Book_ID INT NOT NULL Primary KEY,
    Publishing_house VARCHAR(20) NULL,
    Year_of_issue INT NULL,
    Number_of_copies INT NULL
);
GO

INSERT INTO Books
    (Book_ID,Publishing_house,Year_of_issue,Number_of_copies)
VALUES
    (1,'ABC',2020,3),
    (2,'dsdsdsdsd',2020,4),
    (3,'Colleen Hoover',2020,9),
    (4,'Ojsljhd',2019,14),
    (5,'Ojsljhd',2020,10),
    (6,'asadsdww',1999,7);
GO



SELECT * FROM Books
GO




--------------------------------------------------------------------------

-- 2.Создать необходимые элементы базы данных (представления, триггеры), 
-- обеспечивающие работу с данными вертикально фрагментированных таблиц (выборку, вставку, изменение, удаление).

IF OBJECT_ID(N'BooksView') IS NOT NULL
    DROP VIEW BooksView;
GO

CREATE VIEW BooksView
AS
    SELECT  o1.Book_ID, o1.Author_ID, o1.ISBN, o1.Book_name,
            o2.Publishing_house, o2.Year_of_issue, o2.Number_of_copies
    FROM Lab14_1.dbo.Books AS o1 INNER JOIN Lab14_2.dbo.Books AS o2 
    ON o1.Book_ID = o2.Book_ID;
GO
    
SELECT * FROM BooksView;
GO





CREATE TRIGGER update_trigger ON BooksView
INSTEAD OF UPDATE 
AS
BEGIN
    IF (UPDATE (Book_ID))
    BEGIN
        RAISERROR (N'Change of Book_ID column forbidden', 18, 20);
        ROLLBACK;
    END
    IF UPDATE (Book_name)
    BEGIN
        UPDATE Lab14_1.dbo.Books
        SET Book_name = (SELECT Book_name FROM inserted
            WHERE (inserted.Book_ID = Lab14_1.dbo.Books.Book_ID))
        WHERE (EXISTS (SELECT * FROM inserted 
            WHERE (Lab14_1.dbo.Books.Book_ID = inserted.Book_ID)));
    END
    IF (UPDATE (Publishing_house))
    BEGIN
        UPDATE Lab14_2.dbo.Books
            SET Publishing_house = (SELECT Publishing_house FROM inserted
                WHERE (inserted.Book_ID = Lab14_2.dbo.Books.Book_ID))
            WHERE (EXISTS (SELECT * FROM inserted 
                WHERE (Lab14_2.dbo.Books.Book_ID = inserted.Book_ID AND Publishing_house IS NOT NULL)));
    END
    IF (UPDATE (Number_of_copies))
    BEGIN
        UPDATE Lab14_2.dbo.Books
            SET Number_of_copies = (SELECT Number_of_copies FROM inserted
                WHERE (inserted.Book_ID = Lab14_2.dbo.Books.Book_ID))
            WHERE (EXISTS (SELECT * FROM inserted 
                WHERE (Lab14_2.dbo.Books.Book_ID = inserted.Book_ID AND Number_of_copies IS NOT NULL)));
        
    END
END
GO


PRINT '-------------------------------------------------------------------------------'
PRINT '----------- UPDATE ------------------------------------------------------------'
PRINT '-------------------------------------------------------------------------------'

UPDATE BooksView
SET Book_name = 'XXXXXXXXXX'
WHERE (Book_ID = 2);
GO

UPDATE BooksView
SET Publishing_house = '11-11-11'
WHERE (Book_ID = 3);
GO

UPDATE BooksView
SET Number_of_copies = '11111111'
WHERE (Book_ID = 4);
GO

-- UPDATE BooksView  -- вызовет ошибку
-- SET Book_ID = '22'
-- WHERE (Book_ID = 4);
-- GO

SELECT * FROM BooksView;
GO




CREATE TRIGGER insert_trigger ON BooksView
INSTEAD OF INSERT AS
BEGIN
    IF (EXISTS (SELECT * FROM inserted AS i
        WHERE (EXISTS (SELECT *
            FROM Lab14_1.dbo.Books AS o1 WHERE (o1.Book_ID = i.Book_ID)))))
            BEGIN
                RAISERROR(N'Repeat Id', 18, 10);
                ROLLBACK;
            END;
            INSERT Lab14_1.dbo.Books
            SELECT Book_ID,Author_ID,ISBN,Book_name
            FROM inserted;

            INSERT Lab14_2.dbo.Books
            SELECT Book_ID,Publishing_house,Year_of_issue,Number_of_copies
            FROM inserted;
END
GO

PRINT '-------------------------------------------------------------------------------'
PRINT '----------- INSERT ------------------------------------------------------------'
PRINT '-------------------------------------------------------------------------------'




INSERT BooksView(Book_ID,Author_ID,ISBN,Book_name,Publishing_house,Year_of_issue,Number_of_copies)
        VALUES  
            (7,8,'234-1-06-102611-5','Vishneviy Sad','asadsdww',1999,34), 
            (8,6,'214-1-26-102611-5','White Fang','asadsdww',1989,4),
            (9,6,'326-3-33-703611-5','Burning Daylight','asdds',2012,4),
            (10,4,'945-5-06-005411-4','Memoirs of Sherlock Holmes','XYZ',2000,11),
            (11,4,'942-5-26-005211-4','The Adventure of Sherlock Holmes','XYZ',2001,3);
GO
SELECT * FROM BooksView;
GO

CREATE TRIGGER delete_trigger ON BooksView
INSTEAD OF DELETE AS
BEGIN
    DELETE Lab14_1.dbo.Books
    WHERE EXISTS(SELECT * FROM deleted
        WHERE(Lab14_1.dbo.Books.Book_ID = deleted.Book_ID))
    DELETE Lab14_2.dbo.Books
    WHERE EXISTS(SELECT * FROM deleted
        WHERE(Lab14_2.dbo.Books.Book_ID = deleted.Book_ID))
      
END
GO

DELETE BooksView
WHERE Book_ID = 1;
DELETE BooksView
WHERE Book_ID = 2;
DELETE BooksView
WHERE Book_ID = 3;


PRINT '-------------------------------------------------------------------------------'
PRINT '----------- DELETE ------------------------------------------------------------'
PRINT '-------------------------------------------------------------------------------'


SELECT * FROM BooksView;
GO