-- 1 Грязное чтение

USE Library;
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN TRAN
	SELECT * FROM Books

	UPDATE Books SET Book_name = 'XXXXXXXX' WHERE Book_name =  'Romeo and Juliet'
	--DELETE FROM Books WHERE Book_ID = 4
	--SELECT * FROM Books
	WAITFOR DELAY '00:00:10'
	SELECT * FROM Books
	SELECT request_session_id, request_type, request_mode, resource_database_id FROM sys.dm_tran_locks
ROLLBACK
GO




-- 2 Невоспроизводимое чтение

USE Library;
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
BEGIN TRAN
	SELECT * FROM Books

	UPDATE Books SET Book_name = 'XXXXXXXX' WHERE Book_name =  'Romeo and Juliet'
	--DELETE FROM Books WHERE Book_ID = 4
	SELECT * FROM Books
	SELECT request_session_id, request_type, request_mode, resource_database_id FROM sys.dm_tran_locks
COMMIT TRANSACTION
GO

-- 3 Фантомное чтение

USE Library;
GO
BEGIN TRANSACTION
	INSERT INTO Books (Book_ID, ISBN, Book_name, Publishing_house) 
		VALUES (4, '978-5-04-122092-1', 'Oliver Twist', 'Ojsljhd')

	SELECT * FROM Books
	SELECT request_session_id, request_type, request_mode, resource_database_id FROM sys.dm_tran_locks
COMMIT TRANSACTION;
GO


-- 4 SERIALIZABLE

USE Library;
GO
BEGIN TRANSACTION
	INSERT INTO Books (Book_ID, ISBN, Book_name, Publishing_house) 
		VALUES (4, '978-5-04-122092-1', 'Oliver Twist', 'Ojsljhd')
	--UPDATE Books SET Book_name = 'XXXXXXXX' WHERE Book_ID =  1
COMMIT TRANSACTION;
GO
SELECT * FROM Books
GO