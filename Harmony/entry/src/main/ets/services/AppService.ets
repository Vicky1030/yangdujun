import {
  AiSuggestionModel,
  AlarmRecord,
  Device,
  EnvironmentPoint,
  Greenhouse,
  SensorData,
  SettingItem,
  ThresholdConfig,
  User
} from '../models/AppModels';
import { AppState } from '../storage/AppState';
import { SecureIntegrationService } from './SecureIntegrationService';

export interface DeviceCommandAction {
  deviceType: string;
  commandName: string;
  value: string | number | boolean;
  stateKey: string;
  enabled?: boolean;
  fanGear?: number;
}

export class AppService {
  // 返回: true=成功, false=密码错误, 'unreachable'=后端不通
  static async login(phone: string, password: string): Promise<boolean | 'unreachable'> {
    // 先查后端健康状态
    const healthy = await SecureIntegrationService.checkHealth();
    if (!healthy) {
      return 'unreachable';
    }
    const user = await SecureIntegrationService.loginFarmer(phone, password);
    if (!user) {
      return false;
    }
    AppState.setCurrentUser(user);
    return true;
  }

  static async register(phone: string, password: string): Promise<boolean> {
    return SecureIntegrationService.registerFarmer(phone, password);
  }

  static async resetPassword(phone: string, newPassword: string): Promise<boolean> {
    return SecureIntegrationService.resetFarmerPassword(phone, newPassword);
  }

  static logout(): void {
    AppState.logout();
  }

  static updateCurrentUser(nickname: string, avatar: string = ''): boolean {
    return AppState.updateUserInfo(nickname, avatar);
  }

  static async updateProfileToDatabase(nickname: string, phone: string, avatar: string = ''): Promise<boolean> {
    const user = AppState.currentUser;
    if (!user) {
      return false;
    }
    const updated = await SecureIntegrationService.updateDatabaseProfile(user.id, nickname, phone, avatar);
    if (updated) {
      user.nickname = updated.nickname || user.nickname;
      user.phone = updated.phone || user.phone;
      user.avatar = updated.avatar || user.avatar;
      AppState.setCurrentUser(user);
      return true;
    }
    return false;
  }

  static getCurrentUser(): User | null {
    return AppState.currentUser;
  }

  static getGreenhouses(): Greenhouse[] {
    return AppState.greenhouses;
  }

  static async refreshGreenhousesFromDatabase(): Promise<Greenhouse[]> {
    const userId = AppState.currentUser ? AppState.currentUser.id : '';
    const greenhouses = await SecureIntegrationService.fetchDatabaseGreenhouses(userId);
    if (greenhouses.length > 0) {
      AppState.greenhouses = greenhouses;
    }
    return AppState.greenhouses;
  }

  static addGreenhouse(name: string, location: string, area: string): Greenhouse {
    const greenhouse: Greenhouse = {
      id: `greenhouse-${Date.now()}`,
      name,
      location,
      area,
      stage: '\u51fa\u83c7\u7ba1\u7406\u671f'
    };
    AppState.greenhouses.push(greenhouse);
    AppState.updateSensorData(greenhouse.id, AppState.getSensorData('default'));
    AppService.syncDevicesFromSensor(greenhouse.id, AppState.getSensorData(greenhouse.id));
    return greenhouse;
  }

  static async addGreenhouseToDatabase(name: string, location: string, area: string): Promise<Greenhouse> {
    const userId = AppState.currentUser ? AppState.currentUser.id : '';
    const greenhouses = await SecureIntegrationService.createDatabaseGreenhouse(userId, name, location, area);
    if (greenhouses.length > 0) {
      AppState.greenhouses = greenhouses;
      return AppState.greenhouses[AppState.greenhouses.length - 1];
    }
    throw new Error('greenhouse create failed');
  }

  static removeGreenhouse(greenhouseId: string): void {
    AppState.greenhouses = AppState.greenhouses.filter((item: Greenhouse) => item.id !== greenhouseId);
    AppState.devices = AppState.devices.filter((item: Device) => item.greenhouseId !== greenhouseId);
    AppState.alarms = AppState.alarms.filter((item: AlarmRecord) => item.greenhouseId !== greenhouseId);
  }

