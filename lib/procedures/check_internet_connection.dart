import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const bool _kDebugPrint = false;

class InternetConnectivityChecker with ChangeNotifier {
  static InternetConnectivityChecker get instance => _instance;

  InternetConnectivityChecker._internal() {
    _checkInternetConnectionStream(intervalInSeconds: 2).listen((event) {});
  }

  static final InternetConnectivityChecker _instance =
      InternetConnectivityChecker._internal();

  bool _isConnected = false;

  bool get watchableConnectionStatus => _isConnected;

  Future<bool> get isConnected async {
    if (_kDebugPrint) {
      debugPrint('[InternetConnectivityChecker] Checking connection status');
    }
    bool isConnected = false;
    try {
      final http.Response test = await http.get(Uri.parse(
        'https://firebasestorage.googleapis.com/v0/b/qr-code-almox-app.appspot.com/o/connectivity_check%2Fconnectivity_check.json?alt=media&token=3241f53c-83d9-4924-8d71-c50696b9f9e7',
      ));
      final Map<String, dynamic> test2 = json.decode(test.body);
      if (test2['connectivityCheck'] == 'connected') isConnected = true;
      if (_kDebugPrint) debugPrint('not connected');
    } on Exception catch (_) {
      if (_kDebugPrint) debugPrint('not connected');
    }
    if (_kDebugPrint) {
      debugPrint('[InternetConnectivityChecker] Checking change in status');
    }
    if (_isConnected != isConnected) {
      _isConnected = !_isConnected;
      if (_kDebugPrint) {
        debugPrint('[InternetConnectivityChecker] Notifying listeners');
      }
      notifyListeners();
      if (_kDebugPrint) {
        debugPrint('[InternetConnectivityChecker] done notifying listeners');
      }
    }
    return isConnected;
  }

  Stream<bool> _checkInternetConnectionStream(
      {int intervalInSeconds = 10}) async* {
    bool isConnected;
    while (true) {
      isConnected = await this.isConnected;
      if (_kDebugPrint) {
        debugPrint(
            '[InternetConnectivityChecker] Streaming connection status: $isConnected');
      }
      yield isConnected;
      await Future.delayed(Duration(seconds: intervalInSeconds));
    }
  }
}
