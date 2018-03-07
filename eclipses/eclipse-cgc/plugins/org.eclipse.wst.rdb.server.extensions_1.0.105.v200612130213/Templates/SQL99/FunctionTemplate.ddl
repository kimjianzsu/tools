-- <ScriptOptions statementTerminator="/" />
--  SQL99
CREATE FUNCTION <schema>.function1 (parm1 char(3))
        RETURNS integer
        LANGUAGE SQL
        READS SQL
        DETERMINISTIC
        BEGIN
        	RETURN SELECT integerCol FROM table1
		    WHERE col3 =  parm1;
		END;
/
  