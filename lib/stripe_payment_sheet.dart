// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;



class StripePaymentSheet extends StatefulWidget {
  const StripePaymentSheet({super.key});

  @override
  State<StripePaymentSheet> createState() => _StripePaymentSheetState();
}
 
class _StripePaymentSheetState extends State<StripePaymentSheet> {
  final controller = CardFormEditController();
  @override
  void initState() {
    controller.addListener(update);
    Stripe.instance.isPlatformPaySupportedListenable.addListener(update);
  
    // initializePaymentSheet();
    super.initState();
  }
  
  void update() {
    setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(update);
    controller.dispose();
    Stripe.instance.isPlatformPaySupportedListenable.removeListener(update);
    super.dispose();
  }
Map<String, dynamic>? paymentIntent;

Future<void> stripeMakePayment() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      paymentIntent = await createPaymentIntent();
      await Stripe.instance
          .initCustomerSheet(
              customerSheetInitParams: const CustomerSheetInitParams(
                googlePayEnabled: false,
                applePayEnabled: false,
                setupIntentClientSecret: "pk_test_51MsVdYDqiInJXIaHcWTgISTyUDBilPfMZXk5E8ZrNlgpQsTIrOc9jWGPnPKW94kajVuFdFROp3YpIjckr4iXfhHc00HofV78ez",
                //appearance: PaymentSheetAppearance(),
                // merchantDisplayName: "Bless",
                //returnURL: "https://www.google.com/",
                // style: ThemeMode.light,
                customerId: "cus_PnwRARJWIc7IbY", customerEphemeralKeySecret: "ek_test_YWNjdF8xTXNWZFlEcWlJbkpYSWFILHlXTk9QWG9mSjFTVVlNeThoWmVockMwQlNSVU1HbEI_00OFU0RXdV"))
          .then((value) {});

      //STEP 3: Display Payment sheet
      await displayPaymentSheet();
    } catch (e) {
      print(e.toString());
    }
  }

// Future<void> makePayment() async {
//     try {
//       paymentIntent = await createPaymentIntent();
//       // var applePay = const PaymentSheetApplePay(
//       //   merchantCountryCode: "CA",
//       // );
//       // var googlePay = PaymentSheetGooglePay(
//       //   merchantCountryCode: "CA",

//       // );
//       await Stripe.instance.initPaymentSheet(
        
//         paymentSheetParameters: SetupPaymentSheetParameters(
//         customFlow: false,
//         primaryButtonLabel: "Reserve & Pay Now",
//         allowsDelayedPaymentMethods: true,
//         customerEphemeralKeySecret: "",
//         paymentIntentClientSecret: paymentIntent!["client_secret"],
//         style: ThemeMode.light,
//         merchantDisplayName: "Bless",
//         appearance: const PaymentSheetAppearance(

//         )
//         // applePay: applePay,
//       )
      
//       );
//       displayPaymentSheet();
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }

// Future<void> makePayment() async {
//   try {
//     paymentIntent = await createCustomer();
//     await Stripe.instance.initPaymentSheet(
      
//       paymentSheetParameters: SetupPaymentSheetParameters(
//         customFlow: false,
//         paymentIntentClientSecret: paymentIntent!["client_secret"],
//         //style: ThemeMode.light,
//         merchantDisplayName: "Bless",
        
//       ),
      
//     );
//     await Stripe.instance.initCustomerSheet(
//       customerSheetInitParams: const CustomerSheetInitParams(
//         customerId: '', 
//         customerEphemeralKeySecret: "",
//         googlePayEnabled: true,
//         )
//     );
//     displayPaymentSheet();
//   } catch (e) {
//     throw Exception(e.toString());
//   }
// }
List<Map<String, String>> presetCustomers = [
  {
    'id': 'cus_PnwRARJWIc7IbY',
    'secret': 'ek_test_YWNjdF8xTXNWZFlEcWlJbkpYSWFILFM3ZTJBRnliNlViY3ZzMUhKRHF4SGxrc2lUTjhxZHc_00sjRH3iF0',
    "currency": "USD",
  },
  {
    'id': 'cus_2',
    'secret': 'ephemeral_secret_2',
  },
  // Add more customers as needed
];

