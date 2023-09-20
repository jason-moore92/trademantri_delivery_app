import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as QRScanner;

class QrCodeWidget extends StatelessWidget {
  final String? code;
  final double? width;
  final double? height;
  final Function(Uint8List)? callback;

  QrCodeWidget({
    Key? key,
    @required this.code,
    @required this.width,
    @required this.height,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<Uint8List>(
        stream: Stream.fromFuture(QRScanner.generateBarCode(code!)),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(
              width: width,
              height: height,
              alignment: Alignment.center,
              child: CupertinoActivityIndicator(),
            );
          }
          if (callback != null) {
            callback!(snapshot.data!);
          }
          return Image.memory(
            snapshot.data!,
            width: width,
            height: height,
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }

  static Future<Uint8List> getData(String code) async {
    return await QRScanner.generateBarCode(code);
  }
}
