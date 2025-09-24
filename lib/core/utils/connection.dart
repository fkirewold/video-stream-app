import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class Connection {
  // Connection-related methods and properties
  static Future<bool> checkConnection(BuildContext context) async {

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains( ConnectivityResult.none)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No internet connection. Please check your connection.'),
        ),
      );
      return false;
    } else {
      return true;
    }
  }
}
