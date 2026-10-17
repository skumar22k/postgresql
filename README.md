# PostgreSQL PSQL Configuration

A customized `psql` configuration designed to improve query readability and productivity for PostgreSQL DBAs and developers.

## Features

- **Automatic Formatting:** Switches to expanded display when query results are too wide for the terminal.
- **Informative Prompt:** Displays the current username and database name.
- **Query Timing:** Shows SQL execution duration.
- **NULL Formatting:** Displays NULL values as `[NULL]`.
- **Command History:** Ignores consecutive duplicate commands.
- **SQL Shortcut:** Provides a shortcut for generating `SELECT * FROM` statements.
- **Unicode Table Output:** Uses visible borders and Unicode table formatting.

## Configuration

Create a file named `.psqlrc` in the home directory of the operating system user running `psql`.

```sql
-- Automatically format wide query results
\x auto

-- Configure the interactive prompt
\set PROMPT1 '%n@%/%R%# '

-- Display query execution time
\timing on

-- Display NULL values explicitly
\pset null '[NULL]'

-- Ignore consecutive duplicate commands
\set HISTCONTROL ignoredups

-- Define a SELECT query shortcut
\set sel 'SELECT * FROM '

-- Configure table borders and Unicode formatting
\pset border 2
\pset linestyle unicode
```

## Installation

Copy the configuration file to the home directory of the user running `psql`.

```bash
cp .psqlrc ~/.psqlrc
```

Start a PostgreSQL session:

```bash
psql -d postgres
```

## Usage Examples

### SQL Shortcut

Type the following in the interactive `psql` terminal:

```text
:sel employees
```

This expands to:

```sql
SELECT * FROM employees
```

### Query Timing

Execution time is displayed after each SQL command.

### NULL Values

NULL values are displayed as `[NULL]` to distinguish them from empty values.

### Automatic Formatting

Wide query results switch automatically to expanded display when appropriate for the terminal width.

## Compatibility

Designed for PostgreSQL `psql` clients that support the configured meta-commands.

## Purpose

This configuration helps standardize the interactive PostgreSQL environment and makes routine database administration tasks easier.

## License

Specify an appropriate license before redistributing this configuration publicly.
