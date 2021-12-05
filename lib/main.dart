import 'package:flutter/material.dart';
import 'package:mcmtimecards/database/employee_api.dart';
import 'package:mcmtimecards/models/employee_model.dart';
import 'package:mcmtimecards/router.dart';
import 'package:mcmtimecards/utility/get_address.dart';
import 'package:mcmtimecards/widget/time_card.dart';
import 'package:mcmtimecards/widget/time_card_main.dart';

String initialRoute = '/authen';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // ignore: unused_local_variable
  GetMacAddress mac = GetMacAddress();
  String maxaddress;//, bssid;
  maxaddress = await GetAddress.getMacAddress();
  mac = await EmployeeAPI.getMacaddress(maxaddress);
  if (mac.employeeid != null) {
    // bssid = await GetAddress.getBssid();
    TimeCardMain.macaddress = mac;
    TimeCard.employeeid = mac.employeeid;
    TimeCard.name = mac.name;
    TimeCardMain.macaddress.employeeid = mac.employeeid;
    TimeCardMain.macaddress.name = mac.name;
    TimeCardMain.macaddress.urlimage = mac.urlimage;
    if (await GetAddress.checkWifiBase() == true){
      initialRoute = '/timecard';
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: routes,
      initialRoute: initialRoute,
    );
  }
}
