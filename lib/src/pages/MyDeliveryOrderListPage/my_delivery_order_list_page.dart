import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'index.dart';

class MyDeliveryOrderListPage extends StatelessWidget {
  final bool haveAppBar;

  MyDeliveryOrderListPage({this.haveAppBar = false});

  @override
  Widget build(BuildContext context) {
    return MyDeliveryOrderListView(haveAppBar: haveAppBar);
  }
}
