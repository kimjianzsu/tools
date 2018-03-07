-- <ScriptOptions statementTerminator="@" />
CREATE PROCEDURE <schema>.procedure1
    (IN id CHAR(3), IN n INT)
    LANGUAGE SQL
    BEGIN
      DECLARE SQLSTATE CHAR(5);
      DECLARE not_found CONDITION FOR SQLSTATE '02000';
      DECLARE EXIT HANDLER FOR not_found
        SIGNAL SQLSTATE '02444';
      CASE n
        WHEN 1 THEN 
          UPDATE <schema>.table1 SET col2 = col2 * 1.10 WHERE col1 = id;
        ELSE
          UPDATE <schema>.table1 SET col2 = col2 * 1.03 WHERE col1 = id;
       END CASE;
    END @