  static async deleteGreenhouseFromDatabase(greenhouseId: string): Promise<boolean> {
    const userId = AppState.currentUser ? AppState.currentUser.id : '';
    const ok = await SecureIntegrationService.deleteDatabaseGreenhouse(userId, greenhouseId);
    if (ok) {
      AppService.removeGreenhouse(greenhouseId);
    }
    return ok;
  }

  static getSensorData(greenhouseId: string): SensorData {
    return AppState.getSensorData(greenhouseId);
  }

  static emptyCloudSensorData(): SensorData {
    return {
      airTemperature: -1,
      airHumidity: -1,
      soilTemperature: -1,
      soilHumidity: -1,
      light: -1,
      co2: -1,
      o2: -1,
      ph: -1,
      distance: -1,
      fanGear: 0,
      lightOn: false,
      boardOn: false,
      waterPumpOn: false,
      medicinePumpOn: false,
      aiWarning: '',
      growthStage: 0,
      updatedAt: ''
    };
  }

  static updateSensorData(greenhouseId: string, data: SensorData): void {
    const normalized = AppService.withAiWarningLabel(data);
    AppState.updateSensorData(greenhouseId, normalized);
    AppService.syncDevicesFromSensor(greenhouseId, normalized);
  }

  static async refreshSensorFromBackend(greenhouseId: string): Promise<SensorData> {
    const greenhouse = AppState.greenhouses.find((item: Greenhouse) => item.id === greenhouseId);
    if (AppService.isHuaweiCloudGreenhouse(greenhouseId, greenhouse)) {
      const cloudResponse = await SecureIntegrationService.fetchHuaweiIoTShadow(greenhouseId);
      if (cloudResponse.success && cloudResponse.sensor) {
        const cloudSensor = AppService.withCloudDisplayFallback(cloudResponse.sensor);
        AppState.updateSensorData(greenhouseId, cloudSensor);
        AppService.syncDevicesFromSensor(greenhouseId, cloudSensor);
        return AppState.getSensorData(greenhouseId);
      }
      throw new Error('sensor data unavailable');
    }

    const databaseResponse = await SecureIntegrationService.fetchDatabaseSensor(greenhouseId);
    if (!databaseResponse.success || !databaseResponse.sensor) {
      throw new Error('sensor data unavailable');
    }
    const devices = await SecureIntegrationService.fetchDatabaseDevices(greenhouseId);
    if (devices.length > 0) {
      AppState.devices = AppState.devices.filter((item: Device) => item.greenhouseId !== greenhouseId).concat(devices);
    }
    const databaseSensor = AppService.withDatabaseDeviceState(
      AppService.withDatabaseStage(databaseResponse.sensor, greenhouse),
      devices
    );
    AppState.updateSensorData(greenhouseId, databaseSensor);
    return AppState.getSensorData(greenhouseId);
  }

  static async refreshDevicesFromDatabase(greenhouseId: string): Promise<Device[]> {
    const greenhouse = AppState.greenhouses.find((item: Greenhouse) => item.id === greenhouseId);
    if (AppService.isHuaweiCloudGreenhouse(greenhouseId, greenhouse)) {
      await AppService.refreshSensorFromBackend(greenhouseId);
      return AppService.getDevices(greenhouseId);
    }

    const devices = await SecureIntegrationService.fetchDatabaseDevices(greenhouseId);
    if (devices.length > 0) {
      AppState.devices = AppState.devices.filter((item: Device) => item.greenhouseId !== greenhouseId).concat(devices);
      return devices;
    }
    return AppService.getDevices(greenhouseId);
  }

  static async refreshAlarmsFromDatabase(greenhouseId: string = ''): Promise<AlarmRecord[]> {
    const alarms = await SecureIntegrationService.fetchDatabaseAlarms(greenhouseId);
    if (alarms.length > 0 || greenhouseId.length === 0) {
      if (greenhouseId.length === 0) {
        AppState.alarms = alarms;
      } else {
        AppState.alarms = AppState.alarms.filter((item: AlarmRecord) => item.greenhouseId !== greenhouseId).concat(alarms);
      }
    }
    return AppService.getAlarms(greenhouseId.length > 0 ? greenhouseId : undefined);
  }

