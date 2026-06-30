# Role Feedback Device Polish Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Refine administrator/farmer responsibilities, feedback chat, account display, device ownership, alert handling, farmer analytics, and seed data.

**Architecture:** Keep Spring Boot as the authority for role permissions and ownership checks. Vue pages should show role-appropriate actions only, while the API still enforces permissions. Kingbase schema and seed data provide richer demo data without hard-coded UI states.

**Tech Stack:** Spring Boot 3, JdbcTemplate, KingbaseES, Maven, Vue 3, Vite, Element Plus, ECharts.

---

### Task 1: Account And Permission Model

**Files:**
- Modify: `backend/src/main/resources/db/kingbase/schema.sql`
- Modify: `backend/src/main/resources/db/kingbase/seed.sql`
- Modify: `backend/src/main/java/com/morel/greenhouse/config/DatabaseInitializer.java`
- Modify: `backend/src/main/java/com/morel/greenhouse/application/service/UserAccountService.java`
- Modify: `backend/src/main/java/com/morel/greenhouse/shared/security/ApiSecurityInterceptor.java`

**Steps:**
1. Add `allow_admin_delete BOOLEAN NOT NULL DEFAULT FALSE` to `app_user`.
2. Rename default `admin` to `admin1` during initialization and seed migration.
3. Include `allow_admin_delete` in profile and user list queries.
4. Prevent admin self-delete and admin deletion unless target allows it.
5. Make device mutations farmer-accessible with ownership checks in service; keep admin read-only.
6. Allow farmers to handle alerts for their bound greenhouses.

### Task 2: Feedback Chat For Both Roles

**Files:**
- Modify: `backend/src/main/resources/db/kingbase/schema.sql`
- Modify: `backend/src/main/java/com/morel/greenhouse/application/dto/FeedbackMessageRequest.java`
- Modify: `backend/src/main/java/com/morel/greenhouse/application/service/UserAccountService.java`
- Modify: `frontend/src/router/index.js`
- Replace/modify: `frontend/src/views/FarmerFeedbackView.vue`

**Steps:**
1. Add message type and image URL columns to `feedback_message`.
2. Allow admin to send messages into existing conversations.
3. For farmer, list administrators; for admin, list farmer conversations.
4. Add image message support with URL input/upload-style UI.
5. Rename route/menu to a shared feedback chat page.

### Task 3: UI Text, Layout, And Profile Cleanup

**Files:**
- Modify: `frontend/src/layouts/ConsoleLayout.vue`
- Modify: `frontend/src/views/ProfileView.vue`
- Modify: `frontend/src/views/DashboardView.vue`
- Modify: `frontend/src/views/TraceabilityView.vue`
- Modify: `frontend/src/styles/base.css`

**Steps:**
1. Remove the right-top IoT online pill.
2. Show current account username instead of display name fallback like System Admin.
3. Remove feedback form from profile for both roles.
4. Add admin profile switch for `allowAdminDelete`.
5. Fix dashboard traceability card so it shows a mini timeline/entry instead of a large isolated word.
6. Set global Element Plus confirm button text to Chinese where invoked locally.

### Task 4: Device, Alert, And User Admin Pages

**Files:**
- Modify: `frontend/src/views/DeviceView.vue`
- Modify: `frontend/src/views/AlertView.vue`
- Modify: `frontend/src/views/UserAdminView.vue`
- Modify: `frontend/src/views/FarmerHomeView.vue`

**Steps:**
1. Hide admin device create/edit/delete actions; show farmer create/edit/delete actions.
2. Ensure farmer device greenhouse dropdown only contains bound greenhouses.
3. Let farmers handle their alert center records.
4. Make farmer home cards navigate to target routes.
5. Make user management status a direct enable/disable action.
6. Add row double-click inline editing for common user fields.

### Task 5: Farmer Analytics And Rich Seed Data

**Files:**
- Modify: `frontend/src/router/index.js`
- Create: `frontend/src/views/FarmerAnalyticsView.vue`
- Modify: `frontend/src/layouts/ConsoleLayout.vue`
- Modify: `backend/src/main/resources/db/kingbase/seed.sql`

**Steps:**
1. Add farmer analytics route and sidebar entry.
2. Render ECharts panels for telemetry trend, device status, alerts, and batch distribution.
3. Seed extra greenhouses, devices, telemetry snapshots, alerts, and batches.
4. Build and run backend/frontend.
5. Validate admin login, farmer login, device permissions, feedback chat, alerts, and analytics.
