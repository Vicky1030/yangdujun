import { describe, it, expect } from '@ohos/hypium';
import { AppRoutes } from '../main/ets/common/AppRoutes';

export default function appRoutesTest() {
  describe('AppRoutesTest', () => {
    it('should define main page routes', 0, () => {
      expect(AppRoutes.INDEX).assertEqual('pages/Index');
      expect(AppRoutes.LOGIN).assertEqual('pages/LoginPage');
      expect(AppRoutes.REGISTER).assertEqual('pages/RegisterPage');
      expect(AppRoutes.HOME).assertEqual('pages/GreenhouseHomePage');
      expect(AppRoutes.MANAGE).assertEqual('pages/ManagePage');
      expect(AppRoutes.DEVICE_MANAGE).assertEqual('pages/DeviceManagePage');
      expect(AppRoutes.ALARM_RECORD).assertEqual('pages/AlarmRecordPage');
      expect(AppRoutes.ALARM_THRESHOLD).assertEqual('pages/AlarmThresholdPage');
      expect(AppRoutes.REALTIME_ANALYSIS).assertEqual('pages/RealTimeAnalysisPage');
      expect(AppRoutes.HISTORY_ANALYSIS).assertEqual('pages/HistoryAnalysisPage');
      expect(AppRoutes.AI).assertEqual('pages/AiSuggestionPage');
      expect(AppRoutes.FEEDBACK).assertEqual('pages/FeedbackPage');
    });
  });
}
