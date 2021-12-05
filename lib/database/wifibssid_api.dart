import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mcmtimecards/config.dart';
import 'package:mcmtimecards/models/wifibssid_model.dart';
import 'package:mcmtimecards/utility/my_data.dart';

class WifiBssidAPI {
  static Future<List<Wifibssid>> loadWifibssid() async {
    List<Wifibssid> wifibssids = <Wifibssid>[];
    try {
      var _com = MyData().company;
      var _url = "api/branch/readwifi.php";
      var _body = jsonEncode(_com);
      var _response = await http.post(Uri.parse(AppConfig().url + _url),
          headers: AppConfig().header, body: _body);
      return wifiBssidModelFromJson(_response.body).data;
    } catch (e) {
      return wifibssids;
    }
  }
}
