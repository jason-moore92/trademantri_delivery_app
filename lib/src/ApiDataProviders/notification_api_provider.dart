import 'dart:convert';

import 'package:delivery_app/environment.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app/src/helpers/http_plus.dart';

class NotificationApiProvider {
  static getNotificationData({
    @required String? deliveryUserId,
    @required String? status,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'delivery_user_notification/getNotificationData/';
    apiUrl += "?deliveryUserId=$deliveryUserId";
    apiUrl += "&status=$status";
    apiUrl += "&searchKey=$searchKey";
    apiUrl += "&page=$page";
    apiUrl += "&limit=$limit";

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
