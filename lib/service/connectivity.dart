import 'package:connectivity_plus/connectivity_plus.dart';

mixin NetworkConnection {
  static Future<bool> isConnected() async {
    final internetConnections = [ConnectivityResult.mobile, ConnectivityResult.wifi];
    final connections = await (Connectivity().checkConnectivity());
    return connections.any((connection) => internetConnections.contains(connection));
  }
}
