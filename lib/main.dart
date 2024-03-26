import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_flutter/app_constants.dart';
import 'package:stripe_flutter/stripe_payment_sheet.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = StripeDetail.publishableKey;
  Stripe.merchantIdentifier = MerchantId.merchantId;
  Stripe.instance.applySettings();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primaryColor: Colors.blue, // Define your primaryColor
        
      ),
      home: const Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 300),
          child: Center(
            child: StripePaymentSheet(),
          ),
        ),
      ),
    );
  }
}
