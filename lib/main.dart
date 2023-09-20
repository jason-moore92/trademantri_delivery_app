import 'package:delivery_app/bootstrap.dart';
import 'package:delivery_app/environment.dart';

void main() async {
  Environment(
    debug: true,
    envName: "development",
    // apiBaseUrl: "http://192.168.43.57:3000/api/v1/",
    // apiBaseUrl: "http://192.168.0.136:3000/api/v1/",
    apiBaseUrl: "http://192.168.1.24:3000/api/v1/",
    // apiBaseUrl: "http://192.168.1.101:3000/api/v1/",
    // apiBaseUrl: "https://qa.api.tm.delivery.trademantri.in/api/v1/",
    googleApiKey: "AIzaSyBfkIHqXazhle5rR1znrtxCU53cpHgVFkQ",
    freshChatId: "0f4a3e09-8291-4bc6-a857-4590c167a41d",
    freshChatKey: "810d2f29-cfcc-434e-b63b-692a1199dbcb",
    freshChatDomain: "msdk.in.freshchat.com",
    enableFreshChatEvents: true,
    vapidKey: "BE8QNT4FPufcL-ZCdDR7VMHsIuBPCG8_Mzn0uHYffPnYgMQVuO3-1KoJra9a9bvSTldKhTNejUHXRiTGYk2Ggqw",
    // logsEncryptionKey: "7x!A%D*G-JaNdRgUkXp2s5v8y/B?E(H+",
  );

  bootstrap();
}
