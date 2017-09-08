select 'create synonym syn_' + t.name + ' for [' + DB_NAME() + '].[' + s.name + '].[' + t.name + ']' 
    from sys.tables t
        inner join sys.schemas s
            on t.schema_id = s.schema_id
    where t.type = 'U'
