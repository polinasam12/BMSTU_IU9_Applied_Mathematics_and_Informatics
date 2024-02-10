-- 1.Исследовать и проиллюстрировать на примерах 
-- различные уровни изоляции транзакций MS SQL Server, 
-- устанавливаемые с использованием инструкции SET TRANSACTION ISOLATION LEVEL


-- 1 Грязное чтение

USE Library;
GO
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED -- если сменить на READ COMMITTED, то не будет грязного чтения
 BEGIN TRANSACTION;
-- 	SELECT * FROM Books
-- 		WAITFOR DELAY '00:00:10';
	SELECT * FROM Books;
		WAITFOR DELAY '00:00:10';
	SELECT * FROM Books;
	SELECT request_session_id, request_type, request_mode, resource_database_id FROM sys.dm_tran_locks
COMMIT TRANSACTION
GO


-- 2 Невоспроизводимое чтение
-- READ COMMITTED не защищает от невоспроизводимого чтения

USE Library;
GO
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
 BEGIN TRANSACTION;
 	SELECT * FROM Books
 		WAITFOR DELAY '00:00:10';
	SELECT * FROM Books;
	SELECT request_session_id, request_type, request_mode, resource_database_id FROM sys.dm_tran_locks
COMMIT TRANSACTION
GO

-- 3 Фантомное чтение
-- repeatable read защищает от невоспроизводимого чтения
-- repeatable read не защищает от фантомного чтения чтения

USE Library;
GO
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION;
	SELECT * FROM Books
		WAITFOR DELAY '00:00:10';
    SELECT * FROM Books
	SELECT request_session_id, request_type, request_mode, resource_database_id FROM sys.dm_tran_locks
COMMIT TRANSACTION;
GO

-- 4 SERIALIZABLE

USE Library;
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
	SELECT * FROM Books
		WAITFOR DELAY '00:00:10';
    SELECT * FROM Books
	SELECT request_session_id, request_type, request_mode, resource_database_id FROM sys.dm_tran_locks
COMMIT TRANSACTION;
GO