  static async refreshThresholdFromDatabase(greenhouseId: string): Promise<ThresholdConfig> {
    const threshold = await SecureIntegrationService.fetchDatabaseThreshold(greenhouseId);
    if (threshold) {
      AppState.updateThreshold(greenhouseId, threshold);
      return threshold;
    }
    return AppState.getThreshold(greenhouseId);
  }

  static async refreshHistoryFromDatabase(greenhouseId: string, limit: number = 24): Promise<EnvironmentPoint[]> {
    const items = await SecureIntegrationService.fetchDatabaseHistory(greenhouseId, limit);
    AppState.history = AppState.history.filter((item: EnvironmentPoint) => item.greenhouseId !== greenhouseId).concat(items);
    return items;
  }

  static async handleAlarmWithDatabase(alarmId: string): Promise<boolean> {
    const user = AppState.currentUser;
    const handlerName = user ? user.nickname : '未知用户';
    const ok = await SecureIntegrationService.handleDatabaseAlarm(alarmId, handlerName);
    if (ok) {
      AppState.handleAlarm(alarmId, handlerName);
      return true;
    }
    return false;
  }

  static async submitFeedback(content: string): Promise<boolean> {
    const user = AppState.currentUser;
    const trimmed = content.trim();
    if (trimmed.length === 0) {
      return false;
    }
    const ok = await SecureIntegrationService.submitDatabaseFeedback(user ? user.id : '', trimmed, user ? user.phone : '');
    if (ok) {
      AppState.addFeedback(trimmed);
      return true;
    }
    return false;
  }

  static setDeviceStatus(greenhouseId: string, key: string, enabled: boolean): SensorData {
    const data = AppState.getSensorData(greenhouseId);
    const next: SensorData = {
      airTemperature: data.airTemperature,
      airHumidity: data.airHumidity,
      soilTemperature: data.soilTemperature,
      soilHumidity: data.soilHumidity,
      light: data.light,
      co2: data.co2,
      o2: data.o2,
      ph: data.ph,
      distance: data.distance,
      fanGear: data.fanGear,
      lightOn: key === 'light' ? enabled : data.lightOn,
      boardOn: key === 'board' ? enabled : data.boardOn,
      waterPumpOn: key === 'water' ? enabled : data.waterPumpOn,
      medicinePumpOn: key === 'medicine' ? enabled : data.medicinePumpOn,
      aiWarning: data.aiWarning,
      growthStage: data.growthStage,
      updatedAt: data.updatedAt
    };
    AppState.updateSensorData(greenhouseId, next);
    AppService.syncDevicesFromSensor(greenhouseId, next);
    return next;
  }

  static setFanGear(greenhouseId: string, gear: number): SensorData {
    const data = AppState.getSensorData(greenhouseId);
    const next: SensorData = {
      airTemperature: data.airTemperature,
      airHumidity: data.airHumidity,
      soilTemperature: data.soilTemperature,
      soilHumidity: data.soilHumidity,
      light: data.light,
      co2: data.co2,
      o2: data.o2,
      ph: data.ph,
      distance: data.distance,
      fanGear: Math.max(0, Math.min(9, gear)),
      lightOn: data.lightOn,
      boardOn: data.boardOn,
      waterPumpOn: data.waterPumpOn,
      medicinePumpOn: data.medicinePumpOn,
      aiWarning: data.aiWarning,
      growthStage: data.growthStage,
      updatedAt: data.updatedAt
    };
    AppState.updateSensorData(greenhouseId, next);
    AppService.syncDevicesFromSensor(greenhouseId, next);
    return next;
  }

  static getDevices(greenhouseId: string): Device[] {
    return AppState.devices.filter((device: Device) => device.greenhouseId === greenhouseId);
  }

  static getAlarms(greenhouseId?: string): AlarmRecord[] {
    if (!greenhouseId) {
      return AppState.alarms;
    }
    return AppState.alarms.filter((alarm: AlarmRecord) => alarm.greenhouseId === greenhouseId);
  }

  static getAlarmById(alarmId: string): AlarmRecord | null {
    const alarm = AppState.alarms.find((item: AlarmRecord) => item.id === alarmId);
    return alarm || null;
  }

