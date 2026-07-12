import { describe, beforeEach, it, expect } from '@ohos/hypium';
import { AppState } from '../main/ets/storage/AppState';
import { SensorData, ThresholdConfig } from '../main/ets/models/AppModels';

export default function appStateTest() {
  describe('AppStateTest', () => {
    beforeEach(() => {
      AppState.currentUser = null;
      AppState.users = [];
      AppState.feedbacks = [];
      AppState.history = [];
    });

    it('should validate phone number', 0, () => {
      expect(AppState.isValidPhone('13800138000')).assertTrue();
      expect(AppState.isValidPhone('123')).assertFalse();
      expect(AppState.isValidPhone('')).assertFalse();
      expect(AppState.isValidPhone('23800138000')).assertFalse();
    });

    it('should validate strong password', 0, () => {
      expect(AppState.isStrongPassword('abc12345')).assertTrue();
      expect(AppState.isStrongPassword('12345678')).assertFalse();
      expect(AppState.isStrongPassword('abcdefgh')).assertFalse();
      expect(AppState.isStrongPassword('abc12')).assertFalse();
    });

    it('should register login logout and reject duplicate users', 0, () => {
      expect(AppState.register('13800138000', 'abc12345')).assertTrue();
      expect(AppState.isLoggedIn()).assertTrue();
      expect(AppState.register('13800138000', 'abc12345')).assertFalse();

      AppState.logout();
      expect(AppState.isLoggedIn()).assertFalse();
      expect(AppState.login('13800138000', 'wrong123')).assertFalse();
      expect(AppState.login('13800138000', 'abc12345')).assertTrue();
    });

    it('should reject invalid register and reset password input', 0, () => {
      expect(AppState.register('123', 'abc12345')).assertFalse();
      expect(AppState.register('13800138000', '123')).assertFalse();
      expect(AppState.resetPassword('13800138000', 'abc12345')).assertFalse();

      expect(AppState.register('13800138000', 'abc12345')).assertTrue();
      expect(AppState.resetPassword('13800138000', '123')).assertFalse();
      expect(AppState.resetPassword('13800138000', 'abc123456')).assertTrue();
      AppState.logout();
      expect(AppState.login('13800138000', 'abc123456')).assertTrue();
    });

    it('should update current user information', 0, () => {
      expect(AppState.register('13800138000', 'abc12345')).assertTrue();
      expect(AppState.updateUserInfo('tester', 'avatar.png')).assertTrue();
      expect(AppState.currentUser?.nickname).assertEqual('tester');
      expect(AppState.currentUser?.avatar).assertEqual('avatar.png');

      AppState.logout();
      expect(AppState.updateUserInfo('nobody')).assertFalse();
    });

    it('should return default sensor data for unknown greenhouse and update sensor data', 0, () => {
      const fallback = AppState.getSensorData('unknown-greenhouse');
      const source = AppState.getSensorData('default');
      expect(fallback.airTemperature).assertEqual(source.airTemperature);

      const next: SensorData = {
        airTemperature: 20,
        airHumidity: 81,
        soilTemperature: 18,
        soilHumidity: 70,
        light: 1300,
        co2: 680,
        o2: 20.5,
        ph: 6.7,
        distance: -1,
        fanGear: 1,
        lightOn: true,
        boardOn: false,
        waterPumpOn: true,
        medicinePumpOn: false,
        aiWarning: 'normal',
        growthStage: 4,
        updatedAt: 'old'
      };
      AppState.updateSensorData('greenhouse-test', next);
      const stored = AppState.getSensorData('greenhouse-test');
      expect(stored.airTemperature).assertEqual(20);
      expect(stored.lightOn).assertTrue();
      expect(AppState.getHistory('greenhouse-test', 10).length).assertEqual(1);
    });

    it('should read and update threshold config', 0, () => {
      const next: ThresholdConfig = {
        tempMin: 10,
        tempMax: 25,
        airHumMin: 70,
        airHumMax: 95,
        soilTempMin: 11,
        soilTempMax: 24,
        humMin: 60,
        humMax: 80,
        co2Min: 400,
        co2Max: 1000,
        o2Min: 19,
        o2Max: 22,
        phMin: 6,
        phMax: 7.5,
        lightMin: 500,
        lightMax: 2000
      };

      expect(AppState.getThreshold('default').tempMin).assertEqual(12);
      AppState.updateThreshold('greenhouse-test', next);
      expect(AppState.getThreshold('greenhouse-test').tempMax).assertEqual(25);
    });

    it('should keep history length within 240 records', 0, () => {
      const data = AppState.getSensorData('default');
      for (let i = 0; i < 245; i++) {
        AppState.saveEnvironmentPoint('default', data);
      }

      expect(AppState.history.length).assertEqual(240);
      expect(AppState.getHistory('default', 24).length).assertEqual(24);
    });

    it('should add non-empty feedback only', 0, () => {
      expect(AppState.addFeedback('   ')).assertFalse();
      expect(AppState.addFeedback('device problem')).assertTrue();
      expect(AppState.feedbacks.length).assertEqual(1);
    });
  });
}
