import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:delivery_app/src/models/index.dart';

enum LoginState {
  IsLogin,
  IsNotLogin,
}

class AuthState extends Equatable {
  final int? progressState;
  final String? message;
  final int? errorCode;
  final LoginState? loginState;
  final DeliveryUserModel? deliveryUserModel;
  final Function? callback;

  AuthState({
    @required this.message,
    @required this.errorCode,
    @required this.progressState,
    @required this.loginState,
    @required this.deliveryUserModel,
    @required this.callback,
  });

  factory AuthState.init() {
    return AuthState(
      errorCode: 0,
      progressState: 0,
      message: "",
      loginState: LoginState.IsNotLogin,
      deliveryUserModel: DeliveryUserModel(),
      callback: () {},
    );
  }

  AuthState copyWith({
    int? progressState,
    int? errorCode,
    String? message,
    LoginState? loginState,
    DeliveryUserModel? deliveryUserModel,
    Function? callback,
  }) {
    return AuthState(
      progressState: progressState ?? this.progressState,
      errorCode: errorCode ?? this.errorCode,
      message: message ?? this.message,
      loginState: loginState ?? this.loginState,
      deliveryUserModel: deliveryUserModel ?? this.deliveryUserModel,
      callback: callback ?? this.callback,
    );
  }

  AuthState update({
    int? progressState,
    int? errorCode,
    String? message,
    LoginState? loginState,
    DeliveryUserModel? deliveryUserModel,
    Function? callback,
  }) {
    return copyWith(
      progressState: progressState,
      errorCode: errorCode,
      message: message,
      loginState: loginState,
      deliveryUserModel: deliveryUserModel,
      callback: callback,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "progressState": progressState,
      "errorCode": errorCode,
      "message": message,
      "loginState": loginState,
      "deliveryUserModel": deliveryUserModel,
      "callback": callback,
    };
  }

  @override
  List<Object> get props => [
        progressState!,
        errorCode!,
        message!,
        loginState!,
        deliveryUserModel!,
        callback!,
      ];

  @override
  bool get stringify => true;
}
