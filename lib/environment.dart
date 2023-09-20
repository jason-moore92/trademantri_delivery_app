import 'package:meta/meta.dart';

class Environment {
  static bool? debug;
  static String? envName;
  static String? apiBaseUrl;
  static String? googleApiKey;
  static String? freshChatId;
  static String? freshChatKey;
  static String? freshChatDomain;
  static bool? enableFreshChatEvents;
  static String? vapidKey;
  static String? logsEncryptionKey;

  Environment({
    @required bool? debug,
    @required String? envName,
    @required String? apiBaseUrl,
    @required String? googleApiKey,
    @required String? freshChatId,
    @required String? freshChatKey,
    @required String? freshChatDomain,
    @required bool? enableFreshChatEvents,
    @required String? vapidKey,
    String? logsEncryptionKey,
  }) {
    Environment.debug = debug;
    Environment.envName = envName;
    Environment.apiBaseUrl = apiBaseUrl;
    Environment.googleApiKey = googleApiKey;
    Environment.freshChatId = freshChatId;
    Environment.freshChatKey = freshChatKey;
    Environment.freshChatDomain = freshChatDomain;
    Environment.enableFreshChatEvents = enableFreshChatEvents;
    Environment.vapidKey = vapidKey;
    Environment.logsEncryptionKey = logsEncryptionKey;
  }
}
