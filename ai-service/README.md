# 羊肚菌本地 AI 服务

该服务为主系统提供本地 RAG、文本问答、图片诊断和专家建议生成能力。

## 模型准备

模型本体不提交到 GitHub。请在本机安装 Ollama 后执行：

```powershell
ollama pull qwen3:4b-thinking
ollama pull minicpm-v:latest
```

默认模型：

- 文本模型：`qwen3:4b-thinking`
- 视觉模型：`minicpm-v:latest`

可通过环境变量覆盖：

```powershell
$env:MOREL_AI_TEXT_MODEL="qwen3:4b-thinking"
$env:MOREL_AI_VISION_MODEL="minicpm-v:latest"
$env:MOREL_AI_OLLAMA_BASE_URL="http://localhost:11434"
```

## 启动

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

## 知识库导入

默认读取 `ai-service/knowledge`。也可以通过环境变量指定目录：

```powershell
$env:MOREL_AI_KNOWLEDGE_DIR="D:\your\knowledge"
.\.venv\Scripts\python scripts\ingest_knowledge.py
```

ChromaDB 索引默认保存在 `ai-service/data/chroma`。

## 接口

```text
GET  /health
POST /api/index/rebuild
POST /api/search
POST /api/chat
POST /api/vision-diagnosis
```
