import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:delivery_app/config/config.dart';
import 'package:delivery_app/src/dialogs/index.dart';
import 'package:delivery_app/src/elements/keicy_progress_dialog.dart';
import 'package:delivery_app/src/models/index.dart';
import 'package:delivery_app/src/pages/OrderDetailPage/order_detail_page.dart';
import 'package:delivery_app/src/providers/index.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:random_string/random_string.dart';
import 'dart:ui' as ui;

import 'index.dart';

class DeliveryMapViewView extends StatefulWidget {
  final OrderModel? orderModel;

  DeliveryMapViewView({Key? key, this.orderModel}) : super(key: key);

  @override
  _DeliveryMapViewViewState createState() => _DeliveryMapViewViewState();
}

class _DeliveryMapViewViewState extends State<DeliveryMapViewView> with SingleTickerProviderStateMixin {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double heightDp1 = 0;
  double fontSp = 0;
  ///////////////////////////////

  Completer<GoogleMapController> _mapController = Completer();

  Map<MarkerId, Marker> _markers = Map<MarkerId, Marker>();
  // Map<PolylineId, Polyline> _polyLines = Map<PolylineId, Polyline>();

  MarkerId? _storeMarkerId;
  MarkerId? _deliveryMarkerId;
  BitmapDescriptor? _startMarkerIcon;
  BitmapDescriptor? _delieryMarkerIcon;

  LatLng? _storeLocationPosition;
  LatLng? _deliveryLocationPosition;

  OrderProvider? _orderProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  OrderModel? _orderModel;

  bool? _isUpdated;
  String? _deliveryStatus;

