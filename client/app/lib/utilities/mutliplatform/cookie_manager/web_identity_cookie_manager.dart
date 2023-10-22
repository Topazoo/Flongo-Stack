import 'dart:html';
import 'package:app/utilities/mutliplatform/cookie_manager/mobile_identity_cookie_manager.dart';
export 'package:app/utilities/mutliplatform/cookie_manager/mobile_identity_cookie_manager.dart' show parseIdentityAndRole;

Map<String, dynamic>? getIdentityCookie() {
  if (document.cookie!.contains('identity_cookie=')) {
    return parseIdentityAndRole(document.cookie);
  }

  return null;
}
