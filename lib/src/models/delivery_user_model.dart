import 'dart:convert';

import "package:equatable/equatable.dart";

class DeliveryUserModel extends Equatable {
  String? id;
  String? imageUrl;
  String? firstName;
  String? lastName;
  String? email;
  String? mobile;
  String? password;
  bool? verified;
  bool? enabled;
  bool? phoneVerified;
  bool? isNewPhoneNumber;
  bool? isNotifiable;
  String? otp;
  String? otpExpires;
  List<dynamic>? deliveryPartnerIds;
  List<dynamic>? status;
  String? jwtToken;
  String? fcmToken;
  Map<String, dynamic>? freshChat;

  DeliveryUserModel({
    this.id = "",
    this.imageUrl = "",
    this.firstName = "",
    this.lastName = "",
    this.email = "",
    this.mobile = "",
    this.password = "",
    this.verified = false,
    this.enabled = false,
    this.phoneVerified = false,
    this.isNewPhoneNumber = false,
    this.isNotifiable = true,
    this.otp = "",
    this.otpExpires = "",
    this.deliveryPartnerIds,
    this.status,
    this.jwtToken = "",
    this.fcmToken = "",
    this.freshChat,
  });

  factory DeliveryUserModel.fromJson(Map<String, dynamic> map) {
    return DeliveryUserModel(
      id: map["_id"] ?? "",
      imageUrl: map["imageUrl"] ?? "",
      firstName: map["firstName"] ?? "",
      lastName: map["lastName"] ?? "",
      email: map["email"] ?? "",
      mobile: map["mobile"] ?? "",
      password: map["password"] ?? "",
      verified: map["verified"] ?? false,
      enabled: map["enabled"] ?? false,
      phoneVerified: map["phoneVerified"] ?? false,
      isNewPhoneNumber: map["isNewPhoneNumber"] ?? false,
      isNotifiable: map["isNotifiable"] ?? true,
      otp: map["otp"] ?? "",
      otpExpires: map["otpExpires"] ?? "",
      deliveryPartnerIds: map["deliveryPartnerIds"] ?? [],
      status: map["status"] ?? [],
      jwtToken: map["jwtToken"] ?? "",
      fcmToken: map["fcmToken"] ?? "",
      freshChat: map["freshChat"] ?? Map<String, dynamic>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id ?? "",
      "imageUrl": imageUrl ?? "",
      "firstName": firstName ?? "",
      "lastName": lastName ?? "",
      "email": email ?? "",
      "mobile": mobile ?? "",
      "password": password ?? "",
      "verified": verified ?? false,
      "enabled": enabled ?? false,
      "phoneVerified": phoneVerified ?? false,
      "isNewPhoneNumber": isNewPhoneNumber ?? false,
      "isNotifiable": isNotifiable ?? true,
      "otp": otp ?? "",
      "otpExpires": otpExpires ?? "",
      "deliveryPartnerIds": deliveryPartnerIds ?? [],
      "status": status ?? [],
      "jwtToken": jwtToken ?? "",
      "fcmToken": fcmToken ?? "",
      "freshChat": freshChat ?? Map<String, dynamic>(),
    };
  }

  factory DeliveryUserModel.copy(DeliveryUserModel userModel) {
    return DeliveryUserModel(
      id: userModel.id,
      imageUrl: userModel.imageUrl,
      firstName: userModel.firstName,
      lastName: userModel.lastName,
      email: userModel.email,
      mobile: userModel.mobile,
      password: userModel.password,
      verified: userModel.verified,
      enabled: userModel.enabled,
      phoneVerified: userModel.phoneVerified,
      isNewPhoneNumber: userModel.isNewPhoneNumber,
      isNotifiable: userModel.isNotifiable,
      otp: userModel.otp,
      otpExpires: userModel.otpExpires,
      deliveryPartnerIds: List.from(userModel.deliveryPartnerIds!),
      status: List.from(userModel.status!),
      jwtToken: userModel.jwtToken,
      fcmToken: userModel.fcmToken,
      freshChat: json.decode(json.encode(userModel.freshChat)),
    );
  }

  @override
  List<Object> get props => [
        id!,
        imageUrl!,
        firstName!,
        lastName!,
        email!,
        mobile!,
        password!,
        verified!,
        enabled!,
        phoneVerified!,
        isNewPhoneNumber!,
        isNotifiable!,
        otp!,
        otpExpires!,
        deliveryPartnerIds!,
        status!,
        jwtToken!,
        fcmToken!,
        freshChat!,
      ];

  @override
  bool get stringify => true;
}
