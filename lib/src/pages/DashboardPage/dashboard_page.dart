import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'index.dart';

class DashboardPage extends StatelessWidget {
  final bool haveAppBar;

  DashboardPage({this.haveAppBar = false});

  @override
  Widget build(BuildContext context) {
    return DashboardView(haveAppBar: haveAppBar);
  }
}
