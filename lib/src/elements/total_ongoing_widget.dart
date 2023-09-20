import 'package:delivery_app/src/providers/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TotalOngoingWidget extends StatefulWidget {
  @override
  _TotalOngoingWidgetState createState() => _TotalOngoingWidgetState();
}

class _TotalOngoingWidgetState extends State<TotalOngoingWidget> {
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

  MyDeliveryDashboardDataProvider? _myDeliveryDashboardDataProvider;

  @override
  void initState() {
    super.initState();

    _myDeliveryDashboardDataProvider = MyDeliveryDashboardDataProvider.of(context);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _myDeliveryDashboardDataProvider!.setMyDeliveryDashboardDataState(
        _myDeliveryDashboardDataProvider!.myDeliveryDashboardDataState.update(progressState: 1),
      );
      _myDeliveryDashboardDataProvider!.getMyDeliveryDashboardDataData(
        deliveryUserId: AuthProvider.of(context).authState.deliveryUserModel!.id,
      );
    });
  }

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

    numFormat.maximumFractionDigits = 2;
    numFormat.minimumFractionDigits = 0;
    numFormat.turnOffGrouping();

    Widget _shimmerWidget = Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      period: Duration(milliseconds: 1000),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            color: Colors.white,
            child: Text(
              "Total Ongoing",
              style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: heightDp * 10),
          Container(
            color: Colors.white,
            child: Text(
              "₹ 82.56",
              style: TextStyle(fontSize: fontSp * 20, color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    return Consumer<MyDeliveryDashboardDataProvider>(builder: (context, myDeliveryDashboardDataProvider, _) {
      return Card(
        margin: EdgeInsets.only(left: widthDp * 10, right: widthDp * 10, top: heightDp * 3, bottom: heightDp * 17),
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(heightDp * 10)),
        child: Container(
          width: heightDp * 170,
          height: heightDp * 100,
          padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(heightDp * 10), color: Colors.white),
          child: myDeliveryDashboardDataProvider.myDeliveryDashboardDataState.progressState == 0 ||
                  myDeliveryDashboardDataProvider.myDeliveryDashboardDataState.progressState == 1
              ? _shimmerWidget
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Total Ongoing",
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: heightDp * 10),
                    Text(
                      myDeliveryDashboardDataProvider.myDeliveryDashboardDataState.dashboardData!.isEmpty ||
                              myDeliveryDashboardDataProvider.myDeliveryDashboardDataState.dashboardData!["ongoingOrders"].isEmpty
                          ? "0"
                          : "${myDeliveryDashboardDataProvider.myDeliveryDashboardDataState.dashboardData!["ongoingOrders"][0]["totalCount"]}",
                      style: TextStyle(fontSize: fontSp * 20, color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
        ),
      );
    });
  }
}
