import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

String sk_2 =
    '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';

String s_sk1 =
    "sk_test_51NkM0pFcfThzV7D63Dgh7KZTqlNXCBgWhU2RttBUdp1Y6cOcdtSQRzg3Ibsgzzn1uVDpm91DGM0ndbKpHx2HJ8zm00SNaEqrCE";

String p_key =
    "pk_test_51NkM0pFcfThzV7D6UHenerF2MBfoykaKpl92ZGoPNOvaZ7ZXLWhvuzKAklCD7HMdYnYrRMRJyy6PWwXRywcDzrSO00DZjy1CjG";

class StripePaymentHandler {
  static Future<void> initStripe() async {
    Map<String, dynamic>? paymentIntent;
    try {
      Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntent![
            "sk_test_51NkM0pFcfThzV7D63Dgh7KZTqlNXCBgWhU2RttBUdp1Y6cOcdtSQRzg3Ibsgzzn1uVDpm91DGM0ndbKpHx2HJ8zm00SNaEqrCE"],
      ));
    } catch (e) {
      print("Failed to initialize Stripe: $e");
      throw Exception("Failed to initialize Stripe");
    }
  }

  static Future<void> handlePayment() async {
    try {
      final paymentIntent = await createPaymentIntent('100', 'USD');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent[
              'sk_test_51NkM0pFcfThzV7D63Dgh7KZTqlNXCBgWhU2RttBUdp1Y6cOcdtSQRzg3Ibsgzzn1uVDpm91DGM0ndbKpHx2HJ8zm00SNaEqrCE'],
        ),
      );
      await Stripe.instance.presentPaymentSheet();

      Fluttertoast.showToast(msg: 'Payment successfully completed');
    } on StripeException catch (e) {
      Fluttertoast.showToast(
          msg: 'Error from Stripe: ${e.error.localizedMessage}');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Unforeseen error: $e');
    }
  }

  static Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer your_secret_key', // Replace with your actual secret key
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': calculateAmount(amount),
          'currency': currency,
        },
      );

      return json.decode(response.body);
    } catch (err) {
      print('Error creating payment intent: $err');
      throw Exception('Error creating payment intent');
    }
  }

  static String calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}
