import 'package:flutter/material.dart';
import 'package:mcmtimecards/utility/my_style.dart';
import 'package:mcmtimecards/widget/time_card_detail.dart';
import 'package:mcmtimecards/widget/time_card_report.dart';

class TimeCard extends StatefulWidget {
  static String employeeid, name;

  const TimeCard({Key key}) : super(key: key);

  @override
  _TimeCardState createState() => _TimeCardState();
}

class _TimeCardState extends State<TimeCard> {
  final int year = DateTime.now().year;
  final int month = DateTime.now().month;
  final String _tap1 = 'หน้าลงเวลา', _tab2 = 'รายงาน';
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(
          children: [
            TimeCardDetail(TimeCard.employeeid, TimeCard.name),
            TimeCardReport(TimeCard.employeeid, year, month,false),
          ],
        ),
        backgroundColor: MyStyle().primaryColor,
        bottomNavigationBar: TabBar(
          indicatorColor: Colors.yellow,
          tabs: [
            Tab(
              icon: const Icon(Icons.access_time),
              text: _tap1,              
            ),
            Tab(
              icon: const Icon(Icons.info),
              text: _tab2,
            ),
          ],
        ),
      ),
    );
  }
}
