import 'package:http/browser_client.dart';

BrowserClient getCustomClient() => BrowserClient()..withCredentials=true;
