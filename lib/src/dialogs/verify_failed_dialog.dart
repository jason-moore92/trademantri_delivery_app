import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VerifyFailedDialog {
  static show(
    BuildContext context, {
    @required double? heightDp,
    @required double? fontSp,
    EdgeInsets? insetPadding,
    EdgeInsets? titlePadding,
    EdgeInsets? contentPadding,
    double? borderRadius,
    Color? barrierColor,
    String text = "Failed!",
    bool barrierDismissible = false,
    Function? callBack,
    int delaySecondes = 2,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (BuildContext context1) {
        return AlertDialog(
          // elevation: 0.0,
          backgroundColor: Colors.white,
          insetPadding: insetPadding ?? EdgeInsets.symmetric(horizontal: 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp! * 10)),
          title: Icon(Icons.error_outline, size: heightDp * 60, color: Colors.redAccent),
          titlePadding: titlePadding,
          contentPadding: contentPadding ?? EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
          content: Text(
            text,
            style: TextStyle(
              fontSize: fontSp! * 13,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
                if (callBack != null) {
                  callBack();
                }
              },
              child: Text(
                'Resend link',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Ok', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}
