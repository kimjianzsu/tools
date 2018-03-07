-- <ScriptOptions statementTerminator=";" />
--  Sybase
create function function1(state char(20)) 
        returns integer
language java parameter style java
external name 
        'SQLJExamples.region(java.lang.String)'
;

  