# 羊肚菌专业 AI 助手设计

## 目标

在现有 JavaWeb 智慧大棚系统中接入一个本地运行的羊肚菌专业 AI。它能够基于羊肚菌生产规程 PDF、图片样本、Ollama 本地文本模型和视觉模型，为农户提供问答、图片诊断和环境数据综合建议，并为管理员生成可下发给农户的 AI 建议。

## 总体架构

采用“双服务”架构：

- Spring Boot 主系统继续负责登录鉴权、农户/管理员权限、大棚数据、告警、反馈消息、AI 会话持久化。
- Python `ai-service` 负责 PDF 知识库解析、向量检索、Ollama 文本/视觉模型调用、多专家编排和最终建议生成。

这样可以让 Java 主系统保持稳定，AI 能力独立演进。以后如果要换 Chroma、FAISS、Milvus 或更强模型，只需要替换 Python 服务内部实现。

## 本地模型与向量库

- 文本模型：`qwen3:4b-thinking`
- 图像模型：`minicpm-v:latest`
- 向量库：Chroma 本地持久化
- V1 嵌入策略：使用本地确定性 Hash Embedding，避免额外下载 embedding 模型；后续可升级为 Ollama embedding 模型或 BGE 类模型。

## 多专家协同

工程层面拆分为 5 类专家，不做底层 MoE 训练：

- 文本问答专家：理解农户问题，生成自然语言回答。
- 图像识别专家：分析羊肚菌照片，识别长势、病害、虫害、蛞蝓、白霉、蛛网状菌丝等风险。
- 环境数据分析专家：读取当前大棚温度、湿度、CO2、土壤湿度等传感器数据，判断是否偏离管理建议。
- 知识库检索专家：从地方标准、行业标准和技术规程中检索依据。
- 建议生成专家：把检索依据、图像识别、环境数据和用户问题整合为风险等级、诊断结论和可执行建议。

## 数据流

### 农户文本问答

1. 农户在 AI 助手输入问题。
2. Spring Boot 保存请求并调用 Python `/api/chat`。
3. Python 根据问题检索 Chroma。
4. Python 调用 `qwen3:4b-thinking` 生成回答。
5. Spring Boot 保存回答并返回前端。

### 农户图片诊断

1. 农户上传图片，可选择大棚。
2. Spring Boot 将图片转发给 Python `/api/vision-diagnosis`。
3. Python 调用 `minicpm-v:latest` 识别图片。
4. Python 检索相关知识库，并融合传感器摘要。
5. Python 调用文本模型生成最终诊断。
6. Spring Boot 保存诊断记录并返回前端。

### 自动巡检建议

V1 先保留后端定时任务入口和数据结构。后续可接入真实摄像头图片或定时抓拍目录，调用 Python 生成 `AI生成建议`，管理员确认后一键下发到农户反馈聊天。

## 存储设计

Spring Boot 增加以下表：

- `ai_conversation`：AI 会话。
- `ai_message`：AI 消息、图片诊断、模型输出。
- `ai_suggestion`：AI 生成建议，可由管理员下发。
- `ai_knowledge_document`：知识库文档登记。
- `ai_inspection_task`：自动巡检任务配置。

Python 服务本地持久化：

- `ai-service/data/chroma`：Chroma 向量库。
- `ai-service/data/uploads`：临时诊断图片。
- `ai-service/data/index_manifest.json`：知识库导入摘要。

## 权限

- 农户：只能使用自己的 AI 会话，只能带入自己绑定大棚的环境数据。
- 管理员：可查看 AI 建议，可下发 AI 建议给对应农户。
- AI 输出必须标注为“AI生成建议”，避免和人工处置混淆。

## V1 范围

本次优先实现：

- Python AI 服务脚手架。
- PDF 知识库导入到 Chroma。
- Ollama 文本问答和图片诊断接口。
- Spring Boot AI 接口代理与记录保存。
- 农户侧边栏 AI 助手页面。
- 管理员可查看 AI 建议并下发给农户。

暂不实现：

- 底层 MoE 模型训练。
- MLA 注意力机制。
- 真实摄像头 RTSP/WebRTC 接入。
- 大规模图片分类训练。
