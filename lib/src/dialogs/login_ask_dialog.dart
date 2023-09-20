import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delivery_app/src/pages/login.dart';

class LoginAskDialog {
  static show(BuildContext context, {Function? callback}) {
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "You didn't login yet",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          content: Text(
            "Do you want to login now",
            style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => LoginWidget(callback: callback)),
                );
              },
              child: Text(
                "OK",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    );
  }
}
