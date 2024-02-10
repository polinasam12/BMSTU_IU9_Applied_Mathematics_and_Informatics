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

-- Создаем таблицу Authors -----------------------------------------------------------------------------
USE Library;
GO
if OBJECT_ID(N'Authors') is NOT NULL 
DROP Table Authors;
GO

CREATE TABLE Authors
(
    Author_ID INT IDENTITY(1,1) PRIMARY KEY NOT NULL, 
    Surname VARCHAR(20) NOT NULL,
    Firstname VARCHAR(20) NOT NULL,
    Patronymic VARCHAR(20) NULL,
    Year_of_birth INT NOT NULL
);



INSERT INTO Authors
    (
    Surname,
    Firstname,
    Patronymic,
    Year_of_birth
    )
VALUES
    (
        'Tolstoy',
        'Leo',
        'Nikolayevich',
        1828
    ),
    (
        'Chekhov',
        'Anton',
        'Pavlovich',
        1860
    ),
    (
        'Gogol',
        'Nikolai',
        'Vasilyevich',
        1809
    ),
    (
        'Dickens',
        'Charles',
        NULL,
        1812
    ),
    (
        'Shakespeare',
        'William',
        NULL,
        1564
    ),
    (
        'Wilde',
        'Oscar',
        NULL,
        1854
    ),
    (
        'London',
        'Jack',
        NULL,
        1876
    ),
    (
        'Conan Doyle',
        'Arthur',
        NULL,
        1859
    )
GO

SELECT * FROM Authors;
GO



--Создать хранимую процедуру, производящую выборку из некоторой таблицы и 
--возвращающую результат выборки в виде курсора.


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

    WHILE (@@FETCH_STATUS = 0)
    BEGIN;
        SELECT @Cur1 AS Author_ID, @Cur2 AS Firstname, @Cur3 AS Surname; 
        FETCH NEXT FROM @Mycursor1 INTO @Cur1, @Cur2, @Cur3;   
    END;
CLOSE @MyCursor1; 
DEALLOCATE @MyCursor1; 
GO






--Модифицировать хранимую процедуру п.1. таким образом, чтобы выборка осуществлялась с
--формированием столбца, значение которого формируется пользовательской функцией.

IF OBJECT_ID ('dbo.func2', 'F') IS NOT NULL
DROP FUNCTION dbo.func2
GO

CREATE FUNCTION dbo.func2 (@Auth_ID int, @Year_of_birth int)
RETURNS int
AS
BEGIN
	DECLARE @result int;
	SELECT @result = @Auth_ID + @Year_of_birth
RETURN @result
END;
GO


ALTER PROCEDURE dbo.proc1 @procCursor CURSOR VARYING OUTPUT
AS
SET @procCursor = CURSOR FOR 
    SELECT Author_ID, Year_of_birth, dbo.func2(Author_ID, Year_of_birth)  
    FROM Authors;
OPEN @procCursor
GO

DECLARE @Mycursor2 CURSOR;
DECLARE @Cur1 INT;
DECLARE @Cur2 INT;
DECLARE @Cur3 INT;
EXEC dbo.proc1 @procCursor = @Mycursor2 OUTPUT;

    FETCH NEXT FROM @Mycursor2 
    INTO @Cur1, @Cur2, @Cur3;    
    WHILE (@@FETCH_STATUS = 0)
    BEGIN;
        SELECT @Cur1 AS Author_ID, @Cur2 AS Year_of_birth,  @Cur3 AS 'ID + Year';
        FETCH NEXT FROM @Mycursor2 INTO @Cur1, @Cur2, @Cur3;
    END;
CLOSE @Mycursor2; 
DEALLOCATE @Mycursor2;  
GO




--Создать хранимую процедуру, вызывающую процедуру п.1., осуществляющую прокрутку возвращаемого
--курсора и выводящую сообщения, сформированные из записей при выполнении условия, заданного еще одной
--пользовательской функцией.



IF OBJECT_ID ('dbo.func3', 'F') IS NOT NULL
DROP FUNCTION dbo.func3
GO

CREATE FUNCTION func3(@Year_of_birth INT) 
RETURNS INT
AS BEGIN
    IF @Year_of_birth > 1859
    RETURN 1;
    RETURN 0;
END;
GO

IF OBJECT_ID ('dbo.proc3', 'P') IS NOT NULL
DROP PROCEDURE dbo.proc3;
GO

CREATE PROCEDURE dbo.proc3
AS
DECLARE @Mycursor3 CURSOR;
DECLARE @Cur1 INT;
DECLARE @Cur2 INT;
DECLARE @Cur3 INT;
EXEC dbo.proc1 @procCursor= @Mycursor3 OUTPUT;
FETCH NEXT FROM @Mycursor3 into @Cur1, @Cur2, @Cur3;
WHILE (@@FETCH_STATUS = 0)
    BEGIN
        IF (dbo.func3(@Cur2) = 1)
            SELECT dbo.func3(@Cur2) AS 'Result of function', @Cur1 AS Author_ID, @Cur2 AS Year_of_birth;
        
        FETCH NEXT FROM @Mycursor3 into @Cur1, @Cur2, @Cur3;
    END;
CLOSE @Mycursor3;
DEALLOCATE @Mycursor3;
GO

EXEC dbo.proc3;
GO


--Модифицировать хранимую процедуру п.2. таким образом, чтобы выборка формировалась с помощью
--табличной функции.

IF OBJECT_ID ('dbo.func4', 'F') IS NOT NULL
DROP FUNCTION dbo.func4
GO

CREATE FUNCTION dbo.func4(@year INTEGER) RETURNS TABLE  
AS RETURN(
    SELECT Author_ID, Surname, Year_of_birth 
        FROM Authors 
        WHERE Year_of_birth > @year
    );
GO

IF OBJECT_ID ('dbo.func5', 'F') IS NOT NULL
DROP FUNCTION dbo.func5
GO

CREATE FUNCTION dbo.func5(@year INTEGER)
RETURNS @return_table TABLE
	(    Author_ID INT NOT NULL, 
		Surname VARCHAR(20) NOT NULL,
		Year_of_birth INT NOT NULL
	)
	AS
		BEGIN	
			INSERT @return_table SELECT	Author_ID, Surname, Year_of_birth
			FROM Authors 
			WHERE Year_of_birth > @year
			RETURN
		END
GO

ALTER PROCEDURE dbo.proc1 @year INTEGER = 0, @procCursor CURSOR VARYING OUTPUT
AS
SET @procCursor = CURSOR FOR SELECT * FROM dbo.func4(@year);
OPEN @procCursor
GO

DECLARE @Mycursor4 CURSOR;
DECLARE @Cur1 INT;
DECLARE @Cur2 VARCHAR(20);
DECLARE @Cur3 INT;
EXEC dbo.proc1 @year=1850, @procCursor= @MyCursor4 OUTPUT;

    FETCH NEXT FROM @Mycursor4 
    INTO @Cur1, @Cur2, @Cur3;    
    WHILE (@@FETCH_STATUS = 0)
    BEGIN;
        SELECT @Cur1 AS Author_ID, @Cur2 AS Surname, @Cur3 AS Year_of_birth;
        FETCH NEXT FROM @Mycursor4 INTO @Cur1, @Cur2, @Cur3;
    END;
CLOSE @Mycursor4; 
DEALLOCATE @Mycursor4;  
GO






