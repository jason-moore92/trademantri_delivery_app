import 'package:delivery_app/src/models/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressPanel extends StatelessWidget {
  final OrderModel? orderModel;

  AddressPanel({Key? key, @required this.orderModel}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
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

    return Positioned(
      top: statusbarHeight + heightDp * 30,
      child: Container(
        width: deviceWidth,
        padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
        child: Stack(
          children: [
            Card(
              elevation: 5,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset("img/start_marker_icon.png", width: heightDp * 30, height: heightDp * 30, fit: BoxFit.cover),
                        SizedBox(width: widthDp * 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Store Address",
                                style: TextStyle(fontSize: fontSp * 12, color: Colors.black, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: heightDp * 3),
                              Text(
                                "${orderModel!.storeModel!.address}",
                                style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Divider(height: heightDp * 30, thickness: 1, color: Colors.grey.withOpacity(0.6), indent: heightDp * 30),
                        Container(
                          height: heightDp * 30,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.south, size: heightDp * 30, color: Colors.black.withOpacity(0.8)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset("img/end_marker_icon.png", width: heightDp * 30, height: heightDp * 30, fit: BoxFit.cover),
                        SizedBox(width: widthDp * 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Delivery Address",
                                style: TextStyle(fontSize: fontSp * 12, color: Colors.black, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: heightDp * 3),
                              Text(
                                "${orderModel!.deliveryAddress!.address!.address}",
                                style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                              ),
                              if (orderModel!.deliveryAddress!.building != "")
                                Column(
                                  children: [
                                    SizedBox(height: heightDp * 3),
                                    Row(
                                      children: [
                                        Text(
                                          "Flat/Apt/Floor/Building:",
                                          style: TextStyle(fontSize: fontSp * 12, color: Colors.black, fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(width: widthDp * 5),
                                        Expanded(
                                          child: Text(
                                            "${orderModel!.deliveryAddress!.building}",
                                            style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              // if (orderModel!.deliveryAddress!.contactPhone != "")
                              //   Column(
                              //     children: [
                              //       SizedBox(height: heightDp * 3),
                              //       Row(
                              //         children: [
                              //           Text(
                              //             "Mobile To Contact For Delivery:",
                              //             style: TextStyle(fontSize: fontSp * 12, color: Colors.black, fontWeight: FontWeight.w600),
                              //           ),
                              //           SizedBox(width: widthDp * 5),
                              //           Expanded(
                              //             child: Text(
                              //               "${orderModel!.deliveryAddress!.contactPhone}",
                              //               style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                              //               maxLines: 1,
                              //               overflow: TextOverflow.ellipsis,
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     ],
                              //   ),
                              if (orderModel!.deliveryAddress!.howToReach != "")
                                Column(
                                  children: [
                                    SizedBox(height: heightDp * 3),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "How To Reach:",
                                          style: TextStyle(fontSize: fontSp * 12, color: Colors.black, fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(width: widthDp * 5),
                                        Expanded(
                                          child: Text(
                                            "${orderModel!.deliveryAddress!.howToReach}",
                                            style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
