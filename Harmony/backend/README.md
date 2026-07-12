# Smart Greenhouse Backend

This is a small local HTTP bridge for the HarmonyOS app.

Flow:

```text
HarmonyOS app -> http://<your-pc-ip>:8080 -> KingbaseES
```

## 1. Add KingbaseES driver

Copy `kingbase8.jar` to:

```text
backend/lib/kingbase8.jar
```

## 2. Configure database

PowerShell:

```powershell
$env:KINGBASE_URL="jdbc:kingbase8://<host>:<port>/<database>"
$env:KINGBASE_USERNAME="<database-user>"
$env:KINGBASE_PASSWORD="<database-password>"
```

## 3. Configure Huawei Cloud

The HarmonyOS app calls this backend proxy. IoT data and commands require
environment variables on the backend.

PowerShell:

```powershell
$env:HUAWEI_IOT_USERNAME="<huawei-username>"
$env:HUAWEI_IOT_PASSWORD="<huawei-password>"
$env:HUAWEI_IOT_DOMAIN="<huawei-domain>"
$env:HUAWEI_IOT_PROJECT_NAME="cn-north-4"
$env:HUAWEI_IOT_PROJECT_ID="<huawei-project-id>"
$env:HUAWEI_IOT_DEVICE_ID="<huawei-device-id>"
$env:HUAWEI_IOT_SERVICE_ID="<huawei-service-id>"
$env:HUAWEI_IOTDA_ENDPOINT="https://<iotda-endpoint>"
```

DeepSeek is optional. Configure it only when AI chat or suggestions are needed:

```powershell
$env:DEEPSEEK_API_KEY="<deepseek-api-key>"
```

You can copy `backend/.env.example.ps1` to `backend/.env.local.ps1` for local
development. Do not commit real credentials.

## 4. Run

```powershell
cd <repo>\backend
.\run.ps1
```

## 5. Test

```powershell
Invoke-RestMethod http://localhost:8080/health
Invoke-RestMethod http://localhost:8080/db/health
```

The HarmonyOS app should use:

```text
http://<your-pc-ip>:8080
```

Replace `<your-pc-ip>` with your current computer IP if it changes.
