import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class MyDeliveryDashboardDataState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final Map<String, dynamic>? dashboardData;

  MyDeliveryDashboardDataState({
    @required this.progressState,
    @required this.message,
    @required this.dashboardData,
  });

  factory MyDeliveryDashboardDataState.init() {
    return MyDeliveryDashboardDataState(
      progressState: 0,
      message: "",
      dashboardData: Map<String, dynamic>(),
    );
  }

  MyDeliveryDashboardDataState copyWith({
    int? progressState,
    String? message,
    Map<String, dynamic>? dashboardData,
  }) {
    return MyDeliveryDashboardDataState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      dashboardData: dashboardData ?? this.dashboardData,
    );
  }

  MyDeliveryDashboardDataState update({
    int? progressState,
    String? message,
    Map<String, dynamic>? dashboardData,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      dashboardData: dashboardData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "dashboardData": dashboardData,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        dashboardData!,
      ];

  @override
  bool get stringify => true;
}
