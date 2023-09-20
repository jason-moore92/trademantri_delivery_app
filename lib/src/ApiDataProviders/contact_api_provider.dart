import 'dart:convert';

import 'package:delivery_app/environment.dart';
import 'package:flutter/material.dart';
import 'package:delivery_app/src/helpers/http_plus.dart';
import 'package:delivery_app/src/models/index.dart';

class ContactApiProvider {
  static createContact({@required ContactModel? contactModel}) async {
    String apiUrl = 'contact/add';

    return httpExceptionWrapper(() async {
      String url = Environment.apiBaseUrl! + apiUrl;

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(contactModel!.toJson()),
      );
      return json.decode(response.body);
    });
  }
}
