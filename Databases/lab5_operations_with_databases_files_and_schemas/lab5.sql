--1.Создать базу данных (CREATE DATABASE…, определение настроек размеров файлов).
USE master;
GO
IF DB_ID (N'Library') IS NOT NULL 
DROP DATABASE Library;
GO

--execute the CREATE DATABASE statement
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

--2.Создать произвольную таблицу(CREATE TABLE…).

USE Library;
GO
if OBJECT_ID(N'Book') is NOT NULL 
DROP Table Book;
GO

CREATE TABLE Book
(
    ISBN VARCHAR(100) PRIMARY KEY NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Publishing_house VARCHAR(100) NOT NULL,
    Year_of_issue VARCHAR(100) NOT NULL,
    Number_of_copies INT
);
GO

-- 3.Добавить файловую группу и файл данных(ALTER DATABASE…).


ALTER DATABASE Library
ADD FILEGROUP LargeFileGroup;
GO

ALTER DATABASE Library
ADD FILE
        ( NAME = LargeData1,
        FILENAME = "C:\SQL\Lab5\library\mydb1.ndf"),
        ( NAME = LargeData2,
        FILENAME = "C:\SQL\Lab5\library\mydb2.ndf")
TO FILEGROUP LargeFileGroup;
GO

-- 4.Сделать созданную файловую группу файловой группой по умолчанию.

ALTER DATABASE Library
MODIFY FILEGROUP LargeFileGroup DEFAULT;
GO

-- 5.(*) Создать еще одну произвольную таблицу.

USE Library;
GO

CREATE TABLE Author
(
    Surname VARCHAR(100) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Patronymic VARCHAR(100) NOT NULL,
    Date_of_birth Date,

);
GO



-- 6.(*) Удалить созданную вручную файловую группу.


DROP TABLE Author;
GO
ALTER DATABASE Library
MODIFY FILEGROUP [PRIMARY] DEFAULT;
GO
ALTER DATABASE Library
REMOVE FILE LargeData1;
GO
ALTER DATABASE Library
REMOVE FILE LargeData2;
GO
ALTER DATABASE Library 
REMOVE FILEGROUP LargeFileGroup;
GO

-- 7.Создать схему, переместить в нее одну из таблиц, удалить схему.

USE Library;
GO


CREATE TABLE Author
(
    Surname VARCHAR(100) NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Patronymic VARCHAR(100) NOT NULL,
    Date_of_birth Date,

);
GO


IF OBJECT_ID (N'LibrarySchema') IS NOT NULL
DROP SCHEMA LibrarySchema;
GO
CREATE SCHEMA LibrarySchema
GO
ALTER SCHEMA LibrarySchema TRANSFER dbo.Author;
GO
DROP TABLE LibrarySchema.Author;
GO
DROP SCHEMA LibrarySchema;
GO




