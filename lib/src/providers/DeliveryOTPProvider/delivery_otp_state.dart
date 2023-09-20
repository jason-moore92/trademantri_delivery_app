import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

class DeliveryOTPState extends Equatable {
  final int? progressState; // 0: init, 1: progressing, 2: success, 3: failed
  final String? message;
  final String? storeDeliveryCode;
  final String? customerDeliveryCode;

  DeliveryOTPState({
    @required this.progressState,
    @required this.message,
    @required this.storeDeliveryCode,
    @required this.customerDeliveryCode,
  });

  factory DeliveryOTPState.init() {
    return DeliveryOTPState(
      progressState: 0,
      message: "",
      storeDeliveryCode: "",
      customerDeliveryCode: "",
    );
  }

  DeliveryOTPState copyWith({
    int? progressState,
    String? message,
    String? storeDeliveryCode,
    String? customerDeliveryCode,
  }) {
    return DeliveryOTPState(
      progressState: progressState ?? this.progressState,
      message: message ?? this.message,
      storeDeliveryCode: storeDeliveryCode ?? this.storeDeliveryCode,
      customerDeliveryCode: customerDeliveryCode ?? this.customerDeliveryCode,
    );
  }

  DeliveryOTPState update({
    int? progressState,
    String? message,
    String? storeDeliveryCode,
    String? customerDeliveryCode,
  }) {
    return copyWith(
      progressState: progressState,
      message: message,
      storeDeliveryCode: storeDeliveryCode,
      customerDeliveryCode: customerDeliveryCode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "message": message,
      "storeDeliveryCode": storeDeliveryCode,
      "customerDeliveryCode": customerDeliveryCode,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        message!,
        storeDeliveryCode!,
        customerDeliveryCode!,
      ];

  @override
  bool get stringify => true;
}
