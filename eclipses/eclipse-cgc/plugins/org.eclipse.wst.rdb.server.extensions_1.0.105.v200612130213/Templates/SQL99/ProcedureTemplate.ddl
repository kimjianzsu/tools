-- <ScriptOptions statementTerminator="/" />
-- SQL99
CREATE PROCEDURE <schema>.procedure1 ( IN parm1 INTEGER )
    PARAMETER STYLE SQL
    DETERMINISTIC  
    BEGIN
      DELETE FROM table1 WHERE col2 = parm1;
    END;
/ 
