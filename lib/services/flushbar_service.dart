import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class FlushService {
  static void flushbarAlert(
      {required BuildContext context,
      required String title,
      required String message,
      required int seconds}) {
    Flushbar(
      icon: Icon(
        title == 'Success'
            ? Icons.check
            : title == 'Info'
                ? Icons.info_outline
                : Icons.error,
        size: 35,
        color: Colors.white,
      ),
      title: title,
      message: message,
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: title == 'Success'
          ? Color(0xff4ca746)
          : title == 'Info'
              ? Color(0xff3366ff)
              : Colors.red,
      duration: Duration(seconds: seconds),
      flushbarStyle: FlushbarStyle.FLOATING,
      showProgressIndicator: true,
      progressIndicatorBackgroundColor: Colors.white,
      onTap: (flushbar) {
        flushbar.dismiss();
      },
      margin: EdgeInsets.only(left: 8, right: 8, bottom: 16),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }
}
