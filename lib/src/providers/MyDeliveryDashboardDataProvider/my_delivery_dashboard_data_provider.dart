import 'package:delivery_app/config/config.dart';
import 'package:delivery_app/src/ApiDataProviders/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'index.dart';

class MyDeliveryDashboardDataProvider extends ChangeNotifier {
  static MyDeliveryDashboardDataProvider of(BuildContext context, {bool listen = false}) =>
      Provider.of<MyDeliveryDashboardDataProvider>(context, listen: listen);

  MyDeliveryDashboardDataState _myDeliveryDashboardDataState = MyDeliveryDashboardDataState.init();
  MyDeliveryDashboardDataState get myDeliveryDashboardDataState => _myDeliveryDashboardDataState;

  void setMyDeliveryDashboardDataState(MyDeliveryDashboardDataState myDeliveryDashboardDataState, {bool isNotifiable = true}) {
    if (_myDeliveryDashboardDataState != myDeliveryDashboardDataState) {
      _myDeliveryDashboardDataState = myDeliveryDashboardDataState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getMyDeliveryDashboardDataData({@required String? deliveryUserId}) async {
    try {
      var result = await OrderApiProvider.getMyDeliveryDashboardData(deliveryUserId: deliveryUserId);

      if (result["success"]) {
        _myDeliveryDashboardDataState = _myDeliveryDashboardDataState.update(
          progressState: 2,
          dashboardData: result["data"],
        );
      } else {
        _myDeliveryDashboardDataState = _myDeliveryDashboardDataState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _myDeliveryDashboardDataState = _myDeliveryDashboardDataState.update(
        progressState: 2,
      );
    }

    notifyListeners();
  }
}
