import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/config/app_config.dart';
import '../../core/config/app_environment.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.forEnvironment(AppEnvironment.development);
});
