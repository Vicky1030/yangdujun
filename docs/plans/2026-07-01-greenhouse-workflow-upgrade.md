# Greenhouse Workflow Upgrade Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Upgrade telemetry, alert workflow, traceability, greenhouse binding, AI assistant, documentation, and release readiness for the smart greenhouse project.

**Architecture:** Keep the current Spring Boot API, KingbaseES schema, Vue console, and FastAPI AI service. Extend existing DTOs, SQL, services, and views in place, adding new endpoints only where the product workflow needs new write operations.

**Tech Stack:** Java 17, Spring Boot 3.3, Maven, JdbcTemplate, KingbaseES, Vue 3, Vite, Pinia, Element Plus, ECharts, Python FastAPI, ChromaDB, Ollama.

---

### Task 1: Telemetry Schema and DTOs

**Files:**
- Modify: `backend/src/main/resources/db/kingbase/schema.sql`
- Modify: `backend/src/main/resources/db/kingbase/seed.sql`
- Modify: `backend/src/main/java/com/morel/greenhouse/domain/telemetry/TelemetrySnapshot.java`
- Modify: `backend/src/main/java/com/morel/greenhouse/application/dto/TelemetryTrendPoint.java`
- Modify: `backend/src/main/java/com/morel/greenhouse/infrastructure/repository/KingbaseGreenhouseRepository.java`
- Modify: `backend/src/main/java/com/morel/greenhouse/infrastructure/repository/MockGreenhouseRepository.java`
- Modify: `backend/src/main/java/com/morel/greenhouse/application/service/GreenhouseAnalyticsService.java`

**Steps:**
1. Add telemetry columns for air temperature, air humidity, soil temperature, soil humidity, and pH.
2. Backfill new columns from legacy values.
3. Extend Java records and mappers.
4. Update analytics trend queries and synthetic data generation.
5. Run `mvn -q -DskipTests compile`.

### Task 2: Analytics Category Completion

**Files:**
- Modify: `backend/src/main/java/com/morel/greenhouse/application/service/GreenhouseAnalyticsService.java`
- Modify: `frontend/src/views/FarmerAnalyticsView.vue`

**Steps:**
1. Ensure device status groups include RUNNING, STOPPED, MAINTENANCE.
2. Ensure alert level groups include INFO, WARNING, CRITICAL.
3. Ensure alert status groups include OPEN, ACKNOWLEDGED, RESOLVED.
4. Update ECharts options for readable device and alert charts.
5. Run frontend build.

### Task 3: Alert Workflow

**Files:**
- Modify: `backend/src/main/java/com/morel/greenhouse/application/service/GreenhouseManagementService.java`
- Modify: `backend/src/main/java/com/morel/greenhouse/shared/security/ApiSecurityInterceptor.java`
- Modify: `frontend/src/views/AlertView.vue`
- Modify: `frontend/src/views/DashboardView.vue`
- Modify: `frontend/src/views/FarmerHomeView.vue`

**Steps:**
1. Restrict alert resolution to farmers.
2. Let admin command/advice mark OPEN alerts as ACKNOWLEDGED.
3. Update UI copy and actions.
4. Update summary cards and active alert calculations.
5. Compile backend and build frontend.

### Task 4: Traceability Writes and Stable Cards

**Files:**
- Create: `backend/src/main/java/com/morel/greenhouse/application/dto/CreateBatchRequest.java`
- Create: `backend/src/main/java/com/morel/greenhouse/application/dto/CreateBatchEventRequest.java`
- Modify: `backend/src/main/java/com/morel/greenhouse/interfaces/controller/GreenhouseController.java`
- Modify: `backend/src/main/java/com/morel/greenhouse/application/service/GreenhouseQueryService.java`
- Modify: `backend/src/main/java/com/morel/greenhouse/application/service/GreenhouseManagementService.java`
- Modify: `backend/src/main/resources/db/kingbase/schema.sql`
- Modify: `frontend/src/services/greenhouse.js`
- Modify: `frontend/src/views/TraceabilityView.vue`

**Steps:**
1. Add batch create and event create/confirm endpoints.
2. Store current admin username as operator.
3. Add image URL/base64 metadata support for events.
4. Fix card grid sizing with fixed tracks.
5. Add admin forms for batch and event creation.
6. Verify compile/build.

### Task 5: Farmer Greenhouse Creation and Admin Binding

**Files:**
- Modify: `backend/src/main/java/com/morel/greenhouse/interfaces/controller/GreenhouseController.java`
- Modify: `backend/src/main/java/com/morel/greenhouse/interfaces/controller/UserController.java`
- Modify: `backend/src/main/java/com/morel/greenhouse/application/service/GreenhouseManagementService.java`
- Modify: `backend/src/main/java/com/morel/greenhouse/application/service/UserAccountService.java`
- Modify: `backend/src/main/java/com/morel/greenhouse/shared/security/ApiSecurityInterceptor.java`
- Modify: `frontend/src/services/greenhouse.js`
- Modify: `frontend/src/services/user.js`
- Modify: `frontend/src/views/FarmerHomeView.vue`
- Modify: `frontend/src/views/DeviceView.vue`
- Modify: `frontend/src/views/UserAdminView.vue`

**Steps:**
1. Permit farmer greenhouse creation through a scoped endpoint.
2. Bind farmer-created greenhouse to current farmer.
3. Add user search filters.
4. Add unbind greenhouse action.
5. Update UI selectors after create/unbind.
6. Verify compile/build.

### Task 6: AI Assistant Fixes and Admin Access

**Files:**
- Modify: `frontend/src/services/http.js`
- Modify: `frontend/src/services/ai.js`
- Modify: `frontend/src/router/index.js`
- Modify: `frontend/src/layouts/ConsoleLayout.vue`
- Modify: `frontend/src/views/AiAssistantView.vue`
- Modify: `frontend/src/views/AiSuggestionAdminView.vue`
- Modify: `backend/src/main/java/com/morel/greenhouse/application/service/AiAssistantService.java`
- Modify: `backend/src/main/java/com/morel/greenhouse/application/service/CameraSnapshotAiService.java`
- Modify: `ai-service/app/settings.py`

**Steps:**
1. Increase AI request timeout on the frontend.
2. Use local component loading instead of full-page loading.
3. Keep Enter as newline and send only by button.
4. Allow admins to use AI assistant route.
5. Fix suggestion display for unbound greenhouse/farmer.
6. Add env-friendly knowledge directory default.
7. Verify Python syntax and frontend build.

### Task 7: Cleanup

**Files:**
- Inspect all changed backend, frontend, AI, and digital twin files.

**Steps:**
1. Remove obsolete frontend cleanup helpers where no longer needed.
2. Remove unused imports and dead functions.
3. Do not delete working modules only because they are optional.
4. Run `rg` for TODO/FIXME/debugger and unused obvious artifacts.

### Task 8: Documentation and GitHub Release

**Files:**
- Modify: `README.md`
- Modify: `backend/lib/README.md`
- Modify: `ai-service/README.md`
- Modify: `docs/KINGBASE_SETUP.md`
- Add if useful: `ai-service/.env.example`

**Steps:**
1. Update startup instructions for database, backend, frontend, AI service, and digital twin.
2. Document Ollama model pull commands instead of committing model files.
3. Document knowledge import.
4. Run final validation commands.
5. Review git diff.
6. Commit and push to the configured GitHub remote.

