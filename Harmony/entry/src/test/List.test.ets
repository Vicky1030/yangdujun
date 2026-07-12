import appStateTest from './AppState.test';
import appServiceTest from './AppService.test';
import appRoutesTest from './AppRoutes.test';
import secureEndpointConfigTest from './SecureEndpointConfig.test';

export default function testsuite() {
  appStateTest();
  appServiceTest();
  appRoutesTest();
  secureEndpointConfigTest();
}
