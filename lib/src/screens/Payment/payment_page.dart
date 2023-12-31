// import 'package:flutter/material.dart';

// class PaymentPage extends StatefulWidget {
//   @override
//   _PaymentPageState createState() => _PaymentPageState();
// }

// class _PaymentPageState extends State<PaymentPage> {
//   late TextEditingController paymentController;
//   late GlobalKey<FormState> paymentForm;
//   Map<String, dynamic>? paymentIntentData;

//   @override
//   void initState() {
//     super.initState();
//     paymentController = TextEditingController();
//     paymentForm = GlobalKey<FormState>();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Stripe Payment Example'),
//         centerTitle: true,
//         backgroundColor: Theme.of(context).colorScheme.secondary,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: paymentForm,
//           child: ListView(
//             shrinkWrap: true,
//             children: [
//               TextFormField(
//                 controller: paymentController,
//                 inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return 'Required field';
//                   }
//                   return null;
//                 },
//                 decoration: InputDecoration(
//                   hintText: 'Enter an amount',
//                   fillColor: const Color(0xffF5F5F5),
//                   filled: true,
//                   border: InputBorder.none,
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                     borderSide: const BorderSide(
//                       color: Color(0xff1D275C),
//                       width: 2.01,
//                     ),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                     borderSide: const BorderSide(
//                       color: Color(0xffCCCCCC),
//                       width: 2.0,
//                     ),
//                   ),
//                   errorBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                     borderSide: const BorderSide(
//                       color: Color(0xffD6001A),
//                       width: 2.0,
//                     ),
//                   ),
//                   focusedErrorBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                     borderSide: const BorderSide(
//                       color: Color(0xffF0642F),
//                       width: 2.0,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   if (paymentForm.currentState!.validate()) {
//                     debugPrint(paymentController.text);
//                     var paymentAmount = int.parse(paymentController.text) * 100;

//                     makePayment(
//                         amount: paymentAmount.toString(), currency: "USD");
//                   }
//                 },
//                 child: const Text('Make Payment'),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
