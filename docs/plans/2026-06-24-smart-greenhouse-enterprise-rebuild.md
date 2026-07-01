# Smart Greenhouse Enterprise Rebuild Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build an enterprise-style JavaWeb system for the Smart Morel Greenhouse prototype with Spring Boot backend and Vue 3 frontend.

**Architecture:** Use a front-end/back-end separated monorepo. The backend exposes versioned REST APIs with layered controller/application/domain/infrastructure packages and in-memory adapters for now. The frontend is a Vue 3 operational console with router, Pinia state, API client, and reusable dashboard components.

**Tech Stack:** Java 17, Spring Boot 3, Maven, MyBatis-Plus, validation, OpenAPI, Vue 3, Vite, Pinia, Vue Router, Element Plus, ECharts, Axios.

---

### Task 1: Project Foundation

**Files:**
- Create: `README.md`
- Create: `.gitignore`
- Create: `backend/pom.xml`
- Create: `frontend/package.json`

**Steps:**
1. Create a backend Maven project with enterprise dependencies.
2. Create a Vue 3 frontend project with Vite and operational UI dependencies.
3. Document local run commands and architecture.
4. Verify with `mvn -v`, `npm -v`, and dependency installation.

### Task 2: Backend Architecture

**Files:**
- Create: `backend/src/main/java/com/morel/greenhouse/GreenhouseApplication.java`
- Create: backend packages under `interfaces`, `application`, `domain`, `infrastructure`, `config`, `shared`.
- Create: `backend/src/main/resources/application.yml`

**Steps:**
1. Add unified API response and global exception handler.
2. Add domain models for greenhouse, telemetry, devices, alerts, traceability, and users.
3. Add application services backed by in-memory repositories.
4. Add REST controllers under `/api/v1`.
5. Leave MyBatis-Plus mapper structure ready but do not connect a database.

### Task 3: Frontend Architecture

**Files:**
- Create: `frontend/src/main.js`
- Create: `frontend/src/App.vue`
- Create: `frontend/src/router/index.js`
- Create: `frontend/src/stores/session.js`
- Create: `frontend/src/services/http.js`
- Create: `frontend/src/views/*.vue`
- Create: `frontend/src/styles/*.css`

**Steps:**
1. Build login shell and authenticated app layout.
2. Create redesigned operational pages for dashboard, devices, alerts, traceability, and profile.
3. Add API services for backend mock endpoints.
4. Use responsive, polished, utilitarian visual design.

### Task 4: Integration and Verification

**Files:**
- Modify: `frontend/vite.config.js`
- Modify: `backend/src/main/resources/application.yml`

**Steps:**
1. Proxy `/api` from Vite to Spring Boot.
2. Build backend with Maven.
3. Build frontend with Vite.
4. Start backend at `8084` and frontend at `5173`.
5. Verify the main UI and API health endpoint.
