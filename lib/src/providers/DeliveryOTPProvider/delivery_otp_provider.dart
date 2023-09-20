import 'package:delivery_app/config/config.dart';
import 'package:delivery_app/src/ApiDataProviders/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'index.dart';

class DeliveryOTPProvider extends ChangeNotifier {
  static DeliveryOTPProvider of(BuildContext context, {bool listen = false}) => Provider.of<DeliveryOTPProvider>(context, listen: listen);

  DeliveryOTPState _deliveryOTPState = DeliveryOTPState.init();
  DeliveryOTPState get deliveryOTPState => _deliveryOTPState;

  void setDeliveryOTPState(DeliveryOTPState deliveryOTPState, {bool isNotifiable = true}) {
    if (_deliveryOTPState != deliveryOTPState) {
      _deliveryOTPState = deliveryOTPState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getOTP({@required String? orderId}) async {
    try {
      var result = await DeliveryOTPApiProvider.getOTP(orderId: orderId);

      if (result["success"]) {
        _deliveryOTPState = _deliveryOTPState.update(
          progressState: 2,
          customerDeliveryCode: result["data"]["customerDeliveryCode"],
          storeDeliveryCode: result["data"]["storeDeliveryCode"],
        );
      } else {
        _deliveryOTPState = _deliveryOTPState.update(progressState: -1, message: result["message"]);
      }
    } catch (e) {
      _deliveryOTPState = _deliveryOTPState.update(
        progressState: -1,
        message: e.toString(),
      );
    }
    notifyListeners();
  }
}
