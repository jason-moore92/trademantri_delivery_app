import 'package:delivery_app/src/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class PaymentDetailPanel extends StatefulWidget {
  final OrderModel? orderModel;

  PaymentDetailPanel({
    @required this.orderModel,
  });

  @override
  _PaymentDetailPanelState createState() => _PaymentDetailPanelState();
}

class _PaymentDetailPanelState extends State<PaymentDetailPanel> {
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

  var numFormat = NumberFormat.currency(symbol: "", name: "");

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

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///
          Text(
            "Payment Detail",
            style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
          ),

          ///
          SizedBox(height: heightDp * 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Count",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              ),
              Text(
                "${widget.orderModel!.paymentDetail!.totalQuantity}",
                style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              ),
            ],
          ),

          // ///
          // Divider(height: heightDp * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       "Total Price",
          //       style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
          //     ),
          //     Row(
          //       children: [
          //         Text(
          //           "₹ ${widget.orderModel!.paymentDetail["totalPriceAfterPromocode"].toStringAsFixed(2)}",
          //           style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
          //         ),
          //         widget.orderModel!.paymentDetail["totalPriceBeforePromocode"] == widget.orderModel!.paymentDetail["totalPriceAfterPromocode"]
          //             ? SizedBox()
          //             : Row(
          //                 children: [
          //                   SizedBox(width: widthDp * 5),
          //                   Text(
          //                     "₹ ${widget.orderModel!.paymentDetail["totalPriceBeforePromocode"].toStringAsFixed(2)}",
          //                     style: TextStyle(
          //                       fontSize: fontSp * 12,
          //                       color: Colors.grey,
          //                       decoration: TextDecoration.lineThrough,
          //                       decorationThickness: 2,
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //       ],
          //     ),
          //   ],
          // ),

          // ///
          // widget.orderModel!.paymentDetail["promocode"] == null || widget.orderModel!.paymentDetail["promocode"].isEmpty
          //     ? SizedBox()
          //     : Column(
          //         children: [
          //           Divider(height: heightDp * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(
          //                 "Promo code applied",
          //                 style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
          //               ),
          //               Text(
          //                 "${widget.orderModel!.paymentDetail["promocode"]}",
          //                 style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),

          // ///
          // widget.orderModel!.paymentDetail["deliveryCargeBeforePromocode"] == 0
          //     ? SizedBox()
          //     : Column(
          //         children: [
          //           Divider(height: heightDp * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Row(
          //                 children: [
          //                   Text(
          //                     "Delivery Price",
          //                     style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
          //                   ),
          //                   GestureDetector(
          //                     onTap: () {
          //                       _deliveryBreakdownDialog();
          //                     },
          //                     child: Container(
          //                       padding: EdgeInsets.symmetric(horizontal: widthDp * 10),
          //                       color: Colors.transparent,
          //                       child: Icon(Icons.info_outline, size: heightDp * 20, color: Colors.black.withOpacity(0.6)),
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.end,
          //                 children: [
          //                   Text(
          //                     "₹ ${widget.orderModel!.paymentDetail["deliveryCargeAfterPromocode"].toStringAsFixed(2)}",
          //                     style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
          //                   ),
          //                   widget.orderModel!.paymentDetail["deliveryDiscount"] == 0
          //                       ? SizedBox()
          //                       : Row(
          //                           children: [
          //                             SizedBox(width: widthDp * 5),
          //                             Text(
          //                               "₹ ${widget.orderModel!.paymentDetail["deliveryCargeBeforePromocode"].toStringAsFixed(2)}",
          //                               style: TextStyle(
          //                                 fontSize: fontSp * 12,
          //                                 color: Colors.grey,
          //                                 decoration: TextDecoration.lineThrough,
          //                                 decorationThickness: 2,
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),

          // ///
          // widget.orderModel!.paymentDetail["tip"] == 0
          //     ? SizedBox()
          //     : Column(
          //         children: [
          //           Divider(height: heightDp * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(
          //                 "Tip",
          //                 style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
          //               ),
          //               Text(
          //                 "₹ ${widget.orderModel!.paymentDetail["tip"].toStringAsFixed(2)}",
          //                 style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),

          // ///
          // widget.orderModel!.paymentDetail["totalTax"] == 0
          //     ? SizedBox()
          //     : Column(
          //         children: [
          //           Divider(height: heightDp * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(
          //                 "Tax",
          //                 style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
          //               ),
          //               Text(
          //                 "₹ ${widget.orderModel!.paymentDetail["totalTax"].toStringAsFixed(2)}",
          //                 style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),

          // ///
          // redeemRewardValue == 0
          //     ? SizedBox()
          //     : Column(
          //         children: [
          //           Divider(height: heightDp * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
          //           Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(
          //                 "Redeem Reward Value",
          //                 style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
          //               ),
          //               Text(
          //                 "₹ ${redeemRewardValue}",
          //                 style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),

          ///
          Divider(height: heightDp * 15, thickness: 1, color: Colors.black.withOpacity(0.1)),
          Column(
            children: [
              SizedBox(height: heightDp * 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "To Pay",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "₹ ${(widget.orderModel!.paymentDetail!.toPay! - widget.orderModel!.paymentDetail!.redeemRewardValue!).toStringAsFixed(2)}",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _deliveryBreakdownDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return BottomSheet(
          backgroundColor: Colors.transparent,
          onClosing: () {},
          builder: (context) {
            return Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(color: Colors.transparent),
                  ),
                ),
                Container(
                  width: deviceWidth,
                  padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(heightDp * 20), topRight: Radius.circular(heightDp * 20)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Delivery Charges Breakdown",
                            style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.w500),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: widthDp * 10),
                              child: Icon(Icons.close, size: heightDp * 25, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: heightDp * 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total distance",
                            style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                          ),
                          Text(
                            "${widget.orderModel!.paymentDetail!.distance} Km",
                            style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                          ),
                        ],
                      ),
                      SizedBox(height: heightDp * 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Distance Charge",
                            style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                          ),
                          Text(
                            "₹ ${numFormat.format(widget.orderModel!.paymentDetail!.deliveryChargeBeforeDiscount)}",
                            style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                          ),
                        ],
                      ),
                      widget.orderModel!.paymentDetail!.deliveryDiscount == 0
                          ? SizedBox()
                          : Column(
                              children: [
                                SizedBox(height: heightDp * 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Distance Discount",
                                      style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                    ),
                                    Text(
                                      "₹ ${numFormat.format(widget.orderModel!.paymentDetail!.deliveryDiscount)}",
                                      style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      Divider(height: heightDp * 20, thickness: 1, color: Colors.black.withOpacity(0.1)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "₹ ${numFormat.format(widget.orderModel!.paymentDetail!.deliveryChargeAfterDiscount)}",
                            style: TextStyle(fontSize: fontSp * 14, color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
