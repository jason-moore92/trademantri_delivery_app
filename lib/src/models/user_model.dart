import "package:equatable/equatable.dart";

class UserModel extends Equatable {
  String? id;
  String? imageUrl;
  String? firstName;
  String? lastName;
  String? email;
  String? mobile;
  String? password;
  String? referralCode;
  String? referredBy;
  bool? isNotifiable;
  bool? verified;
  bool? phoneVerified;
  bool? isNewPhoneNumber;
  String? role;
  List<dynamic>? extraRoles;
  int? loginAttempts;
  String? registeredVia;
  String? otp;
  String? otpExpires;
  List<dynamic>? status;
  String? createdAt;
  String? updatedAt;
  String? jwtToken;
  String? fcmToken;
  Map<String, dynamic>? freshChat;

  UserModel({
    this.id,
    this.role = "user",
    this.extraRoles = const [],
    this.verified = false,
    this.phoneVerified = false,
    this.isNewPhoneNumber = false,
    this.loginAttempts = 0,
    this.registeredVia = "",
    this.imageUrl = "",
    this.firstName = "",
    this.lastName = "",
    this.email = "",
    this.mobile = "",
    this.password = "",
    this.referralCode = "",
    this.referredBy = "",
    this.isNotifiable = true,
    this.otp = "",
    this.otpExpires = "",
    this.status,
    this.createdAt,
    this.updatedAt,
    this.jwtToken,
    this.fcmToken,
    this.freshChat,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map["_id"] ?? null,
      role: map["role"] ?? "user",
      extraRoles: map["extraRoles"] ?? [],
      verified: map["verified"] ?? false,
      phoneVerified: map["phoneVerified"] ?? false,
      isNewPhoneNumber: map["isNewPhoneNumber"] ?? false,
      loginAttempts: map["loginAttempts"] ?? 0,
      registeredVia: map["registeredVia"] ?? "",
      imageUrl: map["imageUrl"] ?? "",
      firstName: map["firstName"] ?? "",
      lastName: map["lastName"] ?? "",
      email: map["email"] ?? "",
      mobile: map["mobile"] ?? "",
      password: map["password"] ?? "",
      referralCode: map["referralCode"] ?? "",
      referredBy: map["referredBy"] ?? "",
      isNotifiable: map["isNotifiable"] ?? true,
      otp: map["otp"] ?? "",
      otpExpires: map["otpExpires"] ?? "",
      status: map["status"] ?? [],
      createdAt: map["createdAt"] ?? "",
      updatedAt: map["updatedAt"] ?? "",
      jwtToken: map["jwtToken"] ?? "",
      fcmToken: map["fcmToken"] ?? "",
      freshChat: map["freshChat"] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id ?? null,
      "role": role ?? "user",
      "extraRoles": extraRoles ?? [],
      "verified": verified ?? false,
      "phoneVerified": phoneVerified ?? false,
      "isNewPhoneNumber": isNewPhoneNumber ?? false,
      "loginAttempts": loginAttempts ?? 0,
      "registeredVia": registeredVia ?? "",
      "imageUrl": imageUrl ?? "",
      "firstName": firstName ?? "",
      "lastName": lastName ?? "",
      "email": email ?? "",
      "mobile": mobile ?? "",
      "password": password ?? "",
      "referralCode": referralCode ?? "",
      "referredBy": referredBy ?? "",
      "isNotifiable": isNotifiable ?? true,
      "otp": otp ?? "",
      "otpExpires": otpExpires ?? "",
      "status": status ?? [],
      "createdAt": createdAt ?? "",
      "updatedAt": updatedAt ?? "",
      "jwtToken": jwtToken ?? "",
      "fcmToken": fcmToken ?? "",
      "freshChat": freshChat ?? "",
    };
  }

  factory UserModel.copy(UserModel userModel) {
    return UserModel(
      id: userModel.id,
      role: userModel.role,
      extraRoles: userModel.extraRoles,
      verified: userModel.verified,
      phoneVerified: userModel.phoneVerified,
      isNewPhoneNumber: userModel.isNewPhoneNumber,
      loginAttempts: userModel.loginAttempts,
      registeredVia: userModel.registeredVia,
      imageUrl: userModel.imageUrl,
      firstName: userModel.firstName,
      lastName: userModel.lastName,
      email: userModel.email,
      mobile: userModel.mobile,
      password: userModel.password,
      referralCode: userModel.referralCode,
      referredBy: userModel.referredBy,
      isNotifiable: userModel.isNotifiable,
      otp: userModel.otp,
      otpExpires: userModel.otpExpires,
      status: userModel.status,
      createdAt: userModel.createdAt,
      updatedAt: userModel.updatedAt,
      jwtToken: userModel.jwtToken,
      fcmToken: userModel.fcmToken,
      freshChat: userModel.freshChat,
    );
  }

  @override
  List<Object> get props => [
        id ?? Object(),
        role!,
        extraRoles!,
        verified!,
        phoneVerified!,
        isNewPhoneNumber!,
        loginAttempts!,
        registeredVia!,
        imageUrl!,
        firstName!,
        lastName!,
        email!,
        mobile!,
        password!,
        referralCode!,
        referredBy!,
        isNotifiable!,
        otp!,
        otpExpires!,
        status!,
        createdAt!,
        updatedAt!,
        jwtToken!,
        fcmToken!,
        freshChat!,
      ];

  @override
  bool get stringify => true;
}
