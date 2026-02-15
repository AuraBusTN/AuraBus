import 'dart:js_interop';
import 'dart:js_interop_unsafe';

/// Returns `true` when running on a Chromium-based browser (Chrome, Edge, Opera…).
bool get isChromiumBrowser {
  try {
    final ua = globalContext.getProperty('navigator'.toJS);
    if (ua.isUndefinedOrNull) return false;
    final nav = ua as JSObject;

    final vendor = (nav.getProperty('vendor'.toJS) as JSString?)?.toDart ?? '';
    final userAgent =
        (nav.getProperty('userAgent'.toJS) as JSString?)?.toDart ?? '';

    return vendor.contains('Google Inc') || userAgent.contains('Edg/');
  } catch (_) {
    return false;
  }
}
