select owner, table_name, column_name, num_rows, cardinality, selectivity
  from (select b.owner,
               a.table_name,
               a.column_name,
               b.num_rows,
               a.num_distinct cardinality,
               round(a.num_distinct / b.num_rows * 100£¬ 2) selectivity
          from dba_tab_col_statistics a, dba_tables b
         where a.owner = b.owner
           and a.table_name = b.table_name
           and a.owner = 'scott'
           and a.table_name = 'test')
 where selectivity > 20
   and column_name not in (select column_name
                             from dba_ind_columns
                            where table_owner = 'scott'
                              and table_name = 'test')
   and column_name in
       (select c.name
          from sys.col_usage$ u, sys.obj$ o, sys.col$ c, sys.user$ r
         where o.obj# = u.obj#
           and c.obj# = u.obj#
           and c.col# = u.intcol#
           and r.name = 'scott'
           and o.name = 'test')
