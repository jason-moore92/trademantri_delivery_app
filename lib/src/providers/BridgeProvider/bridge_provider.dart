import 'dart:async';

import 'package:delivery_app/src/providers/BridgeProvider/bridge_state.dart';

class BridgeProvider {
  static final BridgeProvider _instance = BridgeProvider._internal();

  factory BridgeProvider() {
    return _instance;
  }

  StreamController<BridgeState> controller = StreamController<BridgeState>();

  BridgeProvider._internal();

  Stream<BridgeState> getStream() {
    return controller.stream;
  }

  update(BridgeState state) {
    controller.add(state);
  }
}