// Function to retrieve a preset customer by index
Map<String, String> getPresetCustomer(int index) {
  return presetCustomers[index];
}
// Future<void> makePayment() async {
//   try {
//     // Create a customer
//     Map<String, String> customer = getPresetCustomer(0);
    
    
//     // Ensure that customerId and customerEphemeralKeySecret are not null
//     String? customerId = customer['id'];
//     String? customerEphemeralKeySecret = customer['secret'];
//     if (customerId == null || customerEphemeralKeySecret == null) {
//       throw Exception("Customer ID or Ephemeral Key Secret is null.");
//     }

//     // Initialize the customer sheet with the customer ID and other parameters
//     // await Stripe.instance.initCustomerSheet(
      
//     //   customerSheetInitParams: CustomerSheetInitParams(
        
//     //     customerId: customerId,
//     //     customerEphemeralKeySecret: customerEphemeralKeySecret,
//     //     googlePayEnabled: false,
//     //   ),
//     // );

//     // Display the customer sheet for payment
//     displayPaymentSheet();
//   } catch (e) {
//     throw Exception(e.toString());
//   }
// }


  Future displayPaymentSheet() async {
    try {
      await Stripe.instance.presentCustomerSheet(
        options: const CustomerSheetPresentParams(
          presentationStyle: CustomerSheetPresentationStyle.fullscreen,
          timeout: 36000,
        )
      );

      print("done");
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  createPaymentIntent() async {
    try {
      Map<String, dynamic> body = {
        "amount": "1000",
        "currency": "USD",
      };
      http.Response response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization":
                "Bearer sk_test_51MsVdYDqiInJXIaHOJuaewpvfOSTmfvZ6jgiZmozrewB2nEtc5PZDDBpNS8oeOQssr33fuxxCZ4J1mgQOXpubzj400WXZQrCr9",
            "Content-Type": "application/x-www-form-urlencoded",
          });
      // ignore: void_checks
      return json.decode(response.body);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  Future<Map<String, dynamic>> createCustomer() async {
  try {
    Map<String, dynamic> body = {
      // Add parameters to create a customer, such as email or name
      "email": "customer@example.com",
      "currency": "USD",
    };
    // pk_test_51MsVdYDqiInJXIaHcWTgISTyUDBilPfMZXk5E8ZrNlgpQsTIrOc9jWGPnPKW94kajVuFdFROp3YpIjckr4iXfhHc00HofV78ez
    http.Response response = await http.post(
      Uri.parse("https://api.stripe.com/v1/customers"),
      body: body,
      headers: {
        "Authorization": "Bearer sk_test_51MsVdYDqiInJXIaHOJuaewpvfOSTmfvZ6jgiZmozrewB2nEtc5PZDDBpNS8oeOQssr33fuxxCZ4J1mgQOXpubzj400WXZQrCr9",
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );
    return json.decode(response.body);
  } catch (e) {
    throw Exception(e.toString());
  }
}
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          TextButton(onPressed: () async {
            stripeMakePayment();
          }, child: const Text('Stripe Payment Sheet', style: TextStyle(color: Colors.purple, fontSize: 30),)),
          CardField(
            onCardChanged: (card) {
              setState(() {
                card = card;
              });
            },
          ),
          
          ElevatedButton(
            onPressed: () {

            },
            child: const Text('Pay'),
          )
        ],
      ),
    );
  }
}

Future<void> showPaymentSheet(Map<String, dynamic> paymentSheetData) async {
  try {
    await Stripe.instance.presentPaymentSheet();
    // Handle the success or any post-PaymentSheet logic here
  } catch (error) {
    print('Failed to present PaymentSheet. Error: $error');
    // Handle errors during the presentation of PaymentSheet
  }
}