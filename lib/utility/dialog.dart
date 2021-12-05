import 'package:flutter/material.dart';
import 'package:mcmtimecards/utility/my_style.dart';

Future<void> normalDialog(
    BuildContext context, String title1, String title2) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: ListTile(
        leading: Image.asset('images/logo.png'),
        title: Text(
          title1,
          style: MyStyle().redBoldStyle(),
        ),
        subtitle: Text(title2),
      ),
      children: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Ok'))
      ],
    ),
  );
}
