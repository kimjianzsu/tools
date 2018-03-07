-- <ScriptOptions statementTerminator="go" />
CREATE PROC <schema>.storeid_proc @stor_id CHAR(4)
	AS
	SELECT STOR_NAME,
	        STOR_ID,
	        STOR_ADDRESS	        
	FROM STORES
	WHERE STOR_ID = @stor_id;	
go
