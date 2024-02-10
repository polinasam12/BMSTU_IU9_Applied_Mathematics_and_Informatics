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

if OBJECT_ID(N'Books') is NOT NULL 
DROP Table Books;
GO

CREATE TABLE Books
(
    Book_ID INT NOT NULL,  -- автоинкрементный первичный ключ 
    ISBN VARCHAR(20) NULL,
    Book_name VARCHAR(32) NULL ,  -- уникльный ключ
    Publishing_house VARCHAR(20) NULL
);
GO
INSERT INTO Books
    (Book_ID, ISBN, Book_name, Publishing_house)
VALUES
    (1, '978-5-06-002611-5', 'War and Peace', 'ABC'),
    (2, '789-5-06-112611-5', 'Taras Bulba', 'dsdsdsdsd'),
    (3, '943-5-04-143092-1', 'Romeo and Juliet', 'Colleen Hoover')
GO

SELECT * FROM Books
GO





