import 'dart:convert';
import 'dart:io';

import 'package:delivery_app/environment.dart';
import 'package:delivery_app/src/entities/maintenance.dart';
import 'package:delivery_app/src/providers/BridgeProvider/bridge_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:delivery_app/src/ApiDataProviders/index.dart';
import 'package:delivery_app/src/models/index.dart';
import 'package:delivery_app/src/services/keicy_fcm_for_mobile.dart';
import 'package:delivery_app/src/services/keicy_firebase_auth.dart';

import '../index.dart';
import 'index.dart';

class AuthProvider extends ChangeNotifier {
  static AuthProvider of(BuildContext context, {bool listen = false}) => Provider.of<AuthProvider>(context, listen: listen);

  AuthState _authState = AuthState.init();
  AuthState get authState => _authState;

  String _rememberUserKey = "remember_me";
  String _otherCreds = "other_creds";

  void setAuthState(AuthState authState, {bool isNotifiable = true}) {
    if (_authState != authState) {
      _authState = authState;
      if (isNotifiable) notifyListeners();
    }
  }

  SharedPreferences? _prefs;
  SharedPreferences? get prefs => _prefs;

  void init() async {
    listenForFreshChatRestoreId();

    try {
      await KeicyFCMForMobile.init();
      _prefs = await SharedPreferences.getInstance();

      var rememberUserData = _prefs!.getString(_rememberUserKey) == null ? null : json.decode(_prefs!.getString(_rememberUserKey)!);
      if (rememberUserData != null) {
        // signInWithEmailAndPassword(
        //     email: rememberUserData["email"],
        //     password: rememberUserData["password"]);
        signInWithToken(rememberUserData);
      } else {
        _authState = _authState.update(
          progressState: 2,
          message: "",
          loginState: LoginState.IsNotLogin,
        );

        notifyListeners();
      }
    } catch (e) {
      FlutterLogs.logThis(
        tag: "auth_provider",
        level: LogLevel.ERROR,
        subTag: "init",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }

    // listenBridge();
  }

  listenBridge() {
    BridgeProvider().getStream().listen((event) {
      if (event.event == "log_out") {
        clearAuthState();
      }
    });
  }

  void signInWithToken(rememberUserData) async {
    var firebaseResult = await setUpAfterLogin(rememberUserData);

    if (firebaseResult["success"]) {
      _authState = _authState.update(
        progressState: 2,
        deliveryUserModel: DeliveryUserModel.fromJson(rememberUserData),
        message: "",
        loginState: LoginState.IsLogin,
      );

      updateChatRoomInfo(rememberUserData);

      _prefs!.setString(_rememberUserKey, json.encode(rememberUserData));
    } else {
      _authState = _authState.update(
        progressState: -1,
        message: "Something was wrong",
        errorCode: 500,
        loginState: LoginState.IsNotLogin,
      );
    }
    notifyListeners();
  }

  Future<Map<String, dynamic>> setUpAfterLogin(Map<String, dynamic> userData) async {
    try {
      Map<String, dynamic> otherCreds = await DeliveryUserApiProvider.getOtherCreds();
      await _prefs!.setString(_otherCreds, json.encode(otherCreds["data"]));
      Map<String, dynamic> firebaseResult = await KeicyAuthentication.instance.signInWithCustomToken(token: otherCreds["data"]["firebase"]["token"]);

      // getFBAppEvents().setUserID(userData["_id"]);
      // getFBAppEvents().setUserData(
      //   email: userData["email"],
      //   firstName: userData["firstName"],
      //   lastName: userData["lastName"],
      // );

      // getFirebaseAnalytics().setUserId(userData["_id"]);
      // getFirebaseAnalytics().setUserProperty(name: "role", value: "customer");

      Freshchat.setPushRegistrationToken(KeicyFCMForMobile.token!);
      Freshchat.identifyUser(
        externalId: userData["_id"],
        restoreId: userData["freshChat"] != null ? userData["freshChat"]["restoreId"] : null,
      );
      FreshchatUser freshchatUser = FreshchatUser(
        userData["_id"],
        userData["freshChat"] != null ? userData["freshChat"]["restoreId"] : null,
      );
      freshchatUser.setFirstName(userData["firstName"]);
      freshchatUser.setLastName(userData["lastName"]);
      freshchatUser.setEmail(userData["email"]);
      freshchatUser.setPhone("+91", userData["mobile"]);
      Freshchat.setUser(freshchatUser);
      Freshchat.setUserProperties({"role": "delivery_user"});

      return firebaseResult;
    } catch (e) {
      return {"success": false};
    }
  }

  void registerDeliveryUser(DeliveryUserModel deliveryUserModel) async {
    try {
      var result = await DeliveryUserApiProvider.registerDeliveryUser(deliveryUserModel);
      if (result["success"]) {
        _authState = _authState.update(
          progressState: 2,
          deliveryUserModel: DeliveryUserModel.fromJson(result["data"]),
          message: "",
          loginState: LoginState.IsNotLogin,
          errorCode: result["errorCode"] ?? 500,
        );
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
          loginState: LoginState.IsNotLogin,
          errorCode: result["errorCode"] ?? 500,
        );
      }
    } catch (e) {
      _authState = _authState.update(
        progressState: -1,
        message: e.toString(),
        loginState: LoginState.IsNotLogin,
        errorCode: 500,
      );
    }

    notifyListeners();
  }

