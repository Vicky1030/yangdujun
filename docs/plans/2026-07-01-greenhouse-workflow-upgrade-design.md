# Smart Greenhouse Workflow Upgrade Design

## Goal

Upgrade the smart greenhouse project so telemetry, alert handling, traceability, farmer greenhouse creation, user binding management, AI assistant workflows, documentation, and release readiness match the current product requirements.

## Scope

- Expand greenhouse telemetry to seven metrics: air temperature, air humidity, soil temperature, soil humidity, pH, carbon dioxide, and light intensity.
- Update charts and summary cards that consume telemetry, device status, alert level/status, and batch counts.
- Clarify alert workflow: administrators can issue handling advice or device commands, while farmers complete and resolve alerts.
- Add traceability batch creation and batch event confirmation with image upload metadata.
- Let farmers create their own greenhouses and bind them automatically.
- Add administrator user search and farmer-greenhouse unbind operations.
- Make the AI assistant usable for both farmers and administrators, with longer client timeouts and better loading/error behavior.
- Refresh README and setup docs so another developer can clone, configure dependencies, pull local AI models, and run the full system.

## Architecture

The project keeps its existing modular structure. Spring Boot remains the authoritative API layer, KingbaseES remains the relational store, Vue remains the main console UI, and the Python FastAPI service remains the local AI bridge to Ollama and ChromaDB.

Changes should be made as incremental schema additions and service/controller extensions rather than a rewrite. Existing endpoints should remain compatible where possible, with new fields added to DTO records and new endpoints added only for genuinely new workflows.

## Data Model

Telemetry:

- Add `air_temperature`, `air_humidity`, `soil_temperature`, `soil_humidity`, and `ph_value` to `telemetry_snapshot`.
- Keep `co2_ppm` and `light_lux`.
- Backfill new columns from legacy `temperature`, `humidity`, and `soil_moisture` when available.
- Keep legacy columns temporarily for migration safety, but frontend/backend DTOs should expose the new metric names.

Traceability:

- Use existing `production_batch` and `production_batch_event`.
- Add or use `image_url` on `production_batch_event`.
- Add administrator confirmation metadata if missing: confirmed operator, confirmation time, and event status.

Bindings:

- Keep `farmer_greenhouse_binding` as the binding table.
- `greenhouse.owner_user_id` must be kept in sync with active binding.
- Unbinding sets the active binding deleted and clears `owner_user_id`.

AI:

- Do not commit Ollama model binaries.
- Commit code, sample knowledge documents if lightweight, `.env.example`, import scripts, and README instructions for pulling models.

## Backend Design

- Extend telemetry records and mappers:
  - `TelemetrySnapshot`
  - `TelemetryTrendPoint`
  - `KingbaseGreenhouseRepository`
  - `GreenhouseAnalyticsService`
  - `AiAssistantService`
  - `CameraSnapshotAiService`
- Add fixed category completion for analytics:
  - Device status always returns RUNNING, STOPPED, MAINTENANCE.
  - Alert level always returns INFO, WARNING, CRITICAL.
  - Alert status always returns OPEN, ACKNOWLEDGED, RESOLVED.
- Clarify alert service behavior:
  - Admin command endpoint records a command/advice and can move an OPEN alert to ACKNOWLEDGED.
  - Farmer handle endpoint can move an alert to RESOLVED only.
  - Admin cannot resolve.
- Add batch endpoints:
  - Create production batch.
  - Add/confirm production batch event.
  - Upload/store event image as URL/base64 metadata depending on current frontend approach.
- Add farmer greenhouse creation:
  - Farmers can call a create endpoint with no owner override.
  - Created greenhouse is bound to current farmer.
- Extend user service:
  - Query users by account, phone, email, and controlled greenhouse.
  - Unbind one greenhouse from a farmer.
  - Return enough binding details for the admin UI.
- Increase practical resilience for AI:
  - Surface AI service errors clearly.
  - Keep backend long timeout.

## Frontend Design

- Update all telemetry UI to seven metrics:
  - Farmer home metric cards.
  - Admin dashboard environment cards.
  - Farmer analytics strip and trend chart.
  - AI environment selection payload display where relevant.
- Fix analytics charts:
  - Device bar chart always includes stopped devices.
  - Alert chart uses clear colors and labels for INFO/WARNING/CRITICAL.
  - Batch summary shows total batch count instead of decorative dots.
- Alert page:
  - Admin sees command/advice action only.
  - Farmer sees resolve action only.
  - Copy explains OPEN, ACKNOWLEDGED, RESOLVED.
- Traceability page:
  - Fixed-card grid so one filtered card does not stretch across the row.
  - Admin can create a batch and add/confirm events with images.
  - Event operator defaults to current admin user.
- Device/greenhouse:
  - Farmer can add greenhouse from farmer workbench or device page.
  - Newly created greenhouse appears in selectors immediately.
- User admin:
  - Add search controls.
  - Add binding detail and unbind action.
- AI assistant:
  - Enter inserts newline; only send button sends.
  - Use local panel loading, not page-wide whitening.
  - Increase request timeout for AI endpoints.
  - Make same AI assistant route available to admins.
  - Fix suggestion labels when no greenhouse/farmer is bound.

## Validation

- Run backend compile.
- Run frontend build.
- Run Python AI service syntax check.
- Exercise key flows manually where possible:
  - Login as admin and farmer.
  - Create farmer greenhouse.
  - Bind and unbind greenhouse.
  - Query users by filters.
  - View analytics charts.
  - Issue admin alert command and resolve as farmer.
  - Create batch and add event.
  - Use AI chat and image diagnosis with AI service running or verify graceful errors when it is not running.

## Release Notes

README must explain:

- KingbaseES driver placement.
- Database env vars and initialization behavior.
- Backend startup.
- Frontend startup.
- AI service setup, virtualenv, dependency install, model pull commands, knowledge import.
- Digital twin startup and port conflict notes.
- Default demo accounts.

