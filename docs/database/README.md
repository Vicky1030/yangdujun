# Kingbase Database Snapshot

This directory contains a reproducible KingbaseES SQL snapshot for the smart greenhouse project.

## Files

- `smart_greenhouse_full_dump.sql`: schema and data exported from the local `smart_greenhouse` database.

## Restore

Create an empty database named `smart_greenhouse`, then restore with Kingbase `ksql`:

```powershell
$env:KINGBASE_PASSWORD='your_password'
& 'D:\KINGBASE\KESRealPro\V009R001C010\Server\bin\ksql.exe' -h localhost -p 54321 -U system -d smart_greenhouse -f '.\docs\database\smart_greenhouse_full_dump.sql'
```

The Spring Boot project also runs `backend/src/main/resources/db/kingbase/schema.sql` and `seed.sql` during startup under the `kingbase` profile.
