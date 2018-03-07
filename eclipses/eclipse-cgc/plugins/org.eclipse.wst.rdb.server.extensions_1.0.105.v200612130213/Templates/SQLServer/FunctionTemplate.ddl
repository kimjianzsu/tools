-- <ScriptOptions statementTerminator="go" />
CREATE FUNCTION <schema>.get_enddate()
RETURNS [datetime] AS 
BEGIN
    RETURN DATEADD(millisecond, -2, CONVERT(datetime, '2004-7-1'));
END;
go

  