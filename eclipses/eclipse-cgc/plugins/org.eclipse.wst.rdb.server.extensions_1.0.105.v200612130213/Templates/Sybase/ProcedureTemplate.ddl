-- <ScriptOptions statementTerminator="go" />
-- Sybase
create procedure <schema>.procedure1 as
declare @x int
insert into <schema>.table1 values('AAA', 0, 'creating procedure')
select col2 from <schema>.table1
go
