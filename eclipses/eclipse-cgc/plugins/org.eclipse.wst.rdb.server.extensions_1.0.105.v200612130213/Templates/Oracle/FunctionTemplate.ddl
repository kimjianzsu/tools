-- <ScriptOptions statementTerminator="/" />
CREATE FUNCTION <schema>.function1 (parm1 IN NUMBER)
        RETURN NUMBER
        IS ret_value NUMBER(11,2);
        BEGIN        
        	SELECT col2
        	INTO ret_value
        	FROM table1
		    WHERE col3 =  parm1;
		    RETURN(ret_value);
		END;
/		     
  