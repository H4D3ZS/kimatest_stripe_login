import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StrPaymentView extends StatefulWidget {
  const StrPaymentView({Key? key}) : super(key: key);

  @override
  State<StrPaymentView> createState() => _StrPaymentViewState();
}

bool paymentCompleted = false;

class _StrPaymentViewState extends State<StrPaymentView> {
  late WebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      initialUrl: 'https://www.kimaapp.com/login/',
      onWebViewCreated: (WebViewController webViewController) {
        _webViewController = webViewController;
      },
      onPageFinished: (url) {
        // Inject JavaScript to check if the payment is completed
        checkPaymentStatus();
      },
    );
  }

 void checkPaymentStatus() async {
  try {
    // Execute JavaScript in the webview and capture the result through a JavaScript bridge
    final dynamic result = await _webViewController.runJavascriptReturningResult(
      'window.flutter_inappwebview.callHandler("checkPaymentStatus")',
    );

    if (result != null) {
      // Assuming your JavaScript function returns a boolean value
      final bool isPaymentCompleted = result.toString().toLowerCase() == 'true';

      // Update the state if payment is completed
      if (isPaymentCompleted) {
        setState(() {
          paymentCompleted = true;
        });

        // Step 3: Return to the previous page
        Navigator.pop(context, /* data to pass back if needed */);
      }
    } else {
      print('Unexpected result from JavaScript: $result');
    }
  } catch (e) {
    print('Error checking payment status: $e');
  }
}
}