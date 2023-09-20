import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class MyDeliveryOrderState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final List<dynamic>? myDeliveryOrderListData;
  final Map<String, dynamic>? myDeliveryOrderMetaData;
  final bool? isRefresh;
  final int? totalMyDeliveryOrders;

  MyDeliveryOrderState({
    @required this.progressState,
    @required this.message,
    @required this.myDeliveryOrderListData,
    @required this.myDeliveryOrderMetaData,
    @required this.isRefresh,
    @required this.totalMyDeliveryOrders,
  });

  factory MyDeliveryOrderState.init() {
    return MyDeliveryOrderState(
      progressState: 0,
      message: "",
      myDeliveryOrderListData: [],
      myDeliveryOrderMetaData: Map<String, dynamic>(),
      isRefresh: false,
      totalMyDeliveryOrders: 0,
    );
  }

  MyDeliveryOrderState copyWith({
    int? progressState,
    String? message,
    List<dynamic>? myDeliveryOrderListData,
    Map<String, dynamic>? myDeliveryOrderMetaData,
    bool? isRefresh,
    int? totalMyDeliveryOrders,
  }) {
    return MyDeliveryOrderState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      myDeliveryOrderListData: myDeliveryOrderListData ?? this.myDeliveryOrderListData,
      myDeliveryOrderMetaData: myDeliveryOrderMetaData ?? this.myDeliveryOrderMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
      totalMyDeliveryOrders: totalMyDeliveryOrders ?? this.totalMyDeliveryOrders,
    );
  }

  MyDeliveryOrderState update({
    int? progressState,
    String? message,
    List<dynamic>? myDeliveryOrderListData,
    Map<String, dynamic>? myDeliveryOrderMetaData,
    bool? isRefresh,
    int? totalMyDeliveryOrders,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      myDeliveryOrderListData: myDeliveryOrderListData,
      myDeliveryOrderMetaData: myDeliveryOrderMetaData,
      isRefresh: isRefresh,
      totalMyDeliveryOrders: totalMyDeliveryOrders,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "myDeliveryOrderListData": myDeliveryOrderListData,
      "myDeliveryOrderMetaData": myDeliveryOrderMetaData,
      "isRefresh": isRefresh,
      "totalMyDeliveryOrders": totalMyDeliveryOrders,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        myDeliveryOrderListData!,
        myDeliveryOrderMetaData!,
        isRefresh!,
        totalMyDeliveryOrders!,
      ];

  @override
  bool get stringify => true;
}
