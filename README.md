# 羊肚菌智慧大棚管理系统

这是一个 JavaWeb 实训项目，面向管理员和农户两类角色，提供大棚管理、设备管理、七项环境数据监测、告警闭环、批次溯源、用户管理、反馈会话、本地 AI 问答与图片诊断、数字孪生大屏等功能。

## 技术栈

- 后端：Java 17、Spring Boot 3、Maven、JdbcTemplate、MyBatis-Plus、Validation、AOP、SpringDoc OpenAPI
- 数据库：KingbaseES V8
- 前端：Vue 3、Vite、Pinia、Vue Router、Element Plus、ECharts、Axios
- AI 服务：Python、FastAPI、ChromaDB、Ollama
- 数字孪生：Vue 3、Three.js、Express

## 项目结构

```text
backend/       Spring Boot REST API
frontend/      Vue 3 管理员端与农户端
ai-service/    本地 RAG 与图像诊断服务
digital-twin/  数字孪生大屏前端与轻量接口
docs/          数据库与设计说明
```

## 环境准备

1. 安装 Java 17、Maven、Node.js 18+、Python 3.11+。
2. 安装 KingbaseES V8，并创建数据库 `smart_greenhouse`。
3. 将 KingbaseES JDBC 驱动放到 `backend/lib/kingbase8.jar`。
4. 如需 AI 功能，安装 Ollama。

## 启动数据库与后端

默认数据库连接：

```text
jdbc:kingbase8://localhost:54321/smart_greenhouse
username: system
password: 123456
```

可用环境变量覆盖：

```powershell
$env:KINGBASE_URL="jdbc:kingbase8://localhost:54321/smart_greenhouse"
$env:KINGBASE_USERNAME="system"
$env:KINGBASE_PASSWORD="123456"
$env:GREENHOUSE_ADMIN_PASSWORD="admin123"
```

启动后端：

```powershell
cd backend
mvn -Pkingbase-driver spring-boot:run
```

后端启动时会自动执行：

- `backend/src/main/resources/db/kingbase/schema.sql`
- `backend/src/main/resources/db/kingbase/seed.sql`

访问：

```text
API: http://localhost:8084/api/v1
Health: http://localhost:8084/api/v1/health
OpenAPI: http://localhost:8084/swagger-ui.html
```

## 启动前端

```powershell
cd frontend
npm install
npm run dev
```

默认访问：

```text
http://localhost:3000
```

Vite 会把 `/api` 代理到 `http://localhost:8084`。

## 启动 AI 服务

模型文件不提交到 GitHub，需要在本机通过 Ollama 拉取：

```powershell
ollama pull qwen3:4b-thinking
ollama pull minicpm-v:latest
```

启动服务：

```powershell
cd ai-service
python -m venv .venv
.\.venv\Scripts\pip install -r requirements.txt
.\.venv\Scripts\python -m app.main
```

默认地址：

```text
http://localhost:18080
```

后端默认通过 `MOREL_AI_SERVICE_URL=http://127.0.0.1:18080` 调用 AI 服务。

知识库导入：

```powershell
cd ai-service
.\.venv\Scripts\python scripts\ingest_knowledge.py
```

如需指定知识库目录：

```powershell
$env:MOREL_AI_KNOWLEDGE_DIR="D:\your\knowledge"
```

## 数字孪生大屏

数字孪生后端默认使用 8080；Java 后端默认使用 8084。如 8080 被占用，可改端口启动：

```powershell
cd digital-twin\digital-twin-backend
npm install
$env:BACKEND_PORT="18081"
npm start
```

前端：

```powershell
cd digital-twin\digital-twin-frontend
npm install
npm run dev
```

如果不启动数字孪生后端，前端会回退到模拟数据。

## 默认账号

```text
管理员：admin1 / admin123
农户：farmer001 / 123456
```

## 当前核心业务规则

- 环境数据包含七项：空气温度、空气湿度、土壤温度、土壤湿度、pH 值、二氧化碳、光照强度。
- 管理员可管理用户、大棚、绑定关系、批次和 AI 建议。
- 农户可创建自己的大棚，创建后自动绑定当前农户。
- 告警流程为：待处理 -> 管理员已下发建议 -> 农户已解决。
- 管理员不能直接解决告警，只能下发处置建议或设备命令。
- 批次链路节点由管理员确认，可填写说明并附图片地址。

## 构建验证

```powershell
cd backend
mvn -q -DskipTests compile

cd ..\frontend
npm run build

cd ..\ai-service
python -m py_compile app/main.py app/schemas.py app/settings.py app/experts.py app/knowledge_base.py app/ollama_client.py app/embeddings.py
```
