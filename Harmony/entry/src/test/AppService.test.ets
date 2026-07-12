import { describe, beforeEach, it, expect } from '@ohos/hypium';
import { AlarmRecord } from '../main/ets/models/AppModels';
import { AppService } from '../main/ets/services/AppService';
import { AppState } from '../main/ets/storage/AppState';

export default function appServiceTest() {
  describe('AppServiceTest', () => {
    beforeEach(() => {
      AppState.currentUser = null;
    });

    it('should clamp fan gear between 0 and 9', 0, () => {
      const high = AppService.setFanGear('default', 20);
      expect(high.fanGear).assertEqual(9);

      const low = AppService.setFanGear('default', -5);
      expect(low.fanGear).assertEqual(0);

      const normal = AppService.setFanGear('default', 3);
      expect(normal.fanGear).assertEqual(3);
    });

    it('should update device status flags', 0, () => {
      expect(AppService.setDeviceStatus('default', 'light', true).lightOn).assertTrue();
      expect(AppService.setDeviceStatus('default', 'board', true).boardOn).assertTrue();
      expect(AppService.setDeviceStatus('default', 'water', true).waterPumpOn).assertTrue();
      expect(AppService.setDeviceStatus('default', 'medicine', true).medicinePumpOn).assertTrue();
    });

    it('should build device command actions', 0, () => {
      const fan = AppService.buildDeviceAction('fan', 'fan_on');
      expect(fan !== null).assertTrue();
      expect(fan?.commandName).assertEqual('Fengd');
      expect(fan?.value).assertEqual(3);

      const fanOff = AppService.buildDeviceAction('fan', 'fan_off');
      expect(fanOff?.value).assertEqual(0);

      const water = AppService.buildDeviceAction('water', 'water_on');
      expect(water?.commandName).assertEqual('BUMP');
      expect(water?.value).assertEqual('ON');

      const board = AppService.buildDeviceAction('board', 'board_on');
      expect(board?.commandName).assertEqual('DangGuangBan');

      const light = AppService.buildDeviceAction('light', 'light_on');
      expect(light?.commandName).assertEqual('LightSt');

      expect(AppService.buildDeviceAction('unknown', 'bad_action') === null).assertTrue();
    });

    it('should get devices and alarms by greenhouse', 0, () => {
      const devices = AppService.getDevices('default');
      expect(devices.length > 0).assertTrue();

      const alarms = AppService.getAlarms('default');
      expect(alarms.length > 0).assertTrue();
      expect(AppService.getAlarmById('alarm-1') !== null).assertTrue();
      expect(AppService.getAlarmById('missing') === null).assertTrue();
    });

    it('should handle local alarm state', 0, () => {
      expect(AppService.handleAlarm('alarm-1')).assertTrue();
      expect(AppService.handleAlarm('missing')).assertFalse();
      expect(AppService.getAlarmById('alarm-1')?.handledAt !== undefined).assertTrue();
    });

    it('should suggest device action for alarm content', 0, () => {
      const lowHumidity: AlarmRecord = {
        id: 'alarm-low-humidity',
        greenhouseId: 'default',
        greenhouseName: 'default',
        device: 'humidity',
        title: 'humidity',
        content: '\u571f\u58e4\u6e7f\u5ea6\u8fc7\u4f4e',
        level: 'middle',
        status: 'pending',
        createdAt: 'now'
      };
      const highTemperature: AlarmRecord = {
        id: 'alarm-high-temperature',
        greenhouseId: 'default',
        greenhouseName: 'default',
        device: 'temperature',
        title: 'temperature',
        content: '\u6e29\u5ea6\u8fc7\u9ad8',
        level: 'middle',
        status: 'pending',
        createdAt: 'now'
      };
      const lowLight: AlarmRecord = {
        id: 'alarm-low-light',
        greenhouseId: 'default',
        greenhouseName: 'default',
        device: 'light',
        title: 'light',
        content: '\u5149\u7167\u5f3a\u5ea6\u8fc7\u4f4e',
        level: 'middle',
        status: 'pending',
        createdAt: 'now'
      };

      expect(AppService.suggestAlarmDeviceAction(lowHumidity).deviceType).assertEqual('water');
      expect(AppService.suggestAlarmDeviceAction(highTemperature).deviceType).assertEqual('fan');
      expect(AppService.suggestAlarmDeviceAction(lowLight).deviceType).assertEqual('light');
    });
  });
}
