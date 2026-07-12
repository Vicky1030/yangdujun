# Testing Guide

## Backend

The backend unit tests use JUnit 5 and JaCoCo.

Run tests:

```powershell
cd E:\work\backend
mvn test
```

Run tests and enforce the coverage gate:

```powershell
cd E:\work\backend
mvn verify
```

Coverage report:

```text
backend/target/site/jacoco/index.html
```

Covered backend areas:

- JSON escaping and extraction helpers
- Authentication input validation
- Authentication pure helpers, including password matching and hash normalization
- Authentication database success paths for login, register, reset password, and profile update
- Password reset input validation
- Greenhouse threshold input validation
- Greenhouse threshold parsing, device classification, status labels, and numeric boundary helpers
- Greenhouse database success paths for health check, table listing, greenhouse listing, sensor latest/history, devices, alarms, feedback, create/delete greenhouse, and threshold saving
- HTTP helper behavior for CORS, query parameters, request body reading, and JSON response writing
- Huawei Cloud shadow parsing and device command normalization
- DeepSeek empty-input and missing-key fallback behavior

The JaCoCo HTML report keeps all backend classes visible. The strict `mvn verify` coverage gate focuses on service and utility code, and excludes startup/driver/HTTP shell classes from the hard threshold:

- `BackendApplication`
- `Database`
- `ApiServer`

This keeps the coverage gate aligned with unit-test scope. Real KingbaseES connectivity, full HTTP route integration, Huawei Cloud network calls, and DeepSeek network calls should be proven with integration-test screenshots or manual verification records.

Current backend verification command:

```text
mvn verify
```

Expected result:

```text
Tests run: 47, Failures: 0, Errors: 0, Skipped: 0
All coverage checks have been met.
BUILD SUCCESS
```

## HarmonyOS Entry Module

The HarmonyOS local unit tests use `@ohos/hypium`.

Run in DevEco Studio:

```text
1. Open E:\work.
2. Open entry/src/test/List.test.ets.
3. Run the local unit test suite.
4. Use Run with Coverage if DevEco Studio offers it.
```

Covered mobile areas:

- Phone and password validation
- Register, login, logout, reset password, and profile update
- Sensor data fallback and update behavior
- Threshold read and update behavior
- History size limit
- Feedback validation
- Device status updates
- Fan gear boundary handling
- Device command construction
- Alarm lookup, handling, and suggested actions
- Page route constants
- Backend endpoint constants