  static handleAlarm(alarmId: string): boolean {
    const user = AppState.currentUser;
    return AppState.handleAlarm(alarmId, user ? user.nickname : '未知用户');
  }

  static getThreshold(greenhouseId: string): ThresholdConfig {
    return AppState.getThreshold(greenhouseId);
  }

  static async updateThreshold(greenhouseId: string, threshold: ThresholdConfig): Promise<boolean> {
    const ok = await SecureIntegrationService.saveDatabaseThreshold(greenhouseId, threshold);
    if (ok) {
      AppState.updateThreshold(greenhouseId, threshold);
      await AppService.refreshThresholdFromDatabase(greenhouseId);
      await AppService.refreshAlarmsFromDatabase(greenhouseId);
    }
    return ok;
  }

  static getHistory(greenhouseId: string, limit: number = 24): EnvironmentPoint[] {
    return AppState.getHistory(greenhouseId, limit);
  }

  static getSettings(): SettingItem[] {
    return AppState.settings;
  }

  static updateSetting(id: string, enabled: boolean): void {
    AppState.updateSetting(id, enabled);
  }

  static buildAiPrompt(greenhouse: Greenhouse, data: SensorData): string {
    const history = AppState.getHistory(greenhouse.id, 24);
    const trend = history.length > 0 ? `近 24 次记录共 ${history.length} 条。` : '暂无历史趋势数据。';
    return `请作为羊肚菌智慧大棚种植助手，给出结构化建议。
大棚ID：${greenhouse.id}
大棚名称：${greenhouse.name}
生长阶段：${greenhouse.stage}
空气温度：${data.airTemperature}℃，空气湿度：${data.airHumidity}%
土壤温度：${data.soilTemperature}℃，土壤湿度：${data.soilHumidity}%
光照：${data.light}lux
二氧化碳：${data.co2}ppm
pH：${data.ph}
风机档位：${data.fanGear}
灯：${data.lightOn ? '开启' : '关闭'}
挡光板：${data.boardOn ? '开启' : '关闭'}
水泵：${data.waterPumpOn ? '开启' : '关闭'}
药泵：${data.medicinePumpOn ? '开启' : '关闭'}
趋势：${trend}
请按“风险等级、核心问题、紧急操作、详细建议”四段返回。`;
  }

  static buildAiSuggestion(greenhouse: Greenhouse, data: SensorData): string {
    const risk = data.airHumidity < 80 || data.soilHumidity < 65 || data.co2 > 900 ? '中' : '低';
    return `风险等级：${risk}
核心问题：${greenhouse.name} 当前处于${greenhouse.stage}，需要重点稳定温湿度、通风和二氧化碳浓度。
紧急操作：保持土壤湿度在 65%-78%，空气湿度在 80%-92%，风机档位控制在 1-3 档。
详细建议：当前空气温度 ${data.airTemperature}℃，空气湿度 ${data.airHumidity}%，土壤湿度 ${data.soilHumidity}%，二氧化碳浓度 ${data.co2}ppm。建议每 2 小时复核一次环境数据，发现湿度持续下降时优先检查水泵和喷淋。`;
  }

  static async requestAiSuggestion(greenhouse: Greenhouse, data: SensorData): Promise<string> {
    return SecureIntegrationService.requestAiSuggestion(greenhouse, data, AppService.buildAiPrompt(greenhouse, data));
  }

  static parseAiSuggestion(text: string): AiSuggestionModel {
    return AppState.parseAiSuggestion(text);
  }

  static async requestAiChat(text: string): Promise<string> {
    const answer = await SecureIntegrationService.requestAiChat(text, AppState.chatHistory);
    AppState.chatHistory = `${AppState.chatHistory}\n我：${text}\nAI：${answer}`.trim();
    if (AppState.chatHistory.length > 5000) {
      AppState.chatHistory = AppState.chatHistory.substring(AppState.chatHistory.length - 5000);
    }
    return answer;
  }

  static getChatHistory(): string {
    return AppState.chatHistory;
  }

  static async sendDeviceCommand(greenhouseId: string, commandName: string, value: string | number | boolean): Promise<boolean> {
    const greenhouse = AppState.greenhouses.find((item: Greenhouse) => item.id === greenhouseId);
    if (!AppService.isHuaweiCloudGreenhouse(greenhouseId, greenhouse)) {
      return false;
    }
    return SecureIntegrationService.sendHuaweiIoTCommand({ greenhouseId, commandName, value });
  }

