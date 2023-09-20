import 'package:delivery_app/bootstrap.dart';
import 'package:delivery_app/environment.dart';

void main() async {
  Environment(
    debug: false,
    envName: "production",
    apiBaseUrl: "https://api.tm.delivery.trademantri.in/api/v1/",
    googleApiKey: "AIzaSyBfkIHqXazhle5rR1znrtxCU53cpHgVFkQ",
    freshChatId: "0f4a3e09-8291-4bc6-a857-4590c167a41d",
    freshChatKey: "810d2f29-cfcc-434e-b63b-692a1199dbcb",
    freshChatDomain: "msdk.in.freshchat.com",
    enableFreshChatEvents: true,
    vapidKey: "BEceWxyRTl3ns2Ic7I0sC-n3_HeP03c0bL50SYYFJbzYf4pVxVIo74yuCwcw-FcGl7UG9lgJywQ9rM1As8Uiras",
    logsEncryptionKey: "-KaPdSgVkYp3s6v9y/B?E(H+MbQeThWm",
  );

  bootstrap();
}
