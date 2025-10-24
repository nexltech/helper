// import 'dart:convert';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
// import 'stripe_const.dart';

// class StripeService {
//   StripeService._();

//   static final StripeService instance = StripeService._();

//   /// Initialize Stripe with publishable key
//   Future<void> initializeStripe() async {
//     Stripe.publishableKey = StripeConst.publishableKey;
//   }

//   /// Create a payment intent with the specified amount and currency
//   Future<String?> createPaymentIntent(double amount, String currency) async {
//     try {
//       // Convert amount to cents (Stripe requires amounts in cents)
//       final int amountInCents = (amount * 100).round();
      
//       final Map<String, String> headers = {
//         'Authorization': 'Bearer ${StripeConst.secretKey}',
//         'Content-Type': 'application/x-www-form-urlencoded',
//       };

//       final Map<String, String> body = {
//         'amount': amountInCents.toString(),
//         'currency': currency,
//       };

//       final response = await http.post(
//         Uri.parse(StripeConst.paymentIntentUrl),
//         headers: headers,
//         body: body,
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         return data['client_secret'];
//       } else {
//         print('Error creating payment intent: ${response.statusCode} - ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('Error creating payment intent: $e');
//       return null;
//     }
//   }

//   /// Process payment using Stripe Payment Sheet
//   Future<bool> processPayment(double amount, String currency) async {
//     try {
//       // Initialize Stripe
//       await initializeStripe();
      
//       // Create payment intent
//       String? paymentIntentClientSecret = await createPaymentIntent(amount, currency);
      
//       if (paymentIntentClientSecret == null) {
//         print('Failed to create payment intent');
//         return false;
//       }

//       // Initialize payment sheet
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: paymentIntentClientSecret,
//           merchantDisplayName: StripeConst.merchantDisplayName,
//         ),
//       );

//       // Present payment sheet
//       await Stripe.instance.presentPaymentSheet();
      
//       return true;
//     } catch (e) {
//       print('Error processing payment: $e');
//       return false;
//     }
//   }

//   /// Process payment with custom parameters
//   Future<bool> processPaymentWithDetails({
//     required double amount,
//     required String currency,
//     String? customerEmail,
//     Map<String, dynamic>? metadata,
//   }) async {
//     try {
//       // Initialize Stripe
//       await initializeStripe();
      
//       // Create payment intent with additional parameters
//       String? paymentIntentClientSecret = await _createPaymentIntentWithDetails(
//         amount: amount,
//         currency: currency,
//         customerEmail: customerEmail,
//         metadata: metadata,
//       );
      
//       if (paymentIntentClientSecret == null) {
//         print('Failed to create payment intent');
//         return false;
//       }

//       // Initialize payment sheet
//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: paymentIntentClientSecret,
//           merchantDisplayName: StripeConst.merchantDisplayName,
//           customerId: customerEmail,
//         ),
//       );

//       // Present payment sheet
//       await Stripe.instance.presentPaymentSheet();
      
//       return true;
//     } catch (e) {
//       print('Error processing payment with details: $e');
//       return false;
//     }
//   }

//   /// Create payment intent with additional details
//   Future<String?> _createPaymentIntentWithDetails({
//     required double amount,
//     required String currency,
//     String? customerEmail,
//     Map<String, dynamic>? metadata,
//   }) async {
//     try {
//       // Convert amount to cents
//       final int amountInCents = (amount * 100).round();
      
//       final Map<String, String> headers = {
//         'Authorization': 'Bearer ${StripeConst.secretKey}',
//         'Content-Type': 'application/x-www-form-urlencoded',
//       };

//       final Map<String, String> body = {
//         'amount': amountInCents.toString(),
//         'currency': currency,
//       };

//       // Add optional parameters
//       if (customerEmail != null) {
//         body['receipt_email'] = customerEmail;
//       }

//       if (metadata != null) {
//         metadata.forEach((key, value) {
//           body['metadata[$key]'] = value.toString();
//         });
//       }

