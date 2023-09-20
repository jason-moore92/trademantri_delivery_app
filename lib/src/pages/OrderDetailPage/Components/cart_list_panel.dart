import 'package:delivery_app/src/models/index.dart';
import 'package:delivery_app/src/models/order_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:delivery_app/src/elements/product_order_widget.dart';
import 'package:delivery_app/config/app_config.dart' as config;

class CartListPanel extends StatefulWidget {
  final OrderModel? orderModel;
  final bool? isSelectable;
  final Function(Map<String, dynamic>, String)? refreshCallback;

  CartListPanel({
    @required this.orderModel,
    @required this.isSelectable,
    @required this.refreshCallback,
  });

  @override
  _CartListPanelState createState() => _CartListPanelState();
}

class _CartListPanelState extends State<CartListPanel> {
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
            children: List.generate(widget.orderModel!.products!.length, (index) {
              ProductOrderModel productOrderModel = widget.orderModel!.products![index];
              bool isSelected = false;

              if (widget.orderModel!.deliveryDetail != null && widget.orderModel!.deliveryDetail!["products"] != null) {
                for (var i = 0; i < widget.orderModel!.deliveryDetail!["products"].length; i++) {
                  if (widget.orderModel!.deliveryDetail!["products"][i]["id"] == productOrderModel.productModel!.id) {
                    isSelected = true;
                    break;
                  }
                }
              }

              return Column(
                children: [
                  Divider(height: 1, thickness: 1, color: Colors.grey.withOpacity(0.6)),
                  ProductOrderWidget(
                    productOrderModel: productOrderModel,
                    isSelectable: widget.isSelectable!,
                    refreshCallback: widget.refreshCallback,
                    isSelected: widget.isSelectable! && isSelected,
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