  void listenForFreshChatRestoreId() {
    var restoreStream = Freshchat.onRestoreIdGenerated;
    restoreStream.listen((event) async {
      FreshchatUser user = await Freshchat.getUser;
      var restoreId = user.getRestoreId();
      String previousRestoreId = _authState.deliveryUserModel!.freshChat != null ? _authState.deliveryUserModel!.freshChat!["restoreId"] : null;
      if (restoreId != previousRestoreId) {
        await DeliveryUserApiProvider.updateFreshChatRestoreId(
          restoreId: restoreId,
        );
      }
    });
  }

  void signInWithEmailAndPassword({@required String? email, @required String? password}) async {
    try {
      var result = await DeliveryUserApiProvider.signInWithEmailAndPassword(email!, password!, KeicyFCMForMobile.token!);
      if (result["success"] && result["data"]["enabled"]) {
        for (var i = 0; i < result["data"]["status"].length; i++) {
          if (result["data"]["status"][i]["fcmToken"] == KeicyFCMForMobile.token) {
            result["data"]["fcmToken"] = result["data"]["status"][i]["fcmToken"];
            result["data"]["jwtToken"] = result["data"]["status"][i]["jwtToken"];
          }
        }

        _prefs!.setString(_rememberUserKey, json.encode(result["data"]));

        var firebaseResult = await setUpAfterLogin(result["data"]);

        if (firebaseResult["success"]) {
          if (Environment.enableFreshChatEvents!) {
            Freshchat.trackEvent("loggedin");
          }
          _authState = _authState.update(
            progressState: 2,
            deliveryUserModel: DeliveryUserModel.fromJson(result["data"]),
            message: "",
            loginState: LoginState.IsLogin,
            errorCode: result["errorCode"] ?? 500,
          );

          updateChatRoomInfo(result["data"]);
        } else {
          _authState = _authState.update(
            progressState: -1,
            message: "Something was wrong",
            errorCode: result["errorCode"] ?? 500,
            loginState: LoginState.IsNotLogin,
          );
        }
      } else if (result["success"] && !result["data"]["enabled"]) {
        _authState = _authState.update(
          progressState: -1,
          message: "You are not enabled as a delivery person yet. Please ask admin team to enable it",
          loginState: LoginState.IsNotLogin,
        );
      } else {
        // if (result["errorCode"] == 401) {
        //   _prefs!.setString(_rememberUserKey, json.encode(null));
        // }
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
          errorCode: result["errorCode"] ?? 500,
          loginState: LoginState.IsNotLogin,
        );
      }
    } catch (e) {
      _authState = _authState.update(
        progressState: -1,
        message: e.toString(),
        loginState: LoginState.IsNotLogin,
        errorCode: 500,
      );
    }

