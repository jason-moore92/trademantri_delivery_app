import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:delivery_app/environment.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as httpold;
import 'package:delivery_app/src/helpers/http_plus.dart';
import 'package:delivery_app/src/models/index.dart';

class DeliveryUserApiProvider {
  static registerDeliveryUser(DeliveryUserModel deliveryUserModel) async {
    String apiUrl = 'delivery_user/register';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(deliveryUserModel.toJson()),
      );

      var result = json.decode(response.body);
      result["errorCode"] = response.statusCode;

      return result;
    });
  }

  static signInWithEmailAndPassword(String email, String password, String token) async {
    String apiUrl = 'delivery_user/login';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "email": email,
          "password": password,
          "fcmToken": token,
        }),
      );

      var result = json.decode(response.body);
      result["errorCode"] = response.statusCode;

      return result;
    });
  }

  static resendVerifyLink(String email, String password) async {
    String apiUrl = 'delivery_user/resend_verify_link';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"email": email, "password": password}),
      );
      var result = json.decode(response.body);
      result["errorCode"] = response.statusCode;

      return result;
    });
  }

  static updateUser(DeliveryUserModel deliveryUserModel, {File? imageFile}) async {
    String apiUrl = 'delivery_user/update/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var request = httpold.MultipartRequest("POST", Uri.parse(url));
      request.fields.addAll({"data": json.encode(deliveryUserModel.toJson())});

      var cmnHeaders = await commonHeaders();
      request.headers.addAll(cmnHeaders);

      if (imageFile != null) {
        Uint8List imageByteData = await imageFile.readAsBytes();
        request.files.add(
          httpold.MultipartFile.fromBytes(
            'image',
            imageByteData,
            filename: imageFile.path.split('/').last,
          ),
        );
      }

      var response = await request.send();
      // if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();

      return json.decode(result);
    });
  }

  static forgotPassword({@required String? email}) async {
    String apiUrl = 'delivery_user/forgot/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + email!;

      var response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      return json.decode(response.body);
    });
  }

  static verifyOTP({
    @required int? otp,
    @required String? email,
    @required String? newPassword,
    @required String? newPasswordConfirmation,
  }) async {
    String apiUrl = 'delivery_user/verify_otp/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"otp": otp, "email": email, "newPassword": newPassword, "newPasswordConfirmation": newPasswordConfirmation}),
      );
      return json.decode(response.body);
    });
  }

  static changePassword({
    @required String? email,
    @required String? oldPassword,
    @required String? newPassword,
  }) async {
    String apiUrl = 'delivery_user/changePassword/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "oldPassword": oldPassword,
          "newPassword": newPassword,
          "email": email,
        }),
      );
      return json.decode(response.body);
    });
  }

  static logout({
    @required String? id,
    @required String? fcmToken,
  }) async {
    String apiUrl = 'delivery_user/logout';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl + "?id=$id" + "&fcmToken=$fcmToken";

      var response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      return json.decode(response.body);
    });
  }

  static getOtherCreds() async {
    String apiUrl = 'delivery_user/otherCreds';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      return {
        "success": true,
        "data": json.decode(response.body),
      };
    });
  }

  static updateFreshChatRestoreId({@required String? restoreId}) async {
    String apiUrl = 'freshChat/updateRestoreId/';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "restoreId": restoreId,
        }),
      );
      return json.decode(response.body);
    });
  }

  static getMaintenance() async {
    String apiUrl = 'maintenance/active';
    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      return json.decode(response.body);
    });
  }
}
