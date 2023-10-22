import 'dart:html';

String? getIdentityCookie() {
  if (document.cookie!.contains('identity_cookie=')) {
    return document.cookie
        ?.split('; ')
        .firstWhere((row) => row.startsWith('identity_cookie='))
        .split('=')[1];
  }

  return null;
}
