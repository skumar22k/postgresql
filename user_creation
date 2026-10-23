# How to Properly Configure Read-Only Access in PostgreSQL: Roles, Privileges, and Gotchas

When managing databases in production, adhering to the **Principle of Least Privilege (PoLP)** is essential. Analysts, reporting dashboards (like Grafana, Metabase, or Tableau), and auditing services should rarely, if ever, have write or schema-modification permissions.

In this guide, we will walk through the standard, secure pattern for implementing read-only access in PostgreSQL:
1. Creating a dedicated group role for permissions.
2. Creating a login role without hardcoding passwords in scripts.
3. Granting access to existing schemas and tables.
4. Handling future tables using `ALTER DEFAULT PRIVILEGES`.
5. Understanding key edge cases when multiple owners create tables.

---

## Architecture Overview

Instead of granting permissions directly to individual users, the recommended pattern is:

```text
[ sales_readonly ] (Group Role: Holds SELECT/USAGE permissions, NOLOGIN)
        ^
        | inherits
[ report_user ]    (Individual Role: Has LOGIN + password)
```

This decoupled pattern simplifies permission management: when you add more reporting users, you simply assign them to `sales_readonly` without re-running permission grants.

---

## Step 1: Create the User Role Securely

Hardcoding passwords inside `.sql` scripts or version control repositories is a common security pitfall. Instead, create the login role without specifying a password, then set it interactively.

### 1. Create the role definition:

```sql
CREATE ROLE report_user
    LOGIN
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    NOREPLICATION
    CONNECTION LIMIT 5;
```

> **Tip:** Setting `CONNECTION LIMIT` prevents reporting queries or misbehaving BI tools from exhausting your PostgreSQL connection pool.

### 2. Set the password interactively via `psql`:

Run the interactive meta-command in your `psql` terminal:

```sql
\password report_user
```

When prompted, input a strong password. The input will remain hidden from stdout and will not be recorded in shell or database query logs.

---

## Step 2: Establish the Read-Only Group Role & Privileges

Next, create the group role that acts as our permission container (if not already created):

```sql
CREATE ROLE sales_readonly NOLOGIN;
```

Now, grant permissions progressively across each layer of the database hierarchy.

### 1. Database Connection
Allow the group role to establish a connection to the database:

```sql
GRANT CONNECT ON DATABASE salesdb TO sales_readonly;
```

### 2. Schema Usage
In PostgreSQL, having table permissions is not enough; the user must also be able to "look up" objects inside the target schema:

```sql
GRANT USAGE ON SCHEMA sales TO sales_readonly;
```

### 3. Read Access to Existing Tables
Grant `SELECT` permissions on all tables currently present in the schema:

```sql
GRANT SELECT ON ALL TABLES IN SCHEMA sales TO sales_readonly;
```

### 4. Assign the Group to the Reporting User
Add `report_user` as a member of `sales_readonly`:

```sql
GRANT sales_readonly TO report_user;
```

---

## Step 3: Configure Default Privileges for Future Tables

A common trap in PostgreSQL administration is that `GRANT SELECT ON ALL TABLES` applies **only to existing tables**. If a user creates a new table tomorrow, the read-only role will be denied access by default.

To fix this, configure default privileges:

```sql
ALTER DEFAULT PRIVILEGES FOR ROLE sales_owner IN SCHEMA sales 
GRANT SELECT ON TABLES TO sales_readonly;
```

---

## ⚠️ Important: Object Ownership & Default Privileges

Notice the `FOR ROLE sales_owner` clause in the statement above. 

`ALTER DEFAULT PRIVILEGES` attaches to the **creator/owner** of future objects, not the database itself.

### Scenario A: Created by `sales_owner`
* If a migration or script runs under the `sales_owner` role and creates `sales.orders`, the `sales_readonly` role will **automatically** receive `SELECT` access.

### Scenario B: Created by another role (e.g., `db_admin` or `postgres`)
* If a table is created by a user *other* than `sales_owner`, the default privilege rule defined for `sales_owner` will **not** trigger.
* In such cases, you must manually grant privileges after creation:

```sql
GRANT SELECT ON sales.employee TO sales_readonly;
```

> **Best Practice:** Ensure all CI/CD pipelines, migration scripts, and schema migrations run under a single designated owner role (e.g., `sales_owner`), or execute `ALTER DEFAULT PRIVILEGES FOR ROLE ...` for every role authorized to create tables.

---

## Summary Checklist

| Objective | Command |
| :--- | :--- |
| **Secure Role Creation** | `CREATE ROLE report_user LOGIN ...;` + `\password report_user` |
| **Connect Permission** | `GRANT CONNECT ON DATABASE salesdb TO sales_readonly;` |
| **Schema Traversal** | `GRANT USAGE ON SCHEMA sales TO sales_readonly;` |
| **Existing Tables** | `GRANT SELECT ON ALL TABLES IN SCHEMA sales TO sales_readonly;` |
| **Role Assignment** | `GRANT sales_readonly TO report_user;` |
| **Future Tables** | `ALTER DEFAULT PRIVILEGES FOR ROLE sales_owner IN SCHEMA sales GRANT SELECT ON TABLES TO sales_readonly;` |
