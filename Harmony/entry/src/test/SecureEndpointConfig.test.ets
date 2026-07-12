import { describe, it, expect } from '@ohos/hypium';
import { SecureEndpointConfig } from '../main/ets/services/SecureEndpointConfig';

export default function secureEndpointConfigTest() {
  describe('SecureEndpointConfigTest', () => {
    it('should provide backend base urls and api paths', 0, () => {
      expect(SecureEndpointConfig.API_BASE_URL.indexOf('http')).assertEqual(0);
      expect(SecureEndpointConfig.API_BASE_URLS.length > 0).assertTrue();
      expect(SecureEndpointConfig.hasBackend()).assertTrue();

      expect(SecureEndpointConfig.AUTH_LOGIN_PATH).assertEqual('/auth/login');
      expect(SecureEndpointConfig.AUTH_REGISTER_PATH).assertEqual('/auth/register');
      expect(SecureEndpointConfig.AUTH_RESET_PASSWORD_PATH).assertEqual('/auth/reset-password');
      expect(SecureEndpointConfig.GREENHOUSES_PATH).assertEqual('/greenhouses');
      expect(SecureEndpointConfig.THRESHOLD_PATH).assertEqual('/threshold');
      expect(SecureEndpointConfig.SENSOR_LATEST_PATH).assertEqual('/sensor/latest');
      expect(SecureEndpointConfig.SENSOR_HISTORY_PATH).assertEqual('/sensor/history');
    });
  });
}
