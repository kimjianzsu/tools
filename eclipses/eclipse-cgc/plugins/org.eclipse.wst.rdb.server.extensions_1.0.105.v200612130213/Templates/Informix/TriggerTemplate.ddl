CREATE TRIGGER <schema>.trig1
  DELETE ON <schema>.<table>
  REFERENCING OLD AS OLD
  FOR EACH ROW ( DELETE FROM <schema>.table2 WHERE col1 = '' );