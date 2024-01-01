import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

String sk_2 =
    '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';

String s_sk1 =
    "sk_test_51NkM0pFcfThzV7D63Dgh7KZTqlNXCBgWhU2RttBUdp1Y6cOcdtSQRzg3Ibsgzzn1uVDpm91DGM0ndbKpHx2HJ8zm00SNaEqrCE";

String p_key =
    "pk_test_51NkM0pFcfThzV7D6UHenerF2MBfoykaKpl92ZGoPNOvaZ7ZXLWhvuzKAklCD7HMdYnYrRMRJyy6PWwXRywcDzrSO00DZjy1CjG";

class PaymentPage extends StatefulWidget {
  static const route = '/payment';
  const PaymentPage({Key? key}) : super(key: key);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Map<String, dynamic>? paymentIntent;

  @override
  void initState() {
    super.initState();
    // Call makePayment when the screen loads
    makePayment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stripe Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // You can optionally display a loading indicator or message here
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent('100', 'USD');

      // STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'KIMA'))
          .then((value) {});

      // STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      print('Error in makePayment: $err');
      // Handle error gracefully, show a message to the user
      Fluttertoast.showToast(msg: 'Error in making payment. Please try again.');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 100.0,
                ),
                SizedBox(height: 10.0),
                Text("Payment Successful!"),
              ],
            ),
          ),
        );

        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error in displayPaymentSheet: $error');
        // Handle error gracefully, show a message to the user
        Fluttertoast.showToast(
            msg: 'Error in displaying payment sheet. Please try again.');
      });
    } on StripeException catch (e) {
      print('StripeException: $e');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.cancel,
                    color: Colors.red,
                  ),
                  Text("Payment Failed"),
                ],
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      print('Error in displayPaymentSheet: $e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      // Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      // Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      print('Error in createPaymentIntent: $err');
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}
