import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:delivery_app/src/pages/splash_page.dart';

import 'src/pages/pages.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashPage());
      case '/Pages':
        Map<String, dynamic> params = json.decode(json.encode(args));
        return MaterialPageRoute(
          builder: (_) => PageWidget(
            currentTab: params["currentTab"],
            categoryData: params["categoryData"],
          ),
          settings: RouteSettings(name: params["currentTab"] == 2 ? "home_page" : ""),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
