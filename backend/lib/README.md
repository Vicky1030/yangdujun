The project already carries the KingbaseES JDBC driver in its local Maven vendor repository:

```text
backend/vendor/maven/cn/com/kingbase/kingbase8/9.0.0/kingbase8-9.0.0.jar
```

Run the backend with the Kingbase driver profile:

```powershell
mvn -Pkingbase-driver spring-boot:run
```

`backend/lib/` is kept only for temporary local driver replacement during development.
