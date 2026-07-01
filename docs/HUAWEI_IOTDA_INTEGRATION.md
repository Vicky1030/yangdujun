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

当前硬件没有土壤温度、土壤湿度、pH 和 CO2 传感器时，后端不会再生成随机模拟值，而是按以下顺序处理：

```text
1. 华为云 reported/data 中如果有真实字段，优先使用真实字段
2. 如果华为云没有该字段，沿用该大棚上一条遥测记录中的值
3. 如果数据库中也没有历史值，才使用固定初始值
```

| 系统字段 | 支持的华为云字段 | 固定初始值 |
| --- | --- |
| `soil_temperature` | `SoilTemp` / `soilTemperature` / `soil_temperature` | 20.0 |
| `soil_humidity` | `SoilHumi` / `soilHumidity` / `soil_humidity` / `soil_moisture` | 60.0 |
| `ph_value` | `PH` / `Ph` / `pH` / `ph` / `phValue` / `ph_value` | 6.70 |
| `co2_ppm` | `CO2` / `co2` / `co2Ppm` / `co2_ppm` | 760 |

华为云拉到的新数据会覆盖该大棚当前最新一条 `telemetry_snapshot`，不会持续追加原来为演示生成的模拟记录。

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

## 定时主动拉取设备影子

如果不想使用公网回调或内网穿透，可以让 Java 后端定时调用华为云 IoTDA `ShowDeviceShadow` 接口，读取设备影子 reported 区中的最新属性。

华为云官方说明：

- 应用侧 Java SDK 使用 AK/SK 鉴权。
- `ShowDeviceShadow` 用于查询指定设备的设备影子，包括最新上报的 reported 属性。

启动后端前配置：

```powershell
$env:HUAWEI_IOT_PULL_ENABLED="true"
$env:HUAWEI_IOT_PULL_FIXED_DELAY_MS="60000"
$env:HUAWEI_IOT_PULL_DEVICE_IDS="6a3a6da1cbb0cf6bb96829a4_WHYwhy"

$env:HUAWEI_IOT_AK="你的华为云 Access Key ID"
$env:HUAWEI_IOT_SK="你的华为云 Secret Access Key"
$env:HUAWEI_IOT_PROJECT_ID="你的项目ID"
$env:HUAWEI_IOT_REGION_ID="cn-north-4"
$env:HUAWEI_IOT_ENDPOINT="https://你的IoTDA应用侧接入地址"
```

`REGION_ID` 和 `ENDPOINT` 在华为云 IoTDA 控制台的“总览 / 平台接入地址 / 应用侧”中查看。华为云文档示例中常见区域：

```text
北京四：cn-north-4
上海一：cn-east-3
华南广州：cn-south-1 / cn-south-4，按控制台实际显示为准
```

启动后端：

```powershell
cd backend
mvn -Pkingbase-driver spring-boot:run
```

后端会按 `HUAWEI_IOT_PULL_FIXED_DELAY_MS` 定时拉取设备影子，把 reported properties 转成项目现有格式后入库，并继续触发阈值告警。

手动测试一次拉取：

```powershell
Invoke-RestMethod `
  -Method Post `
  -Uri "http://localhost:8084/api/v1/iot/huawei/pull" `
  -Headers @{ "X-Huawei-Iot-Token" = "yangdujun-huawei-iot" }
```

指定设备：

```powershell
Invoke-RestMethod `
  -Method Post `
  -Uri "http://localhost:8084/api/v1/iot/huawei/pull?deviceId=6a3a6da1cbb0cf6bb96829a4_WHYwhy" `
  -Headers @{ "X-Huawei-Iot-Token" = "yangdujun-huawei-iot" }
```

如果你的 IoTDA 实例是基础版，且 SDK 报衍生认证相关错误，可尝试：

```powershell
$env:HUAWEI_IOT_DERIVED_AUTH="false"
```
