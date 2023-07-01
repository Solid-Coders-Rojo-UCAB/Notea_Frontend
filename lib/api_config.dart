import 'dart:io';

class ApiConfig {
  static final String apiBaseUrl = _getBaseUrl();

  static String _getBaseUrl() {
    if (const bool.fromEnvironment('dart.vm.product')) {
      return 'https://noteabackend-production.up.railway.app';
    } else {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:3000';
      } else {
        return 'http://localhost:3000'; // fallback para otros sistemas operativos
      }
    }
  }
}
