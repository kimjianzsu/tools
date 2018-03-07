-- <ScriptOptions statementTerminator="/" />
CREATE TRIGGER <schema>.trig1
  AFTER DELETE ON <schema>.<table>
  REFERENCING OLD AS OLD
  FOR EACH ROW
  BEGIN
    DELETE FROM <schema>.table2 WHERE col1 = '';
  END;
/