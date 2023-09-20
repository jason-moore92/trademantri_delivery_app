import 'dart:convert';

import 'package:delivery_app/environment.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app/src/helpers/http_plus.dart';

class DeliveryOTPApiProvider {
  static getOTP({@required String? orderId}) async {
    String apiUrl = 'delivery_otp/get';
    apiUrl += "?orderId=$orderId";

    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }
}
