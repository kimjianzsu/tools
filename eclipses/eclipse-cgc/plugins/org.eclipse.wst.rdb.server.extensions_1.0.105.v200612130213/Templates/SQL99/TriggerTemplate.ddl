CREATE TRIGGER <schema>.trig1
  AFTER DELETE ON <schema>.<table>
  REFERENCING OLD AS OLD1
  DELETE FROM <schema>.table2 WHERE col1 = '';