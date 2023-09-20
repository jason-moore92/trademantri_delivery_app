import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:delivery_app/src/helpers/date_time_convert.dart';
import 'package:delivery_app/src/pages/OrderDetailPage/index.dart';

class NotificationWidget extends StatelessWidget {
  final Map<String, dynamic>? notificationData;
  final bool? isLoading;

  NotificationWidget({
    @required this.notificationData,
    @required this.isLoading,
  });

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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: widthDp * 20, vertical: heightDp * 10),
      color: Colors.transparent,
      child: isLoading! ? _shimmerWidget() : _notificationWidget(context),
    );
  }

  Widget _shimmerWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      direction: ShimmerDirection.ltr,
      enabled: isLoading!,
      period: Duration(milliseconds: 1000),
      child: Row(
        children: [
          Container(width: heightDp * 80, height: heightDp * 80, color: Colors.black),
          SizedBox(width: widthDp * 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  child: Text(
                    "notification storeName",
                    style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      color: Colors.white,
                      child: Text(
                        "2021-09-23",
                        style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  color: Colors.white,
                  child: Text(
                    "notificationData title",
                    style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(height: heightDp * 5),
                Container(
                  color: Colors.white,
                  child: Text(
                    "notificationData body\nnotificationData body body body body",
                    style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationWidget(BuildContext context) {
    String assetString = "img/order/${notificationData!["type"]}.png";

    String body = notificationData!["body"] ?? "";

    body = body.replaceAll("store_name", notificationData!["store"]["name"]);
    body = body.replaceAll("user_name", notificationData!["user"]["firstName"] + " " + notificationData!["user"]["lastName"]);

    if (notificationData!["type"] == "order") {
      body = body.replaceAll("orderId", notificationData!["data"]["orderId"]);
    }
    if (notificationData!["type"] == "bargain") {
      body = body.replaceAll("bargainRequestId", notificationData!["data"]["bargainRequestId"]);
    }
    if (notificationData!["type"] == "reverse_auction") {
      body = body.replaceAll("reverseAuctionId", notificationData!["data"]["reverseAuctionId"]);
    }

    return GestureDetector(
      onTap: () {
        if (notificationData!["type"] == "order") {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => OrderDetailPage(
                orderId: notificationData!["data"]["orderId"],
                storeId: notificationData!["data"]["storeId"],
                userId: notificationData!["data"]["userId"],
              ),
            ),
          );
        } else if (notificationData!["type"] == "bargain") {
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (BuildContext context) => BargainRequestDetailPage(
          //       bargainRequestId: notificationData!["data"]["bargainRequestId"],
          //       storeId: notificationData!["data"]["storeId"],
          //       userId: notificationData!["data"]["userId"],
          //     ),
          //   ),
          // );
        } else if (notificationData!["type"] == "reverse_auction") {
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (BuildContext context) => ReverseAuctionDetailPage(
          //       storeId: notificationData!["data"]["storeId"],
          //       userId: notificationData!["data"]["userId"],
          //       reverseAuctionId: notificationData!["data"]["reverseAuctionId"],
          //     ),
          //   ),
          // );
        }
      },
      child: Row(
        children: [
          Image.asset(assetString, width: heightDp * 80, height: heightDp * 80),
          SizedBox(width: widthDp * 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${notificationData!["user"]["firstName"]} ${notificationData!["user"]["lastName"]}",
                  style: TextStyle(fontSize: fontSp * 18, color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: heightDp * 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      KeicyDateTime.convertDateTimeToDateString(
                        dateTime: DateTime.tryParse("${notificationData!["updatedAt"]}"),
                        formats: "Y-m-d h:i A",
                        isUTC: false,
                      ),
                      style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: heightDp * 5),
                Text(
                  "${notificationData!["title"]}",
                  style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: heightDp * 5),
                Text(
                  body,
                  style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
