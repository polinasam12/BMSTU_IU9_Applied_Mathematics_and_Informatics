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

-- 4.Создать таблицу с первичным ключом на основе последовательности.

IF OBJECT_ID(N'Authors') IS NOT NULL 
DROP Table Authors;
GO


IF OBJECT_ID(N'AuthorsIdSeq') IS NOT NULL
  DROP SEQUENCE AuthorsIdSeq
GO

CREATE SEQUENCE AuthorsIdSeq
  START WITH 10
  INCREMENT BY 2
GO


CREATE TABLE Authors
(
    Author_ID INT PRIMARY KEY NOT NULL, 
    Surname VARCHAR(20) NOT NULL,
    Name VARCHAR(20) NOT NULL,
    Patronymic VARCHAR(20) NULL,
    Date_of_birth DATE
);



INSERT INTO Authors
    (
        Author_ID,
        Surname,
        Name,
        Patronymic,
        Date_of_birth
    )
VALUES
    (
        NEXT VALUE FOR AuthorsIdSeq,
        'Tolstoy',
        'Leo',
        'Nikolayevich',
        '1828-09-09'
    ),
    (
        NEXT VALUE FOR AuthorsIdSeq,
        'Chekhov',
        'Anton',
        'Pavlovich',
        '1860-01-17'
    ),
    (
        NEXT VALUE FOR AuthorsIdSeq,
        'Gogol',
        'Nikolai',
        'Vasilyevich',
        '1809-03-20'
    ),
    (
        NEXT VALUE FOR AuthorsIdSeq,
        'Dickens',
        'Charles',
        NULL,
        '1812-02-07'
    ),
    (
        NEXT VALUE FOR AuthorsIdSeq,
        'Shakespeare',
        'William',
        NULL,
        '1564-04-23'
    ),
    (
        NEXT VALUE FOR AuthorsIdSeq,
        'Wilde',
        'Oscar',
        NULL,
        '1854-10-16'
    ),
    (
        NEXT VALUE FOR AuthorsIdSeq,
        'London',
        'Jack',
        NULL,
        '1876-01-12'
    ),
    (
        NEXT VALUE FOR AuthorsIdSeq,
        'Conan Doyle',
        'Arthur',
        NULL,
        '1859-05-22'
    ),
    (
        NEXT VALUE FOR AuthorsIdSeq,
        '-',
        '-',
        '-',
        '2000-01-01'
    )
GO



SELECT * FROM Authors;
GO

USE Library;
GO
if OBJECT_ID(N'Book') is NOT NULL 
DROP Table Book;
GO

-- 1.Создать таблицу с автоинкрементным первичным ключом.
--   Изучить функции, предназначенные для получения сгенерированного значения IDENTITY.

CREATE TABLE Book
(
    Book_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL,  -- автоинкрементный первичный ключ 
    Author_ID INT NULL DEFAULT 26, -- FOREIGN KEY REFERENCES Authors (Author_ID),
    ISBN VARCHAR(20) NOT NULL,
    Name VARCHAR(32) NOT NULL UNIQUE,  -- уникльный ключ
    Publishing_house VARCHAR(20) NOT NULL,
    Year_of_issue INT NOT NULL DEFAULT 1970,
    -- Number_of_copies INT NOT NULL CHECK (Number_of_copies >= 1), --Проверка CHECK
    Number_of_copies INT NOT NULL ,   -- вычисление значений
    Registration_Date DATE NOT NULL DEFAULT GETDATE(),
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

---- Вставим значения в таблицу Book

INSERT INTO Book
    (
    Author_ID,
    ISBN,
    Name,
    Publishing_house,
    Year_of_issue,
    Number_of_copies
    )
VALUES
    (
        10,
        '978-5-06-002611-5',
        'War and Peace',
        'ABC',
        2020,
        RAND() * 100 + 1  -- вычисление значений
    ),
    (
        14,
        '789-5-06-112611-5',
        'Taras Bulba',
        'dsdsdsdsd',
        2020,
        RAND() * 100 + 1
    ),
    (
        18,
        '943-5-04-143092-1',
        'Romeo and Juliet',
        'Colleen Hoover',
        2020,
        RAND() * 100 + 1
    ),
    (
        16,
        '978-5-04-122092-1',
        'Oliver Twist',
        'Ojsljhd',
        2019,
        RAND() * 100 + 1
    ),
    (
        20,
        '433-3-03-676356-1',
        'The Picture of Dorian Gray',
        'Ojsljhd',
        2020,
        RAND() * 100 + 1
    ),
    (
        12,
        '234-1-06-102611-5',
        'Vishneviy Sad',
        'asadsdww',
        1999,
        RAND() * 100 + 1
    ), 
    (
        22,
        '214-1-26-102611-5',
        'White Fang',
        'asadsdww',
        1989,
        RAND() * 100 + 1
    ),
    (
        22,
        '326-3-33-703611-5',
        'Burning Daylight',
        'asdds',
        2012,
        RAND() * 100 + 1
    )

GO


-- Вставка со значением по умолчанию

INSERT INTO Book
    (
    Author_ID,
    ISBN,
    Name,
    Publishing_house,   -- Мы не указываем Year_of_issue
                        -- и в таком случае - Year_of_issue INT NOT NULL DEFAULT 1970,
    Number_of_copies
    )
VALUES
    (
        24,
        '945-5-06-005411-4',
        'Memoirs of Sherlock Holmes',
        'XYZ',
        RAND() * 100 + 1
    ),
    (
        24,
        '942-5-26-005211-4',
        'The Adventure of Sherlock Holmes',
        'XYZ',
        RAND() * 100 + 1
    );
GO


SELECT * FROM Book;
GO



--- Создадим таблицу Issuance_of_book


USE Library;
GO
if OBJECT_ID(N'Issuance_of_book') is NOT NULL 
DROP Table Issuance_of_book;
GO


-- 3.Создать таблицу с первичным ключом на основе глобального уникального идентификатора.


CREATE TABLE Issuance_of_book
(
    Issuance_ID UNIQUEIDENTIFIER PRIMARY KEY NOT NULL DEFAULT (NEWID()), -- первичный ключ на основе глобального уникального идентификатора
    ISBN VARCHAR(20) NOT NULL,
    Library_card_number INT NOT NULL UNIQUE, -- уникальный номер
    Date_of_issue DATE,
    Date_of_return DATE
);
GO


INSERT INTO Issuance_of_book
    (
    ISBN,
    Library_card_number,
    Date_of_issue,
    Date_of_return
    )
VALUES
    (
        '945-5-06-005411-4',
        25,
        '2022-10-12',
        '2022-11-10'
    ),
    (
        '922-5-34-125411-4',
        26,
        '2019-10-12',
        '2021-01-10'
    ),
    (
        '121-2-34-225411-7',
        28,
        '2015-03-12',
        '2021-01-10'
    )
GO

SELECT * FROM Issuance_of_book;
GO


--5.Создать две связанные таблицы, и протестировать на них различные варианты действий
--  для ограничений ссылочной целостности (NO ACTION| CASCADE | SET NULL | SET DEFAULT).


UPDATE Authors
SET Author_ID = 333
WHERE Surname = 'Conan Doyle'
GO

DELETE FROM Authors WHERE Surname = 'London';
GO 

SELECT * FROM Authors;
GO

SELECT * FROM Book;
GO