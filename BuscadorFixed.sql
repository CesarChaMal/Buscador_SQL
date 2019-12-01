
-- SELECT * FROM sys.types WHERE SYSTEM_TYPE_ID IN (35,48,56,99,108,127,167,175,231,239,241)
-- SELECT * FROM sys.types WHERE SYSTEM_TYPE_ID IN (35, 99, 167, 175, 231, 239)

-- select * FROM sys.tables AS t;

-- select * FROM sys.columns c; 




DECLARE @i INT, @TotalRows INT, @Id INT, @Rows int, @Table VARCHAR(MAX), @Column VARCHAR(MAX)
DECLARE @Query1 NVARCHAR(MAX)
 SET @i = 1
 SET @TotalRows = 0
 SET @Rows = 0
 SET @Column = ''

/*
SELECT 
	DISTINCT (c.name) AS column_name,
	ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS  Row,
	t.name AS table_name,
	SCHEMA_NAME(schema_id) AS schema_name
 INTO #TMP_ALLCOLUMS1
FROM 
	sys.tables AS t
INNER JOIN 
	sys.columns c 
ON t.OBJECT_ID = c.OBJECT_ID
LEFT OUTER JOIN 
-- INNER JOIN 
	(SELECT SYSTEM_TYPE_ID FROM sys.types WHERE SYSTEM_TYPE_ID IN (35, 99, 167, 175, 231, 239)) AS s 
ON s.SYSTEM_TYPE_ID = c.SYSTEM_TYPE_ID
WHERE
	t.name like 'ui_auth_configured_urls'
--	AND t.name like 'ui_%'
	AND s.SYSTEM_TYPE_ID IS NOT NULL
*/

SELECT 
	ROW_NUMBER() OVER(ORDER BY t.name) AS  Row, 
	t.name AS table_name,
	SCHEMA_NAME(schema_id) AS schema_name,
	c.name AS column_name
INTO #TMP_ALLCOLUMS1
FROM 
	sys.tables AS t
INNER JOIN 
	sys.columns c 
ON t.OBJECT_ID = c.OBJECT_ID
WHERE
	c.SYSTEM_TYPE_ID IN (SELECT SYSTEM_TYPE_ID FROM sys.types WHERE SYSTEM_TYPE_ID IN (35, 99, 167, 175, 231, 239))
--	AND t.name like 'ui_auth_configured_urls'
--	AND t.name like 'ui_%'
ORDER BY t.name

  

-- select * from ui_auth_configured_urls

-- select * from #TMP_ALLCOLUMS1 WHERE  UPPER(c.name) LIKE '%ORDER%'

-- select * from #TMP_ALLCOLUMS1 ORDER BY Row

--1353
--1366

select @TotalRows = count(*) from #TMP_ALLCOLUMS1;

SELECT * 
INTO #TMP_ALLCOLUMS 
FROM (SELECT TOP (@TotalRows) * FROM #TMP_ALLCOLUMS1 order BY Row) AS TBL;

-- SELECT * FROM #TMP_ALLCOLUMS;

CREATE TABLE #TMP_TABLES_AND_COLUMS([table] varchar(max), [column] varchar(max) );

-- SELECT * FROM #TMP_TABLES_AND_COLUMS;

WHILE @i <= @TotalRows  BEGIN
	
	SELECT @Table = table_name, @Column = column_name FROM #TMP_ALLCOLUMS WHERE Row = @i
--	PRINT @Table; 

--	SET @Query1 = 'SELECT @Rows = COUNT(*) FROM ' + @Table + ' WHERE ' + @Column + ' LIKE ''%useit-reporter-all%''' 
--	SET @Query1 = 'SELECT @Rows = COUNT(*) FROM ' + @Table + ' WHERE ' + @Column + ' LIKE ''%useitngdc%''' 
	SET @Query1 = 'SELECT @Rows = COUNT(*) FROM ' + @Table + ' WHERE ' + @Column + ' LIKE ''%almxdaccount%''' 

--	PRINT @Query1; 
	execute sp_executesql @Query1,N'@Rows int out', @Rows out
	--WHERE convert( VARCHAR(MAX), ' + @Column + ')
--	PRINT @Rows
--	PRINT 'Table: ' + @Table + ' Column: ' + @Column

	IF @Rows > 0 BEGIN
		INSERT INTO #TMP_TABLES_AND_COLUMS VALUES (@Table, @Column)
	END
	SET @i = @i + 1
END

SELECT * FROM #TMP_TABLES_AND_COLUMS --esta tabla temporar tiene los resultados

DROP Table #TMP_ALLCOLUMS;
DROP Table #TMP_ALLCOLUMS1;
DROP Table #TMP_TABLES_AND_COLUMS;


-- DROP Table #TMP_TABLES_AND_COLUMS
--DECLARE @Table VARCHAR(MAX), @Column VARCHAR(MAX), @Query NVARCHAR(MAX), @i int
--SET  @i= 2
 
--SELECT @Table = 'AeTLASTables'
--SELECT @Column = 'BACKName'

--SET @Query = 'SELECT @i =  count(*) from ' + @Table + ' where ' + @Column +' = ''1366'''



-- execute sp_executesql @Query,N'@i int out', @i out