    notifyListeners();
  }

  void resendVerifyLink({@required String? email, @required String? password}) async {
    try {
      var result = await DeliveryUserApiProvider.resendVerifyLink(email!, password!);
      if (result["success"]) {
        _authState = _authState.update(
          progressState: 2,
          message: "",
          loginState: LoginState.IsNotLogin,
        );
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
          errorCode: result["errorCode"],
          loginState: LoginState.IsNotLogin,
        );
      }
    } catch (e) {
      _authState = _authState.update(
        progressState: -1,
        message: e.toString(),
        loginState: LoginState.IsNotLogin,
      );
    }

    notifyListeners();
  }

  Future<void> updateUser(DeliveryUserModel deliveryUserModel, {File? imageFile}) async {
    try {
      var result = await DeliveryUserApiProvider.updateUser(deliveryUserModel, imageFile: imageFile);
      if (result["success"]) {
        _authState = _authState.update(
          progressState: 2,
          deliveryUserModel: DeliveryUserModel.fromJson(result["data"]),
          message: "",
        );
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _authState = _authState.update(
        progressState: -1,
        message: e.toString(),
      );
    }

    notifyListeners();
  }

  void forgotPassword({@required String? email}) async {
    try {
      var result = await DeliveryUserApiProvider.forgotPassword(email: email);
      if (result["success"]) {
        _authState = _authState.update(
          progressState: 3,
          message: "",
        );
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _authState = _authState.update(
        progressState: -1,
        message: e.toString(),
      );
    }

    notifyListeners();
  }

  void verifyOTP({
    @required int? otp,
    @required String? email,
    @required String? newPassword,
    @required String? newPasswordConfirmation,
  }) async {
    try {
      var result = await DeliveryUserApiProvider.verifyOTP(
        otp: otp,
        email: email,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );
      if (result["success"]) {
        _authState = _authState.update(
          progressState: 4,
          message: "",
        );
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _authState = _authState.update(
        progressState: -1,
        message: e.toString(),
      );
    }

    notifyListeners();
  }

  void changePassword({@required String? email, String? oldPassword, @required String? newPassword}) async {
    try {
      var result = await DeliveryUserApiProvider.changePassword(email: email, oldPassword: oldPassword, newPassword: newPassword);
      if (result["success"]) {
        _authState = _authState.update(
          progressState: 5,
          message: "",
        );
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _authState = _authState.update(
        progressState: -1,
        message: e.toString(),
      );
    }

    notifyListeners();
  }

  Future<bool> addContact({@required ContactModel? contactModel}) async {
    try {
      var result = await ContactApiProvider.createContact(contactModel: contactModel);
      if (result["success"]) {
        _authState = _authState.update(
          progressState: 2,
          message: "",
        );
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _authState = _authState.update(
        progressState: -1,
        message: e.toString(),
      );
    }

    notifyListeners();
    return _authState.progressState == 2;
  }

  Future<bool> logout({@required String? id, @required String? fcmToken}) async {
    try {
      var result = await DeliveryUserApiProvider.logout(id: id, fcmToken: fcmToken);
      if (result["success"]) {
        _prefs!.setString(_rememberUserKey, json.encode(null));
        _authState = _authState.update(
          progressState: 2,
          message: "",
          loginState: LoginState.IsNotLogin,
          deliveryUserModel: DeliveryUserModel(),
        );
      } else {
        _authState = _authState.update(
          progressState: -1,
          message: result["message"],
        );
      }
    } catch (e) {
      _authState = _authState.update(
        progressState: -1,
        message: e.toString(),
      );
    }

    return _authState.progressState == 2;
  }

  clearAuthState() {
    Freshchat.resetUser();
    if (Environment.enableFreshChatEvents!) {
      Freshchat.trackEvent("loggedout");
    }
    _prefs!.setString(_rememberUserKey, json.encode(null));
    _authState = _authState.update(
      progressState: 2,
      message: "",
      loginState: LoginState.IsNotLogin,
      deliveryUserModel: DeliveryUserModel(),
    );
    notifyListeners();
  }

  void updateChatRoomInfo(Map<String, dynamic> deliveryData) async {
    try {
      var result = await ChatRoomFirestoreProvider.getChatRoomsData(
        chatRoomType: ChatRoomTypes.d2c,
        wheres: [
          {"key": "ids", "cond": "arrayContains", "val": "Delivery-${deliveryData["_id"]}"}
        ],
      );

      if (result["success"]) {
        for (var i = 0; i < result["data"].length; i++) {
          if (result["data"][i]["firstUserData"]["_id"] == deliveryData["_id"]) {
            result["data"][i]["firstUserName"] = ChatProvider.getChatUserName(
              userType: result["data"][i]["firstUserType"],
              userData: deliveryData,
            );
            result["data"][i]["firstUserData"] = await ChatProvider.convertChatUserData(
              userType: result["data"][i]["firstUserType"],
              userData: deliveryData,
            );
          } else {
            result["data"][i]["secondUserName"] = ChatProvider.getChatUserName(
              userType: result["data"][i]["secondUserType"],
              userData: deliveryData,
            );
            result["data"][i]["secondUserData"] = await ChatProvider.convertChatUserData(
              userType: result["data"][i]["secondUserType"],
              userData: deliveryData,
            );
          }

          ChatRoomFirestoreProvider.updateChatRoom(
            chatRoomType: result["data"][i]["type"],
            id: result["data"][i]["id"],
            data: result["data"][i],
            changeUpdateAt: false,
          );
        }
      }
    } catch (e) {
      FlutterLogs.logThis(
        tag: "auth_provider",
        level: LogLevel.ERROR,
        subTag: "updateChatRoomInfo",
        exception: e is Exception ? e : null,
        error: e is Error ? e : null,
        errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
      );
    }
  }

  Future<Maintenance?> checkForMaintenance() async {
    dynamic maintenanceResponse = await DeliveryUserApiProvider.getMaintenance();
    if (maintenanceResponse["status"]) {
      return Maintenance.fromJson(maintenanceResponse["data"]);
    }
    return null;
  }
}
