import 'package:delivery_app/config/config.dart';
import 'package:delivery_app/src/ApiDataProviders/index.dart';
import 'package:delivery_app/src/models/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'index.dart';

class OrderProvider extends ChangeNotifier {
  static OrderProvider of(BuildContext context, {bool listen = false}) => Provider.of<OrderProvider>(context, listen: listen);

  OrderState _orderState = OrderState.init();
  OrderState get orderState => _orderState;

  void setOrderState(OrderState orderState, {bool isNotifiable = true}) {
    if (_orderState != orderState) {
      _orderState = orderState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getOrderData({
    @required double? lat,
    @required double? lng,
    @required String? deliveryUserId,
    @required List<dynamic>? deliveryPartnerIds,
    String searchKey = "",
  }) async {
    List<dynamic>? orderListData = _orderState.orderListData;
    Map<String, dynamic>? orderMetaData = _orderState.orderMetaData;
    try {
      if (orderListData == null) orderListData = [];
      if (orderMetaData == null) orderMetaData = Map<String, dynamic>();

      var result;

      result = await OrderApiProvider.getDeliveryOrderData(
        lat: lat,
        lng: lng,
        deliveryUserId: deliveryUserId,
        deliveryPartnerIds: deliveryPartnerIds,
        searchKey: searchKey,
        page: orderMetaData.isEmpty ? 1 : (orderMetaData["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
        // limit: 1,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          orderListData.add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        orderMetaData = result["data"];

        _orderState = _orderState.update(
          progressState: 2,
          orderListData: orderListData,
          orderMetaData: orderMetaData,
        );
      } else {
        _orderState = _orderState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _orderState = _orderState.update(
        progressState: 2,
      );
    }
    notifyListeners();
  }

  Future<dynamic> updateOrderData({
    @required OrderModel? orderModel,
    @required String? status,
    bool changedStatus = false,
  }) async {
    /// order_accepted
    if (status == AppConfig.orderStatusData[2]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Order Accepted"});
      orderModel.orderFutureSteps!.removeWhere((element) => element["text"] == "Order Accepted");
    }

    /// order_paid
    if (status == AppConfig.orderStatusData[3]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Order Paid"});
      orderModel.orderFutureSteps!.removeWhere((element) => element["text"] == "Order Paid");
    }

    /// pickup_ready
    if (status == AppConfig.orderStatusData[4]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Pickup Ready"});
      orderModel.orderFutureSteps!.removeWhere((element) => element["text"] == "Pickup Ready");
    }

    /// delivery_ready
    if (status == AppConfig.orderStatusData[5]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Delivery Ready"});
      orderModel.orderFutureSteps!.removeWhere((element) => element["text"] == "Delivery Ready");
    }

    /// delivered
    if (status == AppConfig.orderStatusData[6]["id"] ||
        status == "items_delivery_complete" ||
        status == "delivery_complete" ||
        status == "payment_received") {
      orderModel!.orderHistorySteps!.add({"text": "Delivery done"});
      orderModel.orderFutureSteps!.removeWhere((element) => element["text"] == "Delivery done");
    }

    /// order_cancelled
    if (status == AppConfig.orderStatusData[7]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Order Cancelled"});
      orderModel.orderFutureSteps = [];
    }

    /// order_rejected
    if (status == AppConfig.orderStatusData[8]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Order Rejected"});
      orderModel.orderFutureSteps = [];
    }

    /// order_completed
    if (status == AppConfig.orderStatusData[9]["id"]) {
      orderModel!.orderHistorySteps!.add({"text": "Order Completed"});
      orderModel.orderFutureSteps = [];
    }

    /// order_completed
    if (status == "delivery_pickup_completed") {
      orderModel!.orderHistorySteps!.add({"text": "Items Picked"});
      orderModel.orderFutureSteps!.removeWhere((element) => element["text"] == "Items Picked");
    }

    var result = await OrderApiProvider.updateOrderData(
      orderData: orderModel!.toJson(),
      status: status,
      changedStatus: changedStatus,
    );

    return result;
  }
}
