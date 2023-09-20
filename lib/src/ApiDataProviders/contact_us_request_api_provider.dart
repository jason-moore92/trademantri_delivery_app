import 'dart:convert';

import 'package:delivery_app/environment.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as httpold;
import 'package:delivery_app/src/helpers/http_plus.dart';

class ContactUsRequestApiProvider {
  static addContactUsRequest({@required Map<String, dynamic>? contactUsRequestData}) async {
    String apiUrl = 'contactUsRequest/add/';

    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;
      contactUsRequestData!["category"] = "delivery-app";

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(contactUsRequestData),
      );
      return json.decode(response.body);
    });
  }
}
