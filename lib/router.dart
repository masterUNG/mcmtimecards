import 'package:flutter/material.dart';
import 'package:mcmtimecards/widget/authen.dart';
import 'package:mcmtimecards/widget/main_menu.dart';
import 'package:mcmtimecards/widget/register.dart';
import 'package:mcmtimecards/widget/time_card_main.dart';

final Map<String, WidgetBuilder> routes = {
  '/authen': (BuildContext context) => const Authen(),
  '/mainmenu': (BuildContext context) => const MainMenu(),
  '/register': (BuildContext context) => const Register(),
  '/timecard': (BuildContext context) => const TimeCardMain(),
};
