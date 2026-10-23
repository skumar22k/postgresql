SELECT
        r.rolname,
        r.rolcanlogin,
        r.rolconnlimit,
        CASE
            WHEN NOT r.rolcanlogin THEN '-n/a-'
            ELSE COALESCE(r.rolvaliduntil::text, 'unlimited')
        END AS "password_expiry_date",
        r.rolsuper,
        r.rolinherit,
        r.rolcreaterole,
        r.rolcreatedb,
        r.rolreplication
FROM
        pg_roles r
WHERE
        r.rolname NOT LIKE 'pg\_%'
        AND r.rolname <> 'postgres'
        AND r.rolname NOT IN (SELECT rolname FROM pg_roles WHERE oid < 16384)
ORDER BY
        r.rolname;	
