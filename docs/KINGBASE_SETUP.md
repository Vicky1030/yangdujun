# KingbaseES 接入说明

当前工程已切换为 `kingbase` profile，后端启动时会使用金仓数据库作为主数据库。

## 1. 安装金仓数据库

请安装 KingbaseES V8，并创建数据库：

```sql
CREATE DATABASE smart_greenhouse;
```

默认连接参数：

```text
host: localhost
port: 54321
database: smart_greenhouse
username: system
password: 123456
```

也可以通过环境变量覆盖：

```powershell
$env:KINGBASE_URL="jdbc:kingbase8://localhost:54321/smart_greenhouse"
$env:KINGBASE_USERNAME="system"
$env:KINGBASE_PASSWORD="你的密码"
```

## 2. 放置 JDBC 驱动

将金仓安装目录中的 `kingbase8.jar` 复制到：

```text
backend/lib/kingbase8.jar
```

然后使用 profile 构建/运行：

```powershell
cd backend
mvn -Pkingbase-driver spring-boot:run
```

## 3. 初始化数据库

应用启动时会执行：

- `backend/src/main/resources/db/kingbase/schema.sql`
- `backend/src/main/resources/db/kingbase/seed.sql`

已包含 9 张业务表、索引、视图、触发器和更新时间函数，用于展示金仓数据库在业务系统中的高级能力。

## 4. 初始账号

管理员账号由应用启动时自动创建：

```text
username: admin
password: admin123
```

可通过环境变量修改初始密码：

```powershell
$env:GREENHOUSE_ADMIN_PASSWORD="新密码"
```
