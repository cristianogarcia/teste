DROP TABLE IF EXISTS TABLES;
CREATE TEMPORARY TABLE TABLES
AS
SELECT *
  FROM INFORMATION_SCHEMA.TABLES
 WHERE TABLE_CATALOG = CURRENT_CATALOG
   AND TABLE_TYPE = 'BASE TABLE'
   AND TABLE_SCHEMA = CURRENT_SCHEMA
   AND ((TABLE_NAME = 'classificacoesfinanceiras') or (TABLE_NAME = 'centroscustos'))
 ORDER BY TABLE_NAME;

DROP TABLE IF EXISTS TABLES_IMPORTAR;
CREATE TEMPORARY TABLE TABLES_IMPORTAR
AS
SELECT TABLE_NAME AS tablename, TABLE_NAME AS tablealias
  FROM INFORMATION_SCHEMA.TABLES
 WHERE TABLE_CATALOG = CURRENT_CATALOG
   AND TABLE_TYPE = 'BASE TABLE'
   AND TABLE_SCHEMA = CURRENT_SCHEMA
   AND ((TABLE_NAME = 'classificacoesfinanceiras') or (TABLE_NAME = 'centroscustos'))
 ORDER BY TABLE_NAME;

INSERT INTO editorrelatoriotabelas 
 SELECT *
   FROM TABLES_IMPORTAR;

DROP TABLE IF EXISTS FIELDS;
CREATE TEMPORARY TABLE FIELDS
AS
SELECT  NULL AS fieldid,
        T.TABLE_NAME AS tablename,
        C.COLUMN_NAME AS fieldname,
        (CASE WHEN DATA_TYPE = 'bigint' THEN 'dtLongint'
              WHEN DATA_TYPE = 'timestamp without time zone' THEN 'dtDateTime'
              WHEN DATA_TYPE = 'bytea' THEN 'dtGraphic'
              WHEN DATA_TYPE = 'smallint' THEN 'dtInteger'
              WHEN DATA_TYPE = 'text' THEN 'dtMemo'
              WHEN DATA_TYPE = 'boolean' THEN 'dtBoolean'
              WHEN DATA_TYPE = 'double precision' THEN 'dtDouble'
              WHEN DATA_TYPE = 'integer' THEN 'dtInteger'
              WHEN DATA_TYPE = 'timestamp with time zone' THEN 'dtDateTime'
              WHEN DATA_TYPE = 'character varying' THEN 'dtString'
              WHEN DATA_TYPE = 'date' THEN 'dtDate' END) AS datatype,
        'T' AS selectable,
        'T' AS searchable,
        'T' AS sortable,
        'F' AS autosearch,
        'F' AS mandatory,
        C.COLUMN_NAME AS fieldalias     
  FROM INFORMATION_SCHEMA.COLUMNS C
  JOIN TABLES T
    ON C.TABLE_NAME = T.TABLE_NAME
   AND C.TABLE_CATALOG = T.TABLE_CATALOG 
 ORDER BY T.TABLE_NAME, C.COLUMN_NAME;

 INSERT INTO editorrelatoriocampos
	(tablename,
        fieldname,
        datatype,
        selectable,
        searchable,
        sortable,
        autosearch,
        mandatory,
        fieldalias) 
 SELECT tablename,
        fieldname,
        datatype,
        selectable,
        searchable,
        sortable,
        autosearch,
        mandatory,
        fieldalias
   FROM FIELDS
