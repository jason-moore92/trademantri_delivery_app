import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:delivery_app/config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivery_app/src/ApiDataProviders/index.dart';

import 'index.dart';

class NotificationProvider extends ChangeNotifier {
  static NotificationProvider of(BuildContext context, {bool listen = false}) => Provider.of<NotificationProvider>(context, listen: listen);

  NotificationState _notificationState = NotificationState.init();
  NotificationState get notificationState => _notificationState;

  void setNotificationState(NotificationState notificationState, {bool isNotifiable = true}) {
    if (_notificationState != notificationState) {
      _notificationState = notificationState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> getNotificationData({
    @required String? deliveryUserId,
    @required String? status,
    String searchKey = "",
  }) async {
    Map<String, dynamic>? notificationListData = _notificationState.notificationListData;
    Map<String, dynamic>? notificationMetaData = _notificationState.notificationMetaData;
    try {
      if (notificationListData![status] == null) notificationListData[status!] = [];
      if (notificationMetaData![status] == null) notificationMetaData[status!] = Map<String, dynamic>();

      var result;

      result = await NotificationApiProvider.getNotificationData(
        deliveryUserId: deliveryUserId,
        status: status,
        searchKey: searchKey,
        page: notificationMetaData[status].isEmpty ? 1 : (notificationMetaData[status]["nextPage"] ?? 1),
        limit: AppConfig.countLimitForList,
        // limit: 1,
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"]["docs"].length; i++) {
          notificationListData[status].add(result["data"]["docs"][i]);
        }
        result["data"].remove("docs");
        notificationMetaData[status!] = result["data"];

        _notificationState = _notificationState.update(
          progressState: 2,
          notificationListData: notificationListData,
          notificationMetaData: notificationMetaData,
        );
      } else {
        _notificationState = _notificationState.update(
          progressState: 2,
        );
      }
    } catch (e) {
      _notificationState = _notificationState.update(
        progressState: 2,
      );
    }
    Future.delayed(Duration(milliseconds: 500), () {
      notifyListeners();
    });
  }
}
