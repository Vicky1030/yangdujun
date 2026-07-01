# Morel AI Assistant Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a local multimodal RAG AI assistant for morel greenhouse farmers and administrators.

**Architecture:** Keep Spring Boot as the business system and add a local Python FastAPI AI service for PDF ingestion, Chroma retrieval, Ollama text reasoning, and MiniCPM-V image diagnosis. Spring Boot records conversations and suggestions, enforces permissions, and exposes Vue-facing APIs.

**Tech Stack:** Spring Boot 3, JDBC, Kingbase, Vue 3, Element Plus, Python FastAPI, Chroma, pypdf, Ollama HTTP API.

---

### Task 1: Python AI Service Skeleton

**Files:**
- Create: `ai-service/requirements.txt`
- Create: `ai-service/app/main.py`
- Create: `ai-service/app/settings.py`
- Create: `ai-service/app/schemas.py`
- Create: `ai-service/README.md`

**Steps:**
1. Create FastAPI app with `/health`.
2. Add configuration for Ollama base URL, text model, vision model, Chroma path, and knowledge path.
3. Add request/response schemas for chat, vision diagnosis, and indexing.
4. Verify with `python -m compileall ai-service/app`.

### Task 2: Knowledge Base Indexing

**Files:**
- Create: `ai-service/app/embeddings.py`
- Create: `ai-service/app/knowledge_base.py`
- Create: `ai-service/scripts/ingest_knowledge.py`

**Steps:**
1. Parse PDFs with pypdf.
2. Split text into chunks.
3. Generate deterministic hash embeddings.
4. Store chunks in Chroma.
5. Provide `/api/index/rebuild` and `/api/search`.

### Task 3: Ollama Expert Services

**Files:**
- Create: `ai-service/app/ollama_client.py`
- Create: `ai-service/app/experts.py`

**Steps:**
1. Implement text generation via `/api/generate`.
2. Implement image generation call with base64 image payload.
3. Build knowledge retrieval expert, vision expert, environment expert, and suggestion expert.
4. Return structured result with risk level, diagnosis, actions, and references.

### Task 4: Spring Boot AI Backend

**Files:**
- Create: `backend/src/main/java/com/morel/greenhouse/application/dto/AiChatRequest.java`
- Create: `backend/src/main/java/com/morel/greenhouse/application/dto/AiDiagnosisRequest.java`
- Create: `backend/src/main/java/com/morel/greenhouse/application/service/AiAssistantService.java`
- Create: `backend/src/main/java/com/morel/greenhouse/infrastructure/ai/AiServiceClient.java`
- Create: `backend/src/main/java/com/morel/greenhouse/interfaces/controller/AiController.java`
- Modify: `backend/src/main/resources/db/kingbase/schema.sql`
- Modify: `backend/src/main/resources/application.yml`

**Steps:**
1. Add AI tables to schema.
2. Add AI service URL config.
3. Implement HTTP client using `RestClient`.
4. Implement chat and diagnosis APIs.
5. Persist requests and responses.

### Task 5: Vue AI Assistant

**Files:**
- Create: `frontend/src/services/ai.js`
- Create: `frontend/src/views/AiAssistantView.vue`
- Modify: `frontend/src/router/index.js`
- Modify: `frontend/src/layouts/ConsoleLayout.vue`

**Steps:**
1. Add AI service functions.
2. Add farmer AI assistant page.
3. Support text chat and image upload.
4. Add sidebar item.
5. Display risk level, actions, references, and model trace.

### Task 6: Admin AI Suggestions

**Files:**
- Create: `frontend/src/views/AiSuggestionAdminView.vue`
- Modify: `frontend/src/services/ai.js`
- Modify: `frontend/src/router/index.js`
- Modify: `frontend/src/layouts/ConsoleLayout.vue`
- Modify: `backend/src/main/java/com/morel/greenhouse/application/service/AiAssistantService.java`
- Modify: `backend/src/main/java/com/morel/greenhouse/interfaces/controller/AiController.java`

**Steps:**
1. Add suggestion list API.
2. Add admin suggestions page.
3. Implement downlink to farmer feedback chat with “AI生成建议” prefix.
4. Verify admin can send and farmer can see message.

### Task 7: Verification

**Commands:**
- `python -m compileall ai-service/app`
- `mvn -Pkingbase-driver -DskipTests clean package`
- `npm.cmd run build`
- Manual: login as farmer, open AI assistant, ask a text question, upload a sample image.
- Manual: login as admin, open AI suggestions, downlink a suggestion.
