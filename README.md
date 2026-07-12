# 智慧羊肚菌大棚管理系统

这是一个面向羊肚菌大棚生产管理的 JavaWeb 实训项目。系统覆盖管理员端、农户端、AI 辅助诊断、华为云 IoTDA 硬件接入、数字孪生大屏、鸿蒙移动端和硬件端代码，适合用于展示完整的智慧农业业务闭环。

## 项目功能

- 管理员端：用户管理、大棚管理、设备管理、农户绑定、批次溯源、告警处理、反馈会话。
- 农户端：个人大棚看板、实时环境数据、设备状态、告警查看、反馈提交、个人资料维护。
- 环境监测：空气温度、空气湿度、土壤温度、土壤湿度、pH、CO2、光照强度七项指标。
- 告警闭环：环境阈值触发告警，管理员下发处理建议或设备命令，农户确认处理结果。
- AI 能力：Dify 页面嵌入，本地 `ai-service` 保留 RAG 问答、图像诊断和专家建议备用实现。
- 华为云 IoTDA：支持设备数据回调、设备影子主动拉取、设备命令下发。
- 数字孪生：Vue + Three.js 大棚可视化大屏。
- 扩展端：鸿蒙 App、硬件端 C 代码。

## 技术栈

| 模块 | 技术 |
| --- | --- |
| 后端 | Java 17, Spring Boot 3.3, Maven, JdbcTemplate, MyBatis-Plus, Validation, AOP, SpringDoc OpenAPI |
| 数据库 | KingbaseES V8, PostgreSQL 驱动兼容依赖 |
| 前端 | Vue 3, Vite, Pinia, Vue Router, Element Plus, ECharts, Axios |
| 前端测试 | Vitest, Vue Test Utils, jsdom, V8 Coverage |
| 后端测试 | JUnit 5, Spring Boot Test, Mockito, JaCoCo |
| AI 服务 | Python, FastAPI 风格本地服务, Ollama, ChromaDB |
| 数字孪生 | Vue 3, Three.js, Express, pg |
| 鸿蒙端 | ArkTS, DevEco Studio, Hypium |
| 硬件端 | C, WiFi, MQTT, DHT11, CO2, OLED, PWM, 舵机和电机控制 |

## 目录结构

```text
backend/        Spring Boot 后端服务
frontend/       Vue Web 前端
ai-service/     本地 AI 备用服务
digital-twin/   数字孪生前端和轻量后端
Harmony/        鸿蒙移动端和对应后端示例
Target side/    硬件端示例代码
docs/           数据库、华为云 IoTDA 和设计说明
```

## 环境准备

请提前安装：

- Java 17+
- Maven 3.8+
- Node.js 18+
- Python 3.11+
- KingbaseES V8
- 可选：Ollama、DevEco Studio、华为云 IoTDA 账号

