import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mcmtimecards/config.dart';

import 'package:mcmtimecards/models/timecard_model.dart';
import 'package:mcmtimecards/models/timecardreport_model.dart';
import 'package:mcmtimecards/utility/get_address.dart';

class TimeCardAPI {
  saveTimeIn(TimeCardModel timecard) async {
    String _result;
    timecard.wifibssidin = await GetAddress.getBssid();
    var _url = 'api/hr/time_card/time_in.php';
    var _body = jsonEncode({
      "employee_id": timecard.employeeid,
      "start_time": timecard.starttime.toString(),
      "wifi_bssid": timecard.wifibssidin
    });
    await http
        .post(Uri.parse(AppConfig().url + _url),
            headers: AppConfig().header, body: _body)
        .then((result) {
      _result = result.body.toString();
    }).catchError((err) {
      _result = err.toString();
    });
    // ignore: avoid_print
    print(_result);
  }

  saveTimeOut(TimeCardModel timecard) async {
    String _result;
    timecard.wifibssidout = await GetAddress.getBssid();
    var _url = 'api/hr/time_card/time_out.php';
    var _body = jsonEncode({
      "id": timecard.id,
      "end_time": timecard.endtime.toString(),
      "wifi_bssid": timecard.wifibssidout
    });
    await http
        .post(Uri.parse(AppConfig().url + _url),
            headers: AppConfig().header, body: _body)
        .then((result) {
      _result = result.body.toString();
    }).catchError((err) {
      _result = err.toString();
    });
    // ignore: avoid_print
    print(_result);
  }

  Future<TimeCardModel> getTimeCardToday(String employeeid) async {
    TimeCardModel timeCard = TimeCardModel();
    var _url = AppConfig().url + 'api/hr/time_card/read_day.php';
    var _body = jsonEncode({"employee_id": employeeid});
    var result = await http.post(Uri.parse(_url),
        headers: AppConfig().header, body: _body);

    if (result.statusCode == 200) {
      var _result = json.decode(result.body);
      timeCard.employeeid = employeeid;
      timeCard.id = _result['id'] == null ? 0 : int.parse(_result['id']);
      timeCard.starttime = DateTime.parse(_result['start_time']);
      timeCard.endtime = _result['end_time'] == null
          ? DateTime.parse(_result['start_time'])
          : DateTime.parse(_result['end_time']);
      timeCard.note = _result['note'].toString();
    }
    return timeCard;
  }

  Future<List<DataTimeCard>> getTimeCardData(
      String employeeid, int year, int month) async {
    // ignore: unused_local_variable
    var _url = AppConfig().url + 'api/hr/time_card/read_report.php';
    var _body =
        jsonEncode({"employee_id": employeeid, "year": year, "month": month});
    var response = await http.post(Uri.parse(_url),
        headers: AppConfig().header, body: _body);
    return timecardreportModelFromJson(response.body).data;
  }

  TimeCardAPI();
}
