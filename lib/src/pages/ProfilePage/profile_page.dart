import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'index.dart';

class ProfilePage extends StatelessWidget {
  final bool haveAppBar;

  ProfilePage({this.haveAppBar = false});

  @override
  Widget build(BuildContext context) {
    return ProfileView(haveAppBar: haveAppBar);
  }
}
