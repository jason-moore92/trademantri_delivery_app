import 'dart:convert';

import 'package:delivery_app/environment.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as httpold;
import 'package:delivery_app/src/helpers/http_plus.dart';

class OrderApiProvider {
  static getDeliveryOrderData({
    @required double? lat,
    @required double? lng,
    @required String? deliveryUserId,
    @required List<dynamic>? deliveryPartnerIds,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'order/getDeliveryOrderData';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "lat": lat,
          "lng": lng,
          "deliveryUserId": deliveryUserId,
          "deliveryPartnerIds": deliveryPartnerIds,
          "searchKey": searchKey,
          "page": page,
          "limit": limit,
        }),
      );
      return json.decode(response.body);
    });
  }

  static getOrder({
    @required String? orderId,
    @required String? storeId,
    @required String? userId,
  }) async {
    String apiUrl = 'order/getOrder';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?storeId=$storeId";
      url += "&userId=$userId";
      url += "&orderId=$orderId";

      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return json.decode(response.body);
    });
  }

  static updateOrderData({
    @required Map<String, dynamic>? orderData,
    @required String? status,
    @required bool? changedStatus,
  }) async {
    String apiUrl = 'order/update/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"orderData": orderData, "status": status, "changedStatus": changedStatus}),
      );
      return json.decode(response.body);
    });
  }

  static getMyDeliveryOrderData({
    @required double? lat,
    @required double? lng,
    @required String? deliveryUserId,
    String searchKey = "",
    @required int? limit,
    int page = 1,
  }) async {
    String apiUrl = 'order/getMyDeliveryOrderData';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "lat": lat,
          "lng": lng,
          "deliveryUserId": deliveryUserId,
          "searchKey": searchKey,
          "page": page,
          "limit": limit,
        }),
      );
      return json.decode(response.body);
    });
  }

  static getMyDeliveryDashboardData({@required String? deliveryUserId}) async {
    String apiUrl = 'order/getMyDeliveryDashboardData';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      url += "?deliveryUserId=$deliveryUserId";

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
