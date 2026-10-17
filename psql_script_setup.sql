Executing script from psql

Set variable in environment level:

export PGSCRIPTS=/backup/postgres/scripts

Open PSQL:

Postgres# \set PGSCRIPTS `echo $PGSCRIPTS`

Execute:
postgres=# \i :PGSCRIPTS/pg_param_val.sql

Passing input argument:

posrgres=# \set variable 'value'
Postgres=# \i script_name.sql

$psql -d db_name -p 5432 -h localhost -U postgres -f script_name.sql -v variable="value"
