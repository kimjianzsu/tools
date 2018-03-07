-- <ScriptOptions statementTerminator="@" />
-- Informix
CREATE PROCEDURE <schema>.procedure1(param VARCHAR(2))
  insert into <schema>.table1 values('AAA', 0, 'called function with parameter='||param);
END PROCEDURE;
@