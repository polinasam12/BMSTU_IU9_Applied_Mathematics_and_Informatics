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
    (
        Surname,
        FirstName,
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







CREATE TABLE Books
(
    Book_ID INT IDENTITY(1,1) NOT NULL,  -- автоинкрементный первичный ключ 
    Author_ID INT NULL, -- FOREIGN KEY REFERENCES Authors (Author_ID),
    ISBN VARCHAR(20) NULL,
    Book_name VARCHAR(32) NULL ,  -- уникльный ключ
    Publishing_house VARCHAR(20) NULL,
    Year_of_issue INT NULL,
    -- Number_of_copies INT NOT NULL CHECK (Number_of_copies >= 1), --Проверка CHECK
    Number_of_copies INT NULL ,   -- вычисление значений
		CONSTRAINT FK_Autors_Book FOREIGN KEY (Author_ID) REFERENCES Authors (Author_ID)
			ON UPDATE CASCADE ON DELETE CASCADE,
        --ON UPDATE NO ACTION ON DELETE NO ACTION,
        --ON UPDATE SET NULL ON DELETE SET NULL,
        --ON UPDATE SET DEFAULT ON DELETE SET DEFAULT,

-- 2.Добавить поля, для которых используются ограничения (CHECK), значения по умолчанию(DEFAULT),
--   также использовать встроенные функции для вычисления значений.

    CONSTRAINT CHK_Number_of_copies CHECK (Number_of_copies > 0), -- ограничение CHECK

    
);
GO

---- Вставим значения в таблицу Books -------------------------------------------------------------------------------------

INSERT INTO Books
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
        RAND() * 100 + 1  -- вычисление значений
    ),
    (
        3,
        '789-5-06-112611-5',
        'Taras Bulba',
        'dsdsdsdsd',
        2020,
        RAND() * 100 + 1
    ),
    (
        5,
        '943-5-04-143092-1',
        'Romeo and Juliet',
        'Colleen Hoover',
        2020,
        RAND() * 100 + 1
    ),
    (
        4,
        '978-5-04-122092-1',
        'Oliver Twist',
        'Ojsljhd',
        2019,
        RAND() * 100 + 1
    ),
    (
        6,
        '433-3-03-676356-1',
        'The Picture of Dorian Gray',
        'Ojsljhd',
        2020,
        RAND() * 100 + 1
    ),
    (
        2,
        '234-1-06-102611-5',
        'Vishneviy Sad',
        'asadsdww',
        1999,
        RAND() * 100 + 1
    ), 
    (
        7,
        '214-1-26-102611-5',
        'White Fang',
        'asadsdww',
        1989,
        RAND() * 100 + 1
    ),
    (
        7,
        '326-3-33-703611-5',
        'Burning Daylight',
        'asdds',
        2012,
        RAND() * 100 + 1
    ),
    (
        8,
        '945-5-06-005411-4',
        'Memoirs of Sherlock Holmes',
        'XYZ',
        2000,
        RAND() * 100 + 1
    )
    -- (
    --     24,
    --     '942-5-26-005211-4',
    --     'The Adventure of Sherlock Holmes',
    --     'XYZ',
    --     2001,
    --     RAND() * 100 + 1
    -- );
GO

SELECT * FROM Books;
GO