//       final response = await http.post(
//         Uri.parse(StripeConst.paymentIntentUrl),
//         headers: headers,
//         body: body,
//       );

//       if (response.statusCode == 200) {
//         final Map<String, dynamic> data = json.decode(response.body);
//         return data['client_secret'];
//       } else {
//         print('Error creating payment intent with details: ${response.statusCode} - ${response.body}');
//         return null;
//       }
//     } catch (e) {
//       print('Error creating payment intent with details: $e');
//       return null;
//     }
//   }
// }



import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeConst {
  static const String publishableKey = 'pk_test_51SGDtYJAVI53OiaX0HqCn1VxGDCVhcFY9z6lk9NU97XiqP8P2IUGiXmOr4PdjxiNQ416IUUeeToLeWzCoET9msdl00DkYBd6eu';
  static const String secretKey = 'sk_test_51SGDtYJAVI53OiaXTFqhqVxJgabFb2KAkubL5nQe98251XPksAXjg6hiMRTq89DAnWKUOwfvAS5YwGx4DZ2Md5VH000V9lmezF';
  static const String paymentIntentUrl = 'https://api.stripe.com/v1/payment_intents';
  static const String merchantDisplayName = 'Your Merchant Name';
}

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  /// Initialize Stripe with publishable key
  Future<void> initializeStripe() async {
    Stripe.publishableKey = StripeConst.publishableKey;
  }

  /// Create a payment intent with the specified amount and currency
  Future<String?> createPaymentIntent(double amount, String currency) async {
    try {
      final int amountInCents = (amount * 100).round();

      final Map<String, String> headers = {
        'Authorization': 'Bearer ${StripeConst.secretKey}',
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final Map<String, String> body = {
        'amount': amountInCents.toString(),
        'currency': currency,
      };

      final response = await http.post(
        Uri.parse(StripeConst.paymentIntentUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['client_secret'];
      } else {
        print('Error creating payment intent: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error creating payment intent: $e');
      return null;
    }
  }

  /// Process payment using Stripe Payment Sheet
  Future<bool> processPayment(double amount, String currency) async {
    try {
      await initializeStripe();

      String? paymentIntentClientSecret = await createPaymentIntent(amount, currency);

      if (paymentIntentClientSecret == null) {
        print('Failed to create payment intent');
        return false;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: StripeConst.merchantDisplayName,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      return true;
    } catch (e) {
      print('Error processing payment: $e');
      return false;
    }
  }

  /// Process payment with custom parameters
  Future<bool> processPaymentWithDetails({
    required double amount,
    required String currency,
    String? customerEmail,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await initializeStripe();

      String? paymentIntentClientSecret = await _createPaymentIntentWithDetails(
        amount: amount,
        currency: currency,
        customerEmail: customerEmail,
        metadata: metadata,
      );

      if (paymentIntentClientSecret == null) {
        print('Failed to create payment intent');
        return false;
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: StripeConst.merchantDisplayName,
          customerId: customerEmail,
        ),
      );

      await Stripe.instance.presentPaymentSheet();

      return true;
    } catch (e) {
      print('Error processing payment with details: $e');
      return false;
    }
  }

  /// Create payment intent with additional details
  Future<String?> _createPaymentIntentWithDetails({
    required double amount,
    required String currency,
    String? customerEmail,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final int amountInCents = (amount * 100).round();

      final Map<String, String> headers = {
        'Authorization': 'Bearer ${StripeConst.secretKey}',
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final Map<String, String> body = {
        'amount': amountInCents.toString(),
        'currency': currency,
      };

      if (customerEmail != null) {
        body['receipt_email'] = customerEmail;
      }

      if (metadata != null) {
        metadata.forEach((key, value) {
          body['metadata[$key]'] = value.toString();
        });
      }

      final response = await http.post(
        Uri.parse(StripeConst.paymentIntentUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data['client_secret'];
      } else {
        print('Error creating payment intent with details: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error creating payment intent with details: $e');
      return null;
    }
  }
}
