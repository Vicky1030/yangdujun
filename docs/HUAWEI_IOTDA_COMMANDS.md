# 华为云 IoTDA 命令下发配置

本项目支持通过 Java 后端调用华为云 IoTDA 同步命令下发接口，让在线 MQTT 设备接收并执行 Web 端发出的控制指令。

## 当前设备模型

当前已对接的华为云设备信息：

```text
区域：华北-北京四
region_id：cn-north-4
应用侧接入地址：https://b95325cee1.st1.iotda-app.cn-north-4.myhuaweicloud.com
设备ID：6a3a6da1cbb0cf6bb96829a4_WHYwhy
产品ID：6a3a6da1cbb0cf6bb96829a4
设备标识码：WHYwhy
服务ID：王昊洋
```

产品模型中的命令映射：

| 业务含义 | command_name | 参数名 | 示例值 |
| --- | --- | --- | --- |
| 灯 | `Light` | `light` | `ON` / `OFF` |
| 风机档位 | `Fengdegree` | `fengdegree` | `0` / `5` |
| 挡光板 | `Board` | `board` | `ON` / `OFF` |
| 水泵 | `BUMP` | `bump` | `ON` / `OFF` |
| AI 预警 | `AIWarning` | `aiwarning` | `white_mold` |
| 通用状态 | `State` | `state` | `ON` / `OFF` |

## 后端环境变量

启动 Java 后端前配置：

```bash
export HUAWEI_IOT_COMMAND_ENABLED=true
export HUAWEI_IOT_AK="你的华为云 Access Key ID"
export HUAWEI_IOT_SK="你的华为云 Secret Access Key"
export HUAWEI_IOT_PROJECT_ID="华北-北京四项目ID"
export HUAWEI_IOT_REGION_ID="cn-north-4"
export HUAWEI_IOT_ENDPOINT="https://b95325cee1.st1.iotda-app.cn-north-4.myhuaweicloud.com"
export HUAWEI_IOT_DEFAULT_DEVICE_ID="6a3a6da1cbb0cf6bb96829a4_WHYwhy"
export HUAWEI_IOT_COMMAND_SERVICE_ID="王昊洋"
```

如果 IoTDA 实例要求 `instance_id`，再增加：

```bash
export HUAWEI_IOT_INSTANCE_ID="你的IoTDA实例ID"
```

本地 PowerShell 示例：

```powershell
$env:HUAWEI_IOT_COMMAND_ENABLED="true"
$env:HUAWEI_IOT_AK="你的华为云 Access Key ID"
$env:HUAWEI_IOT_SK="你的华为云 Secret Access Key"
$env:HUAWEI_IOT_PROJECT_ID="华北-北京四项目ID"
$env:HUAWEI_IOT_REGION_ID="cn-north-4"
$env:HUAWEI_IOT_ENDPOINT="https://b95325cee1.st1.iotda-app.cn-north-4.myhuaweicloud.com"
$env:HUAWEI_IOT_DEFAULT_DEVICE_ID="6a3a6da1cbb0cf6bb96829a4_WHYwhy"
$env:HUAWEI_IOT_COMMAND_SERVICE_ID="王昊洋"
```

## 设备绑定规则

后端会优先读取 `greenhouse_device.serial_no` 作为华为云 `device_id`。

如果设备档案没有填写 `serial_no`，后端会使用：

```text
HUAWEI_IOT_DEFAULT_DEVICE_ID
```

当前一个华为云设备代表一个大棚时，可以先只配置默认设备 ID。以后有多个大棚、多台硬件时，建议把每个本地设备的 `serial_no` 填成对应的华为云 `device_id`。

## 接口调用

登录后调用：

```text
POST /api/v1/greenhouses/devices/commands
Authorization: Bearer <token>
Content-Type: application/json
```

直接下发灯命令：

```json
{
  "deviceId": 1,
  "command": "Light",
  "value": "OFF"
}
```

直接下发风机档位：

```json
{
  "deviceId": 1,
  "command": "Fengdegree",
  "value": "5"
}
```

通用打开/关闭：

```json
{
  "deviceId": 1,
  "command": "START"
}
```

```json
{
  "deviceId": 1,
  "command": "STOP"
}
```

`START` / `STOP` 会根据本地设备类型自动映射：

| 本地设备类型 | START | STOP |
| --- | --- | --- |
| `VENTILATION_FAN` | `Fengdegree.fengdegree = 5` | `Fengdegree.fengdegree = 0` |
| `IRRIGATION_PUMP` | `BUMP.bump = ON` | `BUMP.bump = OFF` |
| 名称或类别包含 `light` / `lamp` | `Light.light = ON` | `Light.light = OFF` |
| 名称或类别包含 `board` | `Board.board = ON` | `Board.board = OFF` |
| 其他设备 | `State.state = ON` | `State.state = OFF` |

## 权限规则

- 农户只能控制自己绑定大棚中的设备。
- 管理员可以调用设备命令接口，也可以通过告警处置接口下发设备命令。
- 未开启 `HUAWEI_IOT_COMMAND_ENABLED` 时，项目仍使用 mock 网关，命令只记录日志，不会发送到华为云。

## 常见问题

1. 返回设备离线：设备没有在线，华为云会拒绝下发命令。
2. 返回超时：检查服务器网络、IoTDA 接入地址和设备在线状态。
3. 返回华为云服务错误：检查 AK/SK、project_id、endpoint、region_id、instance_id 是否正确。
4. 硬件能收到控制台命令但收不到 Web 命令：优先检查后端环境变量和 `service_id`、`command_name`、参数名是否与产品模型一致。