  @override
  void initState() {
    super.initState();

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    bottomBarHeight = ScreenUtil().bottomBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    _orderModel = OrderModel.copy(widget.orderModel!);

    _storeLocationPosition = LatLng(
      _orderModel!.storeLocation!.latitude,
      _orderModel!.storeLocation!.longitude,
    );

    _deliveryLocationPosition = _orderModel!.deliveryAddress!.address!.location;

    _orderProvider = OrderProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    _isUpdated = false;

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await _setSourceAndDestinationIcons();
      _addMakers();
      await _getRouter();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _deliveryPickupCompleteCallback() async {
    Map<String, dynamic> newOrderData = json.decode(json.encode(_orderModel));
    List<dynamic> historyData = [];
    if (newOrderData["deliveryDetail"] != null) {
      historyData = newOrderData["deliveryDetail"]["historyData"];
    }

    historyData.add({
      "title": AppConfig.deliveryOrderHistory["delivery_pickup_completed"]["title"],
      "desc": AppConfig.deliveryOrderHistory["delivery_pickup_completed"]["desc"].toString().replaceAll("orderId", _orderModel!.orderId!).replaceAll(
            "delivery_user_name",
            "${AuthProvider.of(context).authState.deliveryUserModel!.firstName} "
                "${AuthProvider.of(context).authState.deliveryUserModel!.lastName}",
          ),
      "data": {
        "orderId": newOrderData["_id"],
        "deliveryUserId": AuthProvider.of(context).authState.deliveryUserModel!.id,
      }
    });

    newOrderData["deliveryDetail"]["status"] = "delivery_pickup_completed";
    newOrderData["deliveryDetail"]["historyData"] = historyData;

    newOrderData["user"] = _orderModel!.userModel!.toJson();
    newOrderData["store"] = _orderModel!.storeModel!.toJson();
    await _keicyProgressDialog!.show();
    var result = await _orderProvider!.updateOrderData(
      orderModel: OrderModel.fromJson(newOrderData),
      status: "delivery_pickup_completed",
      changedStatus: false,
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      _orderModel = OrderModel.fromJson(result["data"]);
      _orderModel!.storeModel = widget.orderModel!.storeModel;
      _orderModel!.userModel = widget.orderModel!.userModel;
      _isUpdated = true;
      setState(() {});
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "The Delivery Order is completed picked up",
      );
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
        callBack: () {
          _deliveryPickupCompleteCallback();
        },
      );
    }
  }

  void _resendPickupCodeCallback() async {
    Map<String, dynamic> newOrderData = json.decode(json.encode(_orderModel));
    String storeDeliveryCode = randomNumeric(4);
    List<dynamic> historyData = [];
    if (newOrderData["deliveryDetail"] != null) {
      historyData = newOrderData["deliveryDetail"]["historyData"];
    }

    historyData.add({
      "title": AppConfig.deliveryOrderHistory["sent_delivery_pickup_code"]["title"],
      "desc": AppConfig.deliveryOrderHistory["sent_delivery_pickup_code"]["desc"].toString().replaceAll("orderId", _orderModel!.orderId!).replaceAll(
            "delivery_user_name",
            "${AuthProvider.of(context).authState.deliveryUserModel!.firstName} "
                "${AuthProvider.of(context).authState.deliveryUserModel!.lastName}",
          ),
      "data": {
        "orderId": newOrderData["_id"],
        "deliveryUserId": AuthProvider.of(context).authState.deliveryUserModel!.id,
        "storeDeliveryCode": storeDeliveryCode,
      }
    });

    newOrderData["deliveryDetail"]["status"] = "sent_delivery_pickup_code";
    newOrderData["deliveryDetail"]["historyData"] = historyData;
    newOrderData["deliveryDetail"]["storeDeliveryCode"] = storeDeliveryCode;

    newOrderData["user"] = _orderModel!.userModel!.toJson();
    newOrderData["store"] = _orderModel!.storeModel!.toJson();
    await _keicyProgressDialog!.show();
    var result = await _orderProvider!.updateOrderData(
      orderModel: OrderModel.fromJson(newOrderData),
      status: "sent_delivery_pickup_code",
      changedStatus: false,
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      _orderModel = OrderModel.fromJson(result["data"]);
      _orderModel!.storeModel = widget.orderModel!.storeModel;
      _orderModel!.userModel = widget.orderModel!.userModel;
      _isUpdated = true;
      setState(() {});
      DeliveryOTPProvider.of(context).setDeliveryOTPState(
        DeliveryOTPState.init(),
      );
      DeliveryOTPProvider.of(context).getOTP(orderId: _orderModel!.id);
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "The OTP resent. Please enter new otp",
      );
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
        callBack: () {
          _resendPickupCodeCallback();
        },
      );
    }
  }

  void _sendDeliveryCompleteCodeCallback() async {
    Map<String, dynamic> newOrderData = json.decode(json.encode(_orderModel));
    String customerDeliveryCode = randomNumeric(4);
    List<dynamic> historyData = [];
    if (newOrderData["deliveryDetail"] != null) {
      historyData = newOrderData["deliveryDetail"]["historyData"];
    }

    historyData.add({
      "title": AppConfig.deliveryOrderHistory["sent_delivery_complete_code"]["title"],
      "desc":
          AppConfig.deliveryOrderHistory["sent_delivery_complete_code"]["desc"].toString().replaceAll("orderId", _orderModel!.orderId!).replaceAll(
                "delivery_user_name",
                "${AuthProvider.of(context).authState.deliveryUserModel!.firstName} "
                    "${AuthProvider.of(context).authState.deliveryUserModel!.lastName}",
              ),
      "data": {
        "orderId": newOrderData["_id"],
        "deliveryUserId": AuthProvider.of(context).authState.deliveryUserModel!.id,
        "customerDeliveryCode": customerDeliveryCode,
      }
    });

    newOrderData["deliveryDetail"]["status"] = "sent_delivery_complete_code";
    newOrderData["deliveryDetail"]["historyData"] = historyData;
    newOrderData["deliveryDetail"]["customerDeliveryCode"] = customerDeliveryCode;

    newOrderData["user"] = _orderModel!.userModel!.toJson();
    newOrderData["store"] = _orderModel!.storeModel!.toJson();
    await _keicyProgressDialog!.show();
    var result = await _orderProvider!.updateOrderData(
      orderModel: OrderModel.fromJson(newOrderData),
      status: "sent_delivery_complete_code",
      changedStatus: false,
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      _orderModel = OrderModel.fromJson(result["data"]);
      _orderModel!.storeModel = widget.orderModel!.storeModel;
      _orderModel!.userModel = widget.orderModel!.userModel;
      _isUpdated = true;
      setState(() {});
      DeliveryOTPProvider.of(context).setDeliveryOTPState(
        DeliveryOTPState.init(),
      );
      DeliveryOTPProvider.of(context).getOTP(orderId: _orderModel!.id);
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "The OTP resent. Please enter new otp",
      );
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
        callBack: () {
          _sendDeliveryCompleteCodeCallback();
        },
      );
    }
  }

  void _deliveryCompleteCallback() async {
    Map<String, dynamic> newOrderData = json.decode(json.encode(_orderModel));

    String status = newOrderData["cashOnDelivery"] ? "items_delivery_complete" : "delivery_complete";

    List<dynamic> historyData = [];
    if (newOrderData["deliveryDetail"] != null) {
      historyData = newOrderData["deliveryDetail"]["historyData"];
    }

    String title = AppConfig.deliveryOrderHistory[status]["title"];
    String desc = AppConfig.deliveryOrderHistory[status]["desc"];
    desc = desc.replaceAll("orderId", _orderModel!.orderId!);
    desc = desc.replaceAll("store_name", _orderModel!.storeModel!.name!);
    desc = desc.replaceAll(
        "user_name",
        "${_orderModel!.userModel!.firstName} "
            "${_orderModel!.userModel!.lastName}");
    desc = desc.replaceAll(
      "delivery_user_name",
      "${AuthProvider.of(context).authState.deliveryUserModel!.firstName} "
          "${AuthProvider.of(context).authState.deliveryUserModel!.lastName}",
    );

    Map<String, dynamic> data = {
      "orderId": newOrderData["_id"],
      "deliveryUserId": AuthProvider.of(context).authState.deliveryUserModel!.id,
      "customerId": newOrderData["userId"],
      "storeId": newOrderData["storeId"],
    };

    historyData.add({"title": title, "desc": desc, "data": data});

    newOrderData["deliveryDetail"]["status"] = status;
    newOrderData["deliveryDetail"]["historyData"] = historyData;

    // if (!newOrderData["cashOnDelivery"]) {
    newOrderData["status"] = AppConfig.orderStatusData[6]["id"];
    newOrderData["deliveryDetail"]["ongoing"] = false;
    // }

    newOrderData["user"] = _orderModel!.userModel!.toJson();
    newOrderData["store"] = _orderModel!.storeModel!.toJson();
    await _keicyProgressDialog!.show();
    var result = await _orderProvider!.updateOrderData(
      orderModel: OrderModel.fromJson(newOrderData),
      status: status,
      changedStatus: false,
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      _orderModel = OrderModel.fromJson(result["data"]);
      _orderModel!.storeModel = widget.orderModel!.storeModel;
      _orderModel!.userModel = widget.orderModel!.userModel;
      _isUpdated = true;
      setState(() {});
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: newOrderData["cashOnDelivery"] ? "The Delivery Order Item is completed" : "Delivery order is completed",
        callBack: newOrderData["cashOnDelivery"]
            ? null
            : () {
                Navigator.of(context).pop(true);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => OrderDetailPage(
                      orderModel: _orderModel,
                      isUpdated: true,
                    ),
                  ),
                );
              },
      );
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
        callBack: () {
          _deliveryPickupCompleteCallback();
        },
      );
    }
  }

  void _paymentReceivedCallback() async {
    Map<String, dynamic> newOrderData = json.decode(json.encode(_orderModel));

    String status = "payment_received";

    List<dynamic> historyData = [];
    if (newOrderData["deliveryDetail"] != null) {
      historyData = newOrderData["deliveryDetail"]["historyData"];
    }

    newOrderData["payStatus"] = true;
    newOrderData["status"] = AppConfig.orderStatusData[6]["id"];

    String title = AppConfig.deliveryOrderHistory[status]["title"];
    String desc = AppConfig.deliveryOrderHistory[status]["desc"];
    desc = desc.replaceAll("orderId", _orderModel!.orderId!);
    desc = desc.replaceAll("store_name", _orderModel!.storeModel!.name!);
    desc = desc.replaceAll(
        "user_name",
        "${_orderModel!.userModel!.firstName} "
            "${_orderModel!.userModel!.lastName}");
    desc = desc.replaceAll(
      "delivery_user_name",
      "${AuthProvider.of(context).authState.deliveryUserModel!.firstName} "
          "${AuthProvider.of(context).authState.deliveryUserModel!.lastName}",
    );

    Map<String, dynamic> data = {
      "orderId": newOrderData["_id"],
      "deliveryUserId": AuthProvider.of(context).authState.deliveryUserModel!.id,
      "customerId": newOrderData["userId"],
      "storeId": newOrderData["storeId"],
    };

    historyData.add({"title": title, "desc": desc, "data": data});

    newOrderData["deliveryDetail"]["status"] = "delivery_complete";
    newOrderData["deliveryDetail"]["historyData"] = historyData;
    newOrderData["deliveryDetail"]["ongoing"] = false;

    newOrderData["user"] = _orderModel!.userModel!.toJson();
    newOrderData["store"] = _orderModel!.storeModel!.toJson();
    await _keicyProgressDialog!.show();
    var result = await _orderProvider!.updateOrderData(
      orderModel: OrderModel.fromJson(newOrderData),
      status: status,
      changedStatus: false,
    );
    await _keicyProgressDialog!.hide();
    if (result["success"]) {
      _orderModel = OrderModel.fromJson(result["data"]);
      _orderModel!.storeModel = widget.orderModel!.storeModel;
      _orderModel!.userModel = widget.orderModel!.userModel;
      _isUpdated = true;
      setState(() {});
      SuccessDialog.show(
        context,
        heightDp: heightDp,
        fontSp: fontSp,
        text: "Payment received. Delivery is completed",
        callBack: () {
          Navigator.of(context).pop(_isUpdated);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => OrderDetailPage(
                orderModel: _orderModel,
                isUpdated: true,
              ),
            ),
          );
        },
      );
    } else {
      ErrorDialog.show(
        context,
        widthDp: widthDp,
        heightDp: heightDp,
        fontSp: fontSp,
        text: result["message"],
        callBack: () {
          _deliveryPickupCompleteCallback();
        },
      );
    }
  }

  //////////////////////////////////////////

  Future<void> _setSourceAndDestinationIcons() async {
    // _startMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    // _delieryMarkerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    _startMarkerIcon = BitmapDescriptor.fromBytes(await getBytesFromAsset("img/start_marker_icon.png", 100));
    _delieryMarkerIcon = BitmapDescriptor.fromBytes(await getBytesFromAsset("img/end_marker_icon.png", 100));
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  void _addMakers() {
    _storeMarkerId = MarkerId("store");
    _deliveryMarkerId = MarkerId("delivery");

    Marker storeMarker = Marker(
      markerId: _storeMarkerId!,
      position: _storeLocationPosition!,
      icon: _startMarkerIcon!,
      onTap: () {},
    );

    Marker deliveryMarker = Marker(
      markerId: _deliveryMarkerId!,
      position: _deliveryLocationPosition!,
      icon: _delieryMarkerIcon!,
      onTap: () {},
    );

    _markers[_storeMarkerId!] = storeMarker;
    _markers[_deliveryMarkerId!] = deliveryMarker;
  }

  Future<void> _getRouter() async {
    // PolylinePoints polylinePoints = PolylinePoints();
    // List<LatLng> polylineCoordinates = [];

    // PolylineId polylineId = PolylineId("delivery_rounte");

    // PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    //   AppConfig.googleApiKey,
    //   PointLatLng(_storeLocationPosition!.latitude, _storeLocationPosition!.longitude),
    //   PointLatLng(_deliveryLocationPosition!.latitude, _deliveryLocationPosition!.longitude),
    //   travelMode: TravelMode.driving,
    // );

    // if (result.points.isNotEmpty) {
    //   result.points.forEach((PointLatLng point) {
    //     polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    //   });

    //   Polyline polyline = Polyline(
    //     polylineId: polylineId,
    //     color: Color(0xFF2ED16E),
    //     points: polylineCoordinates,
    //     width: 4,
    //   );
    //   _polyLines[polylineId] = polyline;
    // }

    var sLat = _storeLocationPosition!.latitude;
    var sLng = _storeLocationPosition!.longitude;
    var nLat = _deliveryLocationPosition!.latitude;
    var nLng = _deliveryLocationPosition!.longitude;

    if (_storeLocationPosition!.latitude < _deliveryLocationPosition!.latitude) {
      sLat = _storeLocationPosition!.latitude;
      nLat = _deliveryLocationPosition!.latitude;
    } else {
      sLat = _deliveryLocationPosition!.latitude;
      nLat = _storeLocationPosition!.latitude;
    }

    if (_storeLocationPosition!.longitude < _deliveryLocationPosition!.longitude) {
      sLng = _storeLocationPosition!.longitude;
      nLng = _deliveryLocationPosition!.longitude;
    } else {
      sLng = _deliveryLocationPosition!.longitude;
      nLng = _storeLocationPosition!.longitude;
    }

    setState(() {});

    _moveToLatLngBounds(LatLng(sLat, sLng), LatLng(nLat, nLng));
  }

  Future _moveToLatLngBounds(LatLng southwest, LatLng northeast) async {
    var controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(
        southwest: southwest,
        northeast: northeast,
      ),
      140.0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    _deliveryStatus = _orderModel!.deliveryDetail!["status"];

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(_isUpdated);
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: deviceWidth,
          height: deviceHeight,
          child: Stack(
            children: [
              Container(
                width: deviceWidth,
                height: deviceHeight,
                child: Stack(
                  children: [
                    GoogleMap(
                      myLocationButtonEnabled: false,
                      initialCameraPosition: CameraPosition(
                        target: _storeLocationPosition!,
                        zoom: 16,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _mapController.complete(controller);
                      },
                      onCameraMove: (CameraPosition position) {
                        // _deliveryMarkerHandler(position);
                      },
                      onCameraIdle: null,
                      onCameraMoveStarted: () {},
                      onTap: (latLng) {},
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      markers: Set<Marker>.of(_markers.values),
                      // polylines: Set<Polyline>.of(_polyLines.values),
                    ),
                    AddressPanel(orderModel: _orderModel),
                  ],
                ),
              ),
              if (_deliveryStatus == "sent_delivery_pickup_code")
                PickupCompleteOTPPanel(
                  orderModel: _orderModel,
                  resendPickupCodeCallback: _resendPickupCodeCallback,
                  deliveryPickupCompleteCallback: _deliveryPickupCompleteCallback,
                ),
              if (_deliveryStatus == "delivery_pickup_completed")
                PickupCompletedButtonsPanel(
                  orderModel: _orderModel,
                  sendDeliveryCompleteCodeCallback: _sendDeliveryCompleteCodeCallback,
                ),
              if (_deliveryStatus == "sent_delivery_complete_code")
                DeliveryCompleteOTPPanel(
                  orderModel: _orderModel,
                  resendDeliveryCompleteCodeCallback: _sendDeliveryCompleteCodeCallback,
                  deliveryCompleteCallback: _deliveryCompleteCallback,
                ),
              if (_deliveryStatus == "items_delivery_complete")
                PaymentReceivedButtonsPanel(
                  paymentReceivedCallback: _paymentReceivedCallback,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
