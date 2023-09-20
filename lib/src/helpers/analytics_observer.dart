import 'package:flutter/material.dart';
import 'package:flutter_logs/flutter_logs.dart';

/// An Navigation observer to sent analytics to any platform in single place.
class AnalyticsObserver extends RouteObserver<PageRoute<dynamic>> {
  void _sendScreenView(PageRoute<dynamic>? route) {
    final String? screenName = route!.settings.name;
    if (screenName != null) {
      FlutterLogs.logInfo(
        "analytics_observer",
        "_sendScreenView",
        {
          "type": "event",
          "page": screenName,
        }.toString(),
      );
    }
  }

  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    super.didPush(route!, previousRoute);
    if (route is PageRoute) {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    super.didPop(route!, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(previousRoute);
    }
  }
}
