-- <ScriptOptions statementTerminator="@" />
CREATE FUNCTION <schema>.function1( parm1 INTEGER )
    RETURNS INTEGER
    LANGUAGE SQL
    SPECIFIC SpecificName
    NO EXTERNAL ACTION
F1: BEGIN ATOMIC
    RETURN SELECT count(*) FROM <schema>.table1 where col2 = parm1;
END @
  