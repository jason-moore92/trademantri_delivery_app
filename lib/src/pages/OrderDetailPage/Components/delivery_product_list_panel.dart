import 'package:delivery_app/src/models/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delivery_app/src/elements/product_order_widget.dart';
import 'package:delivery_app/src/elements/service_order_widget.dart';
import 'package:delivery_app/config/app_config.dart' as config;

class DeliveryProductListPanel extends StatefulWidget {
  final OrderModel? orderModel;
  final List<dynamic>? productList;

  DeliveryProductListPanel({
    @required this.orderModel,
    @required this.productList,
  });

  @override
  _DeliveryProductListPanelState createState() => _DeliveryProductListPanelState();
}

class _DeliveryProductListPanelState extends State<DeliveryProductListPanel> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Column(
            children: List.generate(widget.productList!.length, (index) {
              ProductOrderModel productOrderModel = widget.productList![index];

              return Column(
                children: [
                  Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  ProductOrderWidget(
                    productOrderModel: productOrderModel,
                    isSelected: false,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