  static async sendDeviceAction(greenhouseId: string, action: DeviceCommandAction): Promise<boolean> {
    const success = await AppService.sendDeviceCommand(greenhouseId, action.commandName, action.value);
    if (!success) {
      return false;
    }
    if (action.deviceType === 'fan') {
      AppService.setFanGear(greenhouseId, action.fanGear === undefined ? Number(action.value) : action.fanGear);
    } else if (action.stateKey.length > 0 && action.enabled !== undefined) {
      AppService.setDeviceStatus(greenhouseId, action.stateKey, action.enabled);
    }
    return true;
  }

  static buildDeviceAction(deviceType: string, operation: string): DeviceCommandAction | null {
    const type = deviceType.toLowerCase();
    if (operation === 'fan_on') {
      return { deviceType: 'fan', commandName: 'Fengd', value: 3, stateKey: 'fan', fanGear: 3 };
    }
    if (operation === 'fan_off') {
      return { deviceType: 'fan', commandName: 'Fengd', value: 0, stateKey: 'fan', fanGear: 0 };
    }
    if (operation === 'water_on') {
      return { deviceType: 'water', commandName: 'BUMP', value: 'ON', stateKey: 'water', enabled: true };
    }
    if (operation === 'water_off') {
      return { deviceType: 'water', commandName: 'BUMP', value: 'OFF', stateKey: 'water', enabled: false };
    }
    if (operation === 'board_on') {
      return { deviceType: 'board', commandName: 'DangGuangBan', value: 'ON', stateKey: 'board', enabled: true };
    }
    if (operation === 'board_off') {
      return { deviceType: 'board', commandName: 'DangGuangBan', value: 'OFF', stateKey: 'board', enabled: false };
    }
    if (operation === 'light_on') {
      return { deviceType: 'light', commandName: 'LightSt', value: 'ON', stateKey: 'light', enabled: true };
    }
    if (operation === 'light_off') {
      return { deviceType: 'light', commandName: 'LightSt', value: 'OFF', stateKey: 'light', enabled: false };
    }
    if (operation === 'device_off') {
      if (type === 'fan') {
        return AppService.buildDeviceAction(type, 'fan_off');
      }
      if (type === 'water') {
        return AppService.buildDeviceAction(type, 'water_off');
      }
      if (type === 'board') {
        return AppService.buildDeviceAction(type, 'board_off');
      }
      if (type === 'light') {
        return AppService.buildDeviceAction(type, 'light_off');
      }
    }
    return null;
  }

  static suggestAlarmDeviceAction(alarm: AlarmRecord): DeviceCommandAction {
    const text = `${alarm.device} ${alarm.title} ${alarm.content}`;
    if (text.indexOf('\u6e7f\u5ea6\u8fc7\u4f4e') >= 0 || text.indexOf('\u571f\u58e4\u6e7f\u5ea6\u8fc7\u4f4e') >= 0) {
      return AppService.buildDeviceAction('water', 'water_on') as DeviceCommandAction;
    }
    if (text.indexOf('\u6e7f\u5ea6\u8fc7\u9ad8') >= 0 || text.indexOf('\u6e29\u5ea6\u8fc7\u9ad8') >= 0 ||
      text.indexOf('CO2') >= 0 || text.indexOf('\u4e8c\u6c27\u5316\u78b3') >= 0) {
      return AppService.buildDeviceAction('fan', 'fan_on') as DeviceCommandAction;
    }
    if (text.indexOf('\u5149\u7167\u5f3a\u5ea6\u8fc7\u4f4e') >= 0 || text.indexOf('\u5149\u7167\u8fc7\u4f4e') >= 0) {
      return AppService.buildDeviceAction('light', 'light_on') as DeviceCommandAction;
    }
    if (text.indexOf('\u5149\u7167\u5f3a\u5ea6\u8fc7\u9ad8') >= 0 || text.indexOf('\u5149\u7167\u8fc7\u9ad8') >= 0) {
      return AppService.buildDeviceAction('board', 'board_on') as DeviceCommandAction;
    }
    return AppService.buildDeviceAction('fan', 'fan_on') as DeviceCommandAction;
  }

