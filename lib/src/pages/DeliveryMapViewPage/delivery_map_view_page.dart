import 'package:delivery_app/src/models/index.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'index.dart';

class DeliveryMapViewPage extends StatelessWidget {
  final OrderModel? orderModel;

  DeliveryMapViewPage({@required this.orderModel});

  @override
  Widget build(BuildContext context) {
    return DeliveryMapViewView(orderModel: orderModel);
  }
}
