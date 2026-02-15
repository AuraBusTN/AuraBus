import 'dart:js_interop';
import 'dart:js_interop_unsafe';

String? getGoogleAuthClientId() {
  try {
    final env = globalContext.getProperty('env'.toJS);
    if (env.isUndefinedOrNull) return null;

    final clientId = (env as JSObject).getProperty(
      'GOOGLE_AUTH_CLIENT_ID'.toJS,
    );
    if (clientId.isUndefinedOrNull) return null;

    final value = clientId.dartify();
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return null;
  } catch (_) {
    return null;
  }
}
