-- <ScriptOptions statementTerminator="@" />
-- Informix
CREATE FUNCTION <schema>.function1()
RETURNING VARCHAR(20);
  CREATE TEMP TABLE myfunc(c1 INTEGER);
  INSERT INTO myfunc SELECT col2 FROM j15user9.table1;
  RETURN 'Function';
END FUNCTION;
@
  

  