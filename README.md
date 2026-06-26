# 智慧羊肚菌大棚管理系统

这是基于 JavaWeb 工程化结构重构的智慧农业管理系统，面向管理员和农户两类角色，支持大棚管理、设备管理、环境监测、告警中心、批次溯源、用户资料、问题反馈、操作日志、登录注册和验证码流程。

## 技术栈

- 后端：Java 17、Spring Boot 3、Maven、MyBatis-Plus、Spring JDBC、Validation、AOP 日志、SpringDoc OpenAPI
- 数据库：KingbaseES（金仓数据库）
- 前端：Vue 3、Vite、Pinia、Vue Router、Element Plus、ECharts、Axios
- 扩展方向：硬件网关、短信验证码、邮箱验证码、实时采集数据、设备控制协议

## 项目结构

```text
backend/   Spring Boot REST API
frontend/  Vue 3 管理端与农户端界面
docs/      数据库和工程说明
```

## 本地运行

### 1. 准备金仓 JDBC 驱动

将 KingbaseES JDBC 驱动放到：

```text
backend/lib/kingbase8.jar
```

公开仓库不提交该 jar，请按 `backend/lib/README.md` 和 `docs/KINGBASE_SETUP.md` 自行放置。

### 2. 启动后端

```powershell
cd backend
mvn -Pkingbase-driver spring-boot:run
```

默认连接：

```text
jdbc:kingbase8://localhost:54321/smart_greenhouse
username: system
password: 123456
```

可以通过环境变量覆盖：

```powershell
$env:KINGBASE_URL="jdbc:kingbase8://localhost:54321/smart_greenhouse"
$env:KINGBASE_USERNAME="system"
$env:KINGBASE_PASSWORD="123456"
```

### 3. 启动前端

```powershell
cd frontend
npm install
npm run dev
```

访问地址：

```text
前端：http://localhost:5173
后端：http://localhost:8080/api/v1
健康检查：http://localhost:8080/api/v1/health
OpenAPI：http://localhost:8080/swagger-ui.html
```

## 默认账号

```text
管理员：admin / admin123
农户：farmer001 / 123456
```

## 验证码配置

邮箱验证码支持 SMTP 配置：

```powershell
$env:MAIL_HOST="smtp.example.com"
$env:MAIL_PORT="587"
$env:MAIL_USERNAME="verify@example.com"
$env:MAIL_PASSWORD="SMTP授权码"
$env:MAIL_FROM="verify@example.com"
```

短信验证码已预留服务扩展点，可接入华为云、阿里云、腾讯云等短信服务商。

## 说明

- 当前硬件联动使用模拟硬件网关，后续可替换为真实 MQTT/HTTP/串口网关。
- 管理员端支持新增大棚、新增设备并绑定大棚、告警明细查看。
- 个人中心的 IP 方位当前为本机/局域网识别，后续可接入 IP2Region 或地图服务商接口。