  static canSendCloudCommand(greenhouseId: string): boolean {
    const greenhouse = AppState.greenhouses.find((item: Greenhouse) => item.id === greenhouseId);
    return AppService.isHuaweiCloudGreenhouse(greenhouseId, greenhouse);
  }

  private static syncDevicesFromSensor(greenhouseId: string, data: SensorData): void {
    AppService.upsertDevice(greenhouseId, 'light_1', '灯泡', 'light', data.lightOn ? '开启' : '关闭', data.lightOn);
    AppService.upsertDevice(greenhouseId, 'board_1', '挡光板', 'board', data.boardOn ? '开启' : '关闭', data.boardOn);
    AppService.upsertDevice(greenhouseId, 'fan_1', '风扇', 'fan', data.fanGear > 0 ? data.fanGear + '档' : '关闭', data.fanGear > 0);
    AppService.upsertDevice(greenhouseId, 'water_pump_1', '水泵', 'water', data.waterPumpOn ? '开启' : '关闭', data.waterPumpOn);
    AppService.upsertDevice(greenhouseId, 'medicine_pump_1', '药泵', 'medicine', data.medicinePumpOn ? '开启' : '关闭', data.medicinePumpOn);
  }

  private static isHuaweiCloudGreenhouse(greenhouseId: string, greenhouse?: Greenhouse): boolean {
    const id = greenhouseId.toLowerCase();
    const name = greenhouse ? greenhouse.name : '';
    const cloudId = id === '1' || id === 'farmer01' || id.indexOf('farmer01') >= 0;
    const cloudName = name.indexOf('1\u53f7') >= 0 ||
      name.indexOf('\u4e00\u53f7') >= 0 ||
      name.indexOf('01') >= 0 ||
      name.indexOf('A01') >= 0;
    return cloudId || cloudName;
  }

  private static withAiWarningLabel(sensor: SensorData): SensorData {
    return {
      airTemperature: sensor.airTemperature,
      airHumidity: sensor.airHumidity,
      soilTemperature: sensor.soilTemperature,
      soilHumidity: sensor.soilHumidity,
      light: sensor.light,
      co2: sensor.co2,
      o2: sensor.o2,
      ph: sensor.ph,
      distance: sensor.distance,
      fanGear: sensor.fanGear,
      lightOn: sensor.lightOn,
      boardOn: sensor.boardOn,
      waterPumpOn: sensor.waterPumpOn,
      medicinePumpOn: sensor.medicinePumpOn,
      aiWarning: AppService.aiWarningLabel(sensor.aiWarning),
      growthStage: sensor.growthStage,
      updatedAt: sensor.updatedAt
    };
  }

  private static withCloudDisplayFallback(sensor: SensorData): SensorData {
    return AppService.withAiWarningLabel({
      airTemperature: AppService.displayNumber(sensor.airTemperature, 25),
      airHumidity: AppService.displayNumber(sensor.airHumidity, 54.01),
      soilTemperature: AppService.displayNumber(sensor.soilTemperature, 12),
      soilHumidity: AppService.displayNumber(sensor.soilHumidity, 68),
      light: AppService.displayNumber(sensor.light, 44),
      co2: AppService.displayNumber(sensor.co2, 420),
      o2: AppService.displayNumber(sensor.o2, 20.9),
      ph: AppService.displayNumber(sensor.ph, 6.8),
      distance: AppService.displayNumber(sensor.distance, 30),
      fanGear: sensor.fanGear < 0 ? 0 : sensor.fanGear,
      lightOn: sensor.lightOn,
      boardOn: sensor.boardOn,
      waterPumpOn: sensor.waterPumpOn,
      medicinePumpOn: sensor.medicinePumpOn,
      aiWarning: sensor.aiWarning,
      growthStage: sensor.growthStage <= 0 ? 1 : sensor.growthStage,
      updatedAt: sensor.updatedAt
    });
  }

  private static displayNumber(value: number, fallback: number): number {
    return value >= 0 ? value : fallback;
  }

