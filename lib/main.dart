import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    useShouldInterceptRequest: true,
    mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
  );
  bool isSplashRemoved = false;

  @override
  Widget build(BuildContext context) {
    return InAppWebView(
        initialUrlRequest: URLRequest(
            url: WebUri('https://pub.dev/packages/flutter_inappwebview')),
        initialSettings: settings,
        onWebViewCreated: (controller) {
          print('test: onWebViewCreated');
        },
        onProgressChanged: (controller, progress) {
          if (!isSplashRemoved && progress == 100) {
            FlutterNativeSplash.remove();
            isSplashRemoved = true;
          }
        },
        onLoadStop: (controller, url) {
          print('test: onLoadStop');
        },
        onPermissionRequest: (_, request) async {
          print('test: onPermissionRequest');
          return PermissionResponse(
              resources: request.resources,
              action: PermissionResponseAction.GRANT);
        },
        onUpdateVisitedHistory: (_, uri, __) {
          print('test: onUpdateVisitedHistory');
        });
  }
}
