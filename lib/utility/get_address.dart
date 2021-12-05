import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get_mac/get_mac.dart';
import 'package:connectivity/connectivity.dart';
import 'package:mcmtimecards/database/wifibssid_api.dart';
import 'package:mcmtimecards/models/wifibssid_model.dart';
import 'package:permission_handler/permission_handler.dart';

class GetAddress {
  static Future<String> getMacAddress() async {
    String _result;
    try {
      var _res = await GetMac.macAddress;
      _result = _res.toUpperCase();
    } on PlatformException {
      // ignore: avoid_print
      print('Failed to get Device MAC Address.');
    }
    return _result;
  }

  static Future<String> getBssid() async {
    String wifiBSSID = 'Connection not wifi';
    // String connectionStatus = 'Unknown';
    final Connectivity connectivity = Connectivity();
    // StreamSubscription<ConnectivityResult> connectivitySubscription;
    ConnectivityResult result;
    try {
      bool allowed = false;

      allowed = await Permission.locationWhenInUse.isGranted;
      if (allowed == false) {
        // final PermissionStatus status =
        //     await Permission.locationWhenInUse.request();
        // allowed = status.isGranted;
        if (await Permission.locationWhenInUse.request() != null) {
          allowed = await Permission.locationWhenInUse.isGranted;
        }
      }
      if (allowed == true) {
        result = await connectivity.checkConnectivity();
        switch (result) {
          case ConnectivityResult.wifi:
            try {
              wifiBSSID = await connectivity.getWifiBSSID();
            } on PlatformException catch (e) {
              // ignore: avoid_print
              print(e.toString());
              wifiBSSID = "Failed to get Wifi BSSID";
            }
            break;
          case ConnectivityResult.mobile:
            wifiBSSID = "You connect mobile";
            break;
          case ConnectivityResult.none:
            wifiBSSID = "You not connect network";
            break;
          default:
            wifiBSSID = 'Failed to get connectivity.';
            break;
        }
        // connectivitySubscription.cancel();
      }
    } on PlatformException catch (e) {
      // ignore: avoid_print
      print(e.toString());
      return 'Not conect wifi: ${e.message}';
    }
    return wifiBSSID.toUpperCase();
  }

  static Future<bool> checkWifiBase() async {
    List<Wifibssid> _wifibssids = <Wifibssid>[];
    List<Wifibssid> _filterwifibssids = <Wifibssid>[];

    var _bssid = await GetAddress.getBssid();
    await WifiBssidAPI.loadWifibssid().then((data) {
      _wifibssids = data;
    });

    _filterwifibssids = _wifibssids.where((wifi) {
      var _wifiSelect = wifi.wifibssid.toUpperCase();
      return _wifiSelect.contains(_bssid);
    }).toList();
    if (_filterwifibssids.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  GetAddress();
}
