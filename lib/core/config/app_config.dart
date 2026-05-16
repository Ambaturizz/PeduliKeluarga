import '../constants/app_constants.dart';
import 'app_environment.dart';

class AppConfig {
  const AppConfig({
    required this.environment,
    required this.appName,
    required this.baseUrl,
    required this.enableMockData,
    required this.enableRouterLogs,
    required this.enableAnalytics,
  });

  final AppEnvironment environment;
  final String appName;
  final String baseUrl;
  final bool enableMockData;
  final bool enableRouterLogs;
  final bool enableAnalytics;

  factory AppConfig.forEnvironment(AppEnvironment environment) {
    return switch (environment) {
      AppEnvironment.development => const AppConfig(
          environment: AppEnvironment.development,
          appName: AppConstants.appName,
          baseUrl: '',
          enableMockData: true,
          enableRouterLogs: true,
          enableAnalytics: false,
        ),
      AppEnvironment.staging => const AppConfig(
          environment: AppEnvironment.staging,
          appName: AppConstants.appName,
          baseUrl: '',
          enableMockData: true,
          enableRouterLogs: true,
          enableAnalytics: false,
        ),
      AppEnvironment.production => const AppConfig(
          environment: AppEnvironment.production,
          appName: AppConstants.appName,
          baseUrl: '',
          enableMockData: false,
          enableRouterLogs: false,
          enableAnalytics: true,
        ),
    };
  }
}
