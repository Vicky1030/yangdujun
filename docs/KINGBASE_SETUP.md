# KingbaseES 接入说明

## 1. 安装并创建数据库

安装 KingbaseES V8 后创建数据库：

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

环境变量覆盖：

```powershell
$env:KINGBASE_URL="jdbc:kingbase8://localhost:54321/smart_greenhouse"
$env:KINGBASE_USERNAME="system"
$env:KINGBASE_PASSWORD="你的密码"
```

## 2. JDBC 驱动说明

正常联网构建时，直接使用 `kingbase-driver` Profile 启动即可。Maven 会自动解析 KingbaseES JDBC 驱动，无需将 jar 放入项目目录：

```powershell
cd backend
mvn -Pkingbase-driver spring-boot:run
```

仅在离线或受限网络环境下，才需要从 KingbaseES 安装目录取得 `kingbase8.jar` 并安装到本机 Maven 仓库，或按组织内部 Maven 仓库规范提供该依赖。公开仓库不提交 JDBC 驱动 jar。

## 3. 启动后端

```powershell
cd backend
mvn -Pkingbase-driver spring-boot:run
```

应用启动时会自动执行：

```text
backend/src/main/resources/db/kingbase/schema.sql
backend/src/main/resources/db/kingbase/seed.sql
```

## 4. 初始化内容

启动后会创建或更新：

- 用户、角色、权限、会话表
- 大棚、设备、七项环境数据、告警表
- 反馈会话表
- 生产批次和批次链路表
- AI 会话、消息、建议和摄像头抓拍表
- 示例管理员和农户数据

默认账号：

```text
管理员：admin1 / admin123
农户：farmer001 / 123456
```

可通过环境变量修改管理员初始密码：

```powershell
$env:GREENHOUSE_ADMIN_PASSWORD="新密码"
```
