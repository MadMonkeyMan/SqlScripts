--Generate Synonms
select 'create synonym syn_' + t.name + ' for [' + DB_NAME() + '].[' + s.name + '].[' + t.name + ']' 
    from sys.tables t
        inner join sys.schemas s
            on t.schema_id = s.schema_id
    where t.type = 'U'

--Update
CREATE PROCEDURE SynonymUpdate
   @Database nvarchar(256), -- such as 'linkedserver.database' or just 'database'
   @Schema sysname -- such as 'dbo'
AS
CREATE TABLE #Tables (
   TableID int identity(1,1) NOT NULL PRIMARY KEY CLUSTERED,
   Table_Name sysname
)
DECLARE
   @SQL nvarchar(4000),
   @ID int
SET @SQL = N'SELECT Table_Name FROM ' + @Database + '.INFORMATION_SCHEMA.TABLES WHERE Table_Schema = @TableSchema'
INSERT #Tables EXEC sp_executesql @SQL, N'@TableSchema sysname', @Schema
SELECT @ID = MAX(TableID) FROM #Tables
WHILE @ID > 0 BEGIN
   SELECT @SQL = 'CREATE SYNONYM ' + Table_Name + ' FOR ' + @Database + '.' + @Schema + '.' + Table_Name FROM #Tables WHERE TableID = @ID
   PRINT @SQL
   --EXEC sp_executesql @SQL
   SET @ID = @ID - 1
END
--EXEC SynonymUpdate 'Database' , 'dbo'
