# 华为云 IoTDA 数据接入说明

本项目支持通过华为云 IoTDA 规则引擎把硬件上报数据写入 Java 后端数据库。

## 接入链路

```text
硬件设备 -> 华为云 IoTDA -> 数据转发 HTTP/HTTPS -> Java 后端 -> Kingbase telemetry_snapshot
```

## 后端接收接口

```text
POST /api/v1/iot/huawei/telemetry
Header: X-Huawei-Iot-Token: yangdujun-huawei-iot
Content-Type: application/json
```

本地测试地址：

```text
http://localhost:8084/api/v1/iot/huawei/telemetry
```

正式部署到公网服务器后，在华为云 IoTDA 规则引擎中填写公网 HTTPS 地址。

## 当前设备映射

默认把华为云设备：

```text
6a3a6da1cbb0cf6bb96829a4_WHYwhy
```

映射到系统中的 `greenhouse_id = 1`。

如需修改，可在启动后端前设置环境变量：

```powershell
$env:HUAWEI_IOT_WEBHOOK_TOKEN="你的转发密钥"
$env:HUAWEI_IOT_DEFAULT_DEVICE_ID="6a3a6da1cbb0cf6bb96829a4_WHYwhy"
$env:HUAWEI_IOT_DEVICE_GREENHOUSE_MAP="6a3a6da1cbb0cf6bb96829a4_WHYwhy:1"
```

多设备示例：

```powershell
$env:HUAWEI_IOT_DEVICE_GREENHOUSE_MAP="deviceA:1,deviceB:2,deviceC:3"
```

也可以把华为云设备 ID 填到 `greenhouse_device.serial_no`，后端会按设备序列号查找所属大棚。

## 支持的 JSON

推荐让华为云转发时带上 `device_id`：

```json
{
  "device_id": "6a3a6da1cbb0cf6bb96829a4_WHYwhy",
  "serviceId": "王昊洋",
  "data": {
    "Temp": "29.02",
    "Humi": "54.05",
    "Lumi": "61",
    "Dist": "-1",
    "LampST": "OFF",
    "Fengd": 5
  }
}
```

如果华为云规则转发的数据里没有 `device_id`，后端会使用 `HUAWEI_IOT_DEFAULT_DEVICE_ID`。

## 字段映射

| 华为云字段 | 系统字段 | 说明 |
| --- | --- | --- |
| `Temp` | `air_temperature` / `temperature` | 空气温度 |
| `Humi` | `air_humidity` / `humidity` | 空气湿度 |
| `Lumi` | `light_lux` | 光照强度。0-100 的值会按百分比换算为 lux |
| `LampST` | 设备状态 | `ON` 为运行，其他为停止 |
| `Fengd` | 风机状态 | 大于 0 为运行，否则停止 |

当前硬件没有土壤温度、土壤湿度、pH 和 CO2 传感器，后端会生成合理模拟值：

| 系统字段 | 生成范围 |
| --- | --- |
| `soil_temperature` | 空气温度略低，限制在 16-24 摄氏度 |
| `soil_humidity` | 58%-70% |
| `ph_value` | 6.45-6.95 |
| `co2_ppm` | 680-900 ppm |

这些模拟值会随时间轻微波动，便于前端趋势图展示。后续接入真实传感器后，只需要在后端字段映射中改为读取真实字段即可。

## 本地测试命令

```powershell
$body = @'
{
  "serviceId": "王昊洋",
  "data": {
    "Temp": "29.02",
    "Humi": "54.05",
    "Lumi": "61",
    "Dist": "-1",
    "LampST": "OFF",
    "Fengd": 5
  }
}
'@

Invoke-RestMethod `
  -Method Post `
  -Uri http://localhost:8084/api/v1/iot/huawei/telemetry `
  -Headers @{ "X-Huawei-Iot-Token" = "yangdujun-huawei-iot" } `
  -ContentType "application/json; charset=utf-8" `
  -Body $body
```

成功后会返回写入后的七项环境指标，并且工作台和数据分析页面会读取到最新数据。
