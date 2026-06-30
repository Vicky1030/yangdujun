# Enterprise Workflow Upgrade Implementation Plan

**Goal:** Add farmer-first query workflows, alert command handling, farmer feedback chat, batch traceability details, and richer user management.

**Architecture:** Extend the existing Spring Boot + Kingbase schema with normalized binding, batch, and feedback chat tables. Expose pragmatic JSON endpoints from existing controllers, then wire Vue pages to real APIs with role-aware menus.

**Tech Stack:** Spring Boot, JdbcTemplate, Kingbase, Vue 3, Element Plus.

---

1. Add schema tables and seed-safe migrations for greenhouse binding, batches, feedback conversations, and feedback messages.
2. Add backend DTOs/services/endpoints for user CRUD, greenhouse binding, batch query/detail, feedback chat, and alert command handling.
3. Replace administrator overview and device query flow with farmer -> greenhouse drilldown.
4. Remove operation audit menu/page route.
5. Add farmer feedback chat page and searchable admin feedback page.
6. Replace traceability timeline with batch list/detail flow.
7. Verify with Maven package, Vite build, and local restart.