  private static aiWarningLabel(value: string): string {
    const raw = value ? value.trim() : '';
    if (raw.length === 0 || raw === '--') {
      return raw;
    }
    const key = raw.toLowerCase().replace(/[\s-]+/g, '_');
    if (key === 'normal' || key === 'none' || key === 'healthy' || key === 'no_disease') {
      return '正常';
    }
    if (key === 'white_mold' || key === 'whitemold') {
      return '白霉病';
    }
    if (key === 'green_mold' || key === 'greenmold') {
      return '绿霉病';
    }
    if (key === 'yellow_mold' || key === 'yellowmold') {
      return '黄霉病';
    }
    if (key === 'black_mold' || key === 'blackmold') {
      return '黑霉病';
    }
    if (key === 'cobweb' || key === 'cobweb_disease' || key === 'cobweb_mold') {
      return '蛛网霉病';
    }
    if (key === 'bacterial_blotch' || key === 'brown_blotch') {
      return '细菌性斑点病';
    }
    if (key === 'soft_rot' || key === 'rot') {
      return '软腐病';
    }
    if (/^[a-z_]+$/.test(key)) {
      return '未识别病害（' + raw + '）';
    }
    return raw;
  }

  private static withDatabaseStage(sensor: SensorData, greenhouse?: Greenhouse): SensorData {
    if (!greenhouse || sensor.growthStage > 0) {
      return AppService.withAiWarningLabel(sensor);
    }
    return {
      airTemperature: sensor.airTemperature,
      airHumidity: sensor.airHumidity,
      soilTemperature: sensor.soilTemperature,
      soilHumidity: sensor.soilHumidity,
      light: sensor.light,
      co2: sensor.co2,
      o2: sensor.o2,
      ph: sensor.ph,
      distance: sensor.distance,
      fanGear: sensor.fanGear,
      lightOn: sensor.lightOn,
      boardOn: sensor.boardOn,
      waterPumpOn: sensor.waterPumpOn,
      medicinePumpOn: sensor.medicinePumpOn,
      aiWarning: AppService.aiWarningLabel(sensor.aiWarning),
      growthStage: AppService.stageNumber(greenhouse.stage),
      updatedAt: sensor.updatedAt
    };
  }

  private static stageNumber(stage: string): number {
    if (stage.indexOf('\u83cc\u4e1d') >= 0) {
      return 1;
    }
    if (stage.indexOf('\u50ac\u83c7') >= 0) {
      return 2;
    }
    if (stage.indexOf('\u539f\u57fa') >= 0) {
      return 3;
    }
    if (stage.indexOf('\u51fa\u83c7') >= 0) {
      return 4;
    }
    return 0;
  }

  private static withDatabaseDeviceState(sensor: SensorData, devices: Device[]): SensorData {
    if (devices.length === 0) {
      return AppService.withAiWarningLabel(sensor);
    }
    return {
      airTemperature: sensor.airTemperature,
      airHumidity: sensor.airHumidity,
      soilTemperature: sensor.soilTemperature,
      soilHumidity: sensor.soilHumidity,
      light: sensor.light,
      co2: sensor.co2,
      o2: sensor.o2,
      ph: sensor.ph,
      distance: sensor.distance,
      fanGear: AppService.databaseDeviceEnabled(devices, 'fan') ? 1 : -1,
      lightOn: AppService.databaseDeviceEnabled(devices, 'light'),
      boardOn: AppService.databaseDeviceEnabled(devices, 'board'),
      waterPumpOn: AppService.databaseDeviceEnabled(devices, 'water'),
      medicinePumpOn: AppService.databaseDeviceEnabled(devices, 'medicine'),
      aiWarning: AppService.aiWarningLabel(sensor.aiWarning),
      growthStage: sensor.growthStage,
      updatedAt: sensor.updatedAt
    };
  }

  private static databaseDeviceEnabled(devices: Device[], type: string): boolean {
    const device = devices.find((item: Device) => item.type === type);
    return device ? device.enabled : false;
  }

  private static upsertDevice(greenhouseId: string, id: string, name: string, type: string, status: string, enabled: boolean): void {
    const key = `${greenhouseId}-${id}`;
    const device = AppState.devices.find((item: Device) => item.id === key);
    if (device) {
      device.status = status;
      device.enabled = enabled;
      return;
    }
    AppState.devices.push({ id: key, name, type, status, enabled, greenhouseId });
  }
}
