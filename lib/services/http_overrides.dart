import 'dart:io';
import 'package:flutter/foundation.dart';

// Global HTTP overrides for SSL certificate validation in debug mode
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        // Only bypass SSL certificate validation in debug mode
        return kDebugMode;
      };
  }
}
