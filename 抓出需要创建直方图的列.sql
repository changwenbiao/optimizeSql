select b.owner,
       a.table_name,
       a.column_name,
       b.num_rows,
       a.num_distinct cardinality,
       trunc(a.num_distinct / b.num_rows * 100£¬ 2) selectivity
  from dba_tab_col_statistics a, dba_tables b
 where a.owner = b.owner
   and a.table_name = b.table_name
   and a.owner = 'scott'
   and a.table_name = 'test'
   and num_distinct / num_rows < 0.01
   and (a.owner, a.table_name, a.column_name) in
       (select r.name owner, o.name table_name, c.name column_name
          from sys.col_usage$ u, sys.obj$ o, sys.col$ c, sys.user$ r
         where o.obj# = u.obj#
           and c.obj# = u.obj#
           and c.col# = u.intcol#
           and r.name = 'scott'
           and o.name = 'test')
   and a.histogram = 'none'