默认数据库连接：

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
$env:GREENHOUSE_ADMIN_PASSWORD="admin123"
```

Kingbase 驱动已放在 `backend/vendor/maven` 本地 Maven 仓库中，后端使用 `kingbase-driver` profile 即可加载。

## 启动后端

```powershell
cd backend
mvn -Pkingbase-driver spring-boot:run
```

后端默认端口：

```text
http://localhost:8084
```

常用地址：

```text
API:     http://localhost:8084/api/v1
Health:  http://localhost:8084/api/v1/health
OpenAPI: http://localhost:8084/swagger-ui.html
```

启动时会自动执行：

```text
backend/src/main/resources/db/kingbase/schema.sql
backend/src/main/resources/db/kingbase/seed.sql
```

如果不希望自动初始化数据库，可设置：

```powershell
$env:GREENHOUSE_DB_INIT_ENABLED="false"
```

## 启动前端

```powershell
cd frontend
npm install
npm run dev
```

前端默认地址：

```text
http://localhost:3000
```

Vite 已配置 `/api` 代理到：

```text
http://localhost:8084
```

## 默认账号

```text
管理员：admin1 / admin123
农户：farmer001 / 123456
```

## 测试说明

本仓库已经包含 Web 前后端测试代码，满足课程提交要求中的测试代码目录要求。

### 后端测试

测试代码位置：

```text
backend/src/test/java
```

运行：

```powershell
cd backend
mvn test
```

测试报告：

```text
backend/target/surefire-reports
```

JaCoCo 覆盖率报告：

```text
backend/target/site/jacoco/index.html
```

当前验证结果：

```text
Tests run: 168, Failures: 0, Errors: 0, Skipped: 0
BUILD SUCCESS
```

当前 JaCoCo 覆盖率概况：

| 指标 | 覆盖率 |
| --- | ---: |
| 指令覆盖率 | 95.85% |
| 分支覆盖率 | 84.26% |
| 行覆盖率 | 94.98% |
| 方法覆盖率 | 97.60% |

主要覆盖内容：

- 认证、注册、登录、验证码、密码重置。
- 用户管理、资料更新、默认头像。
- 大棚查询、管理、统计分析。
- 设备命令、模拟硬件网关、华为云 IoTDA 命令转换。
- 华为云 IoTDA 数据接入、主动拉取、字段映射。
- AI 问答、摄像头截图诊断、本地 AI 客户端异常处理。
- Controller、统一返回、全局异常、安全拦截和操作日志。

### 前端测试

测试代码位置：

```text
frontend/src/**/*.test.js
```

运行：

```powershell
cd frontend
npm install
npm run test:coverage
```

Vitest 覆盖率报告：

```text
frontend/coverage/index.html
```

当前验证结果：

```text
Test Files: 8 passed
Tests:      24 passed
```

当前 Vitest Coverage 概况：

| 指标 | 覆盖率 |
| --- | ---: |
| 语句覆盖率 | 97.42% |
| 分支覆盖率 | 83.47% |
| 函数覆盖率 | 84.90% |
| 行覆盖率 | 97.42% |

主要覆盖内容：

- Axios 请求封装和 API service。
- 登录、注册、验证码、重置密码相关服务。
- Pinia 会话状态。
- 路由守卫。
- 主要页面组件 smoke test 和核心交互流程。

## 构建命令

后端打包：

```powershell
cd backend
mvn -Pkingbase-driver clean package
```

前端构建：

```powershell
cd frontend
npm install
npm run build
```

## AI 服务

当前 Web 页面主要以内嵌 Dify Chat 的方式提供 AI 入口。也可以配置本地备用 AI 服务。

启动本地 AI 服务：

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

后端默认读取：

```text
MOREL_AI_SERVICE_URL=http://127.0.0.1:18080
```

如需 Ollama 模型：

```powershell
ollama pull qwen3:4b-thinking
ollama pull minicpm-v:latest
```

导入知识库：

```powershell
cd ai-service
.\.venv\Scripts\python scripts\ingest_knowledge.py
```

## 华为云 IoTDA

相关文档：

```text
docs/HUAWEI_IOTDA_INTEGRATION.md
docs/HUAWEI_IOTDA_COMMANDS.md
```

后端支持：

- `POST /api/v1/iot/huawei/telemetry` 接收 IoTDA 数据转发。
- `POST /api/v1/iot/huawei/pull` 手动拉取设备影子。
- 定时拉取设备影子。
- 按设备序列号或默认设备 ID 绑定到大棚。
- 将硬件字段映射为系统七项环境指标。

常用环境变量：

```powershell
$env:HUAWEI_IOT_WEBHOOK_TOKEN="yangdujun-huawei-iot"
$env:HUAWEI_IOT_PULL_ENABLED="false"
$env:HUAWEI_IOT_COMMAND_ENABLED="false"
$env:HUAWEI_IOT_AK="你的 Access Key"
$env:HUAWEI_IOT_SK="你的 Secret Key"
$env:HUAWEI_IOT_PROJECT_ID="你的项目 ID"
$env:HUAWEI_IOT_ENDPOINT="你的 IoTDA 应用侧接入地址"
```

## 数字孪生

启动数字孪生后端：

```powershell
cd digital-twin\digital-twin-backend
npm install
npm start
```

启动数字孪生前端：

```powershell
cd digital-twin\digital-twin-frontend
npm install
npm run dev
```

如果不启动数字孪生后端，前端会回退到模拟数据。

## 鸿蒙端

鸿蒙工程位于：

```text
Harmony/
```

测试说明：

```text
Harmony/TESTING.md
```

可在 DevEco Studio 中打开 `Harmony` 目录，运行 `entry/src/test` 下的本地单元测试。

## 硬件端

硬件代码位于：

```text
Target side/
```

包含：

- `19-voice`：语音、LED、DHT11、超声波等示例。
- `21_huaweiiot`：WiFi、MQTT、DHT11、CO2、光照、OLED、PWM、舵机和电机控制。

## 数据库资料

数据库说明和快照位于：

```text
docs/database/
```

主要文件：

```text
docs/database/README.md
docs/database/smart_greenhouse_full_dump.sql
```

## 课程提交建议

如果只提交 Web 部分，至少应包含：

```text
backend/
frontend/
README.md
.gitignore
```

其中测试相关内容必须保留：

```text
backend/src/test/java
frontend/src/**/*.test.js
backend/pom.xml
frontend/package.json
frontend/vite.config.js
```

覆盖率截图建议分别打开以下文件后截图：

```text
backend/target/site/jacoco/index.html
frontend/coverage/index.html
```

如果重新克隆仓库，`target` 和 `coverage` 目录通常不会提交，需要先运行测试命令重新生成报告。

