SELECT rolname
FROM pg_roles
WHERE rolsuper = true
   OR rolcreatedb = true
   OR rolcreaterole = true
   OR rolreplication = true
ORDER BY rolname;
