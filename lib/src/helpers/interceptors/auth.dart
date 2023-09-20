import 'dart:convert';

import 'package:http_interceptor/http_interceptor.dart';
import 'package:delivery_app/config/config.dart';
import 'package:delivery_app/src/helpers/http_plus.dart';
import 'package:delivery_app/src/providers/BridgeProvider/bridge_provider.dart';
import 'package:delivery_app/src/providers/BridgeProvider/bridge_state.dart';
import 'package:delivery_app/environment.dart';

class AuthInterceptor implements InterceptorContract {
  //Note:: URLs for which should not send token in any case.
  List<String> blacklist = [
    "user/login",
    "user/register",
    "user/resend_verify_link",
    "user/forgot",
    "user/verify_otp",
  ];

  @override
  Future<RequestData> interceptRequest({RequestData? data}) async {
    String currentRoute = data!.url.replaceAll(Environment.apiBaseUrl!, "");
    if (!blacklist.contains(currentRoute)) {
      String? authToken = await getAuthToken();
      if (authToken != null) {
        data.headers["Authorization"] = "Bearer " + authToken;
      }
    }

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({ResponseData? data}) async {
    if (data!.statusCode == 401) {
      var responseData = json.decode(data.body!);
      if (responseData['message'] == "jwt expired") {
        BridgeProvider().update(
          BridgeState(
            event: "log_out",
            data: {
              "message": "Invalid token",
            },
          ),
        );
      }
    }
    return data;
  }
}
