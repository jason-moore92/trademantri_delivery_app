import 'package:delivery_app/config/config.dart';
import 'package:delivery_app/src/ApiDataProviders/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'index.dart';

class MyDeliveryOrderProvider extends ChangeNotifier {
  static MyDeliveryOrderProvider of(BuildContext context, {bool listen = false}) => Provider.of<MyDeliveryOrderProvider>(context, listen: listen);

  MyDeliveryOrderState _myDeliveryOrderState = MyDeliveryOrderState.init();
  MyDeliveryOrderState get myDeliveryOrderState => _myDeliveryOrderState;

  void setMyDeliveryOrderState(MyDeliveryOrderState myDeliveryOrderState, {bool isNotifiable = true}) {
    if (_myDeliveryOrderState != myDeliveryOrderState) {
      _myDeliveryOrderState = myDeliveryOrderState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getMyDeliveryOrderData({
    @required double? lat,
    @required double? lng,
    @required String? deliveryUserId,
    String searchKey = "",
    int limit = AppConfig.countLimitForList,
  }) async {
    List<dynamic>? myDeliveryOrderListData = _myDeliveryOrderState.myDeliveryOrderListData;
    Map<String, dynamic>? myDeliveryOrderMetaData = _myDeliveryOrderState.myDeliveryOrderMetaData;
    try {
      if (myDeliveryOrderListData == null) myDeliveryOrderListData = [];
      if (myDeliveryOrderMetaData == null) myDeliveryOrderMetaData = Map<String, dynamic>();

      var result;

      result = await OrderApiProvider.getMyDeliveryOrderData(
        lat: lat,
        lng: lng,
        deliveryUserId: deliveryUserId,
        searchKey: searchKey,
        page: myDeliveryOrderMetaData.isEmpty ? 1 : (myDeliveryOrderMetaData["nextPage"] ?? 1),
        limit: limit,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          myDeliveryOrderListData.add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        myDeliveryOrderMetaData = result["data"];

        _myDeliveryOrderState = _myDeliveryOrderState.update(
          progressState: 2,
          myDeliveryOrderListData: myDeliveryOrderListData,
          myDeliveryOrderMetaData: myDeliveryOrderMetaData,
          totalMyDeliveryOrders: result["data"]["totalDocs"],
        );
      } else {
        _myDeliveryOrderState = _myDeliveryOrderState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _myDeliveryOrderState = _myDeliveryOrderState.update(
        progressState: 2,
      );
    }
    Future.delayed(Duration(milliseconds: 500), () {
      notifyListeners();
    });
  }
}
