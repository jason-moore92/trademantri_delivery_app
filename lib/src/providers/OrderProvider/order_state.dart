import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class OrderState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? dashboardData;
  final List<dynamic>? orderListData;
  final Map<String, dynamic>? orderMetaData;
  final bool? isRefresh;

  OrderState({
    @required this.progressState,
    @required this.message,
    @required this.dashboardData,
    @required this.orderListData,
    @required this.orderMetaData,
    @required this.isRefresh,
  });

  factory OrderState.init() {
    return OrderState(
      progressState: 0,
      message: "",
      dashboardData: Map<String, dynamic>(),
      orderListData: [],
      orderMetaData: Map<String, dynamic>(),
      isRefresh: false,
    );
  }

  OrderState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? dashboardData,
    List<dynamic>? orderListData,
    Map<String, dynamic>? orderMetaData,
    bool? isRefresh,
  }) {
    return OrderState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      dashboardData: dashboardData ?? this.dashboardData,
      orderListData: orderListData ?? this.orderListData,
      orderMetaData: orderMetaData ?? this.orderMetaData,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }

  OrderState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? dashboardData,
    List<dynamic>? orderListData,
    Map<String, dynamic>? orderMetaData,
    bool? isRefresh,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      dashboardData: dashboardData,
      orderListData: orderListData,
      orderMetaData: orderMetaData,
      isRefresh: isRefresh,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "dashboardData": dashboardData,
      "orderListData": orderListData,
      "orderMetaData": orderMetaData,
      "isRefresh": isRefresh,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        dashboardData!,
        orderListData!,
        orderMetaData!,
        isRefresh!,
      ];

  @override
  bool get stringify => true;
}
