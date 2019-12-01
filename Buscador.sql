SELECT 
*
/*
	ROW_NUMBER() OVER(ORDER BY t.name) AS  Row, t.name AS table_name,
	SCHEMA_NAME(schema_id) AS schema_name,
	c.name AS column_name
-- INTO #TMP_ALLCOLUMS1
*/
-- FROM sys.tables AS t
 FROM sys.columns c
 WHERE c.name like '%JB_DATA%'
 

-- SELECT * FROM sys.types c order by system_type_id
 


DECLARE @i INT, @TotalRows INT, @Id INT, @Rows int, @Table VARCHAR(MAX), @Column VARCHAR(MAX)
DECLARE @Query1 NVARCHAR(MAX)
 SET @i = 1
 SET @TotalRows = 0
 SET @Rows = 0
 SET @Column = ''
 

 
SELECT ROW_NUMBER() OVER(ORDER BY t.name) AS  Row, t.name AS table_name,
SCHEMA_NAME(schema_id) AS schema_name,
c.name AS column_name
INTO #TMP_ALLCOLUMS1
FROM sys.tables AS t
INNER JOIN sys.columns c ON t.OBJECT_ID = c.OBJECT_ID
INNER JOIN (SELECT SYSTEM_TYPE_ID FROM sys.types WHERE SYSTEM_TYPE_ID IN (35,48,56,99,108,127,167,175,231,239,241)) s ON s.SYSTEM_TYPE_ID = c.SYSTEM_TYPE_ID
-- INNER JOIN (SELECT SYSTEM_TYPE_ID FROM sys.types) s ON s.SYSTEM_TYPE_ID = c.SYSTEM_TYPE_ID
--WHERE  UPPER(c.name) LIKE '%ORDER%'

--   select * from #TMP_ALLCOLUMS1 ORDER BY Row

--1353
--1366

select @TotalRows = count(*) from #TMP_ALLCOLUMS1

SELECT * 
INTO #TMP_ALLCOLUMS 
FROM (SELECT TOP (@TotalRows) * FROM #TMP_ALLCOLUMS1 order BY Row) AS TBL
-- SELECT * from #TMP_ALLCOLUMS1 

CREATE TABLE #TMP_TABLES_AND_COLUMS([table] varchar(max), [column] varchar(max), results int )


WHILE @i <= @TotalRows  BEGIN

	SELECT @Table = table_name, @Column = column_name FROM #TMP_ALLCOLUMS WHERE Row = @i

--	SET @Query1 = 'SELECT @Rows = COUNT(*) FROM ' + @Table + ' WHERE ' + @Column + ' like ''%1366%'''
	SET @Query1 = 'SELECT @Rows = COUNT(*) FROM ' + @Table + ' WHERE ' + @Column + ' like ''%useitngdc%'''
	execute sp_executesql @Query1,N'@Rows int out', @Rows out
	-- WHERE convert( VARCHAR(MAX), ' + @Column + ')
	IF @Rows > 0 BEGIN
		INSERT INTO #TMP_TABLES_AND_COLUMS VALUES (@Table, @Column, @Rows)
	END
	
	SET @i = @i + 1
END

SELECT * FROM #TMP_TABLES_AND_COLUMS --esta tabla temporal tiene los resultados

DROP Table #TMP_ALLCOLUMS1
DROP Table #TMP_ALLCOLUMS
DROP Table #TMP_TABLES_AND_COLUMS


-- SELECT COUNT(*) FROM UI_JOB WHERE JB_DATA like '%1366%'
-- SELECT * FROM UI_JOB WHERE JB_ID like '%1366%'
