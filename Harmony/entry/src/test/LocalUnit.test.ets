import { describe, it, expect } from '@ohos/hypium';
import { AppState } from '../main/ets/storage/AppState';

export default function localUnitTest() {
  describe('localUnitTest', () => {
    it('should keep the local unit test entry business related', 0, () => {
      expect(AppState.isValidPhone('13800138000')).assertTrue();
      expect(AppState.isStrongPassword('abc12345')).assertTrue();
    });
  });
}
