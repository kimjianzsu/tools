CREATE TRIGGER <schema>.trig1
  ON <schema>.<table>
  FOR DELETE
  AS DELETE FROM <schema>.table2 WHERE col1 = '';