CREATE FUNCTION <schema>.function1( parm1 INTEGER )
    RETURNS INTEGER
    LANGUAGE JAVA
    PARAMETER STYLE JAVA
    NO SQL
    EXTERNAL NAME 'JavaPkgName.JavaClassName.javaUDFName';