import 'dart:convert';

import 'package:stripe_payment/stripe_payment.dart';
import 'package:http/http.dart' as http;
import 'dart:io' show Platform;
import './Constants.dart' as Constants;

double tax = 0;
int totalCost = 10;
double taxPercent = 0.02;
int amount = 200;
int tip = 1;
void checkIfNativePayReady() async {
  print('Started to check if native pay ready');
  bool deviceSupportNativePay = await StripePayment.deviceSupportsNativePay();
  if (deviceSupportNativePay) print("Device can support native pay");
  bool isNativeReady = await StripePayment.canMakeNativePayPayments(['american_express', 'visa', 'maestro', 'master_card']);
  if (isNativeReady) print("Device is native pay ready");
  deviceSupportNativePay && isNativeReady ? createPaymentMethodNative() : createPaymentMethod();
}

Future<void> createPaymentMethodNative() async {
  print('started NATIVE payment...');

  StripePayment.setStripeAccount(null);

  if (Platform.isIOS) {
    //_controller.jumpTo(450);
  }
  var paymentToken = await StripePayment.paymentRequestWithNativePay(
    androidPayOptions: AndroidPayPaymentRequest(
      totalPrice: "1.00",
      currencyCode: "USD",
    ),
    applePayOptions: ApplePayPaymentOptions(
      countryCode: 'US',
      currencyCode: 'USD',
      items: [
        ApplePayItem(
          label: 'Test',
          amount: '1.00',
        )
      ],
    ),
  ).catchError((error) {
    print("RAN INTO ERROR: " + error);
    return null;
  });
  PaymentMethod paymentMethod = PaymentMethod();
  paymentMethod = await StripePayment.createPaymentMethod(
    PaymentMethodRequest(
      card: CreditCard(
        token: paymentToken.tokenId,
      ),
    ),
  );
  paymentMethod != null
      ? processPaymentAsDirectCharge(paymentMethod)
      : print('It is not possible to pay with this card. Please try again with a different card');
}

// ignore: missing_return
Future<PaymentMethod> createPaymentMethod() async {
  StripePayment.setStripeAccount(null);
  tax = ((totalCost * taxPercent) * 100).ceil() / 100;
  amount = ((totalCost + tip + tax) * 100).toInt();
  print('amount in pence/cent which will be charged = $amount');
  //step 1: add card
  await StripePayment.paymentRequestWithCardForm(
    CardFormPaymentRequest(),
  ).then((PaymentMethod paymentMethod) {
    return paymentMethod;
  }).catchError((e) {
    print('Errore Card: ${e.toString()}');
    return null;
  });
}

Future<void> processPaymentAsDirectCharge(PaymentMethod paymentMethod) async {
  //step 2: request to create PaymentIntent, attempt to confirm the payment & return PaymentIntent
  //String url = 'https://us-central1-demostripe-b9557.cloudfunctions.net/StripePI';
  //final http.Response response = await http.post('$url?amount=$amount&currency=USD&paym=${paymentMethod.id}');
  //print(response.toString());
  http.Response response = await getStripeIntent(paymentMethod);
  print(response.body);
  if (response.body != null && response.body != 'error') {
    final paymentIntentX = jsonDecode(response.body);
    final status = paymentIntentX['paymentIntent']['status'];
    final strAccount = paymentIntentX['stripeAccount'];
    //step 3: check if payment was succesfully confirmed
    if (status == 'succeeded') {
      //payment was confirmed by the server without need for futher authentification
      StripePayment.completeNativePayRequest();

      print('Payment completed. ${paymentIntentX['paymentIntent']['amount'].toString()}p succesfully charged');
    } else {
      //step 4: there is a need to authenticate
      StripePayment.setStripeAccount(strAccount);
      await StripePayment.confirmPaymentIntent(PaymentIntent(
              paymentMethodId: paymentIntentX['paymentIntent']['payment_method'], clientSecret: paymentIntentX['paymentIntent']['client_secret']))
          .then(
        (PaymentIntentResult paymentIntentResult) async {
          //This code will be executed if the authentication is successful
          //step 5: request the server to confirm the payment with
          final statusFinal = paymentIntentResult.status;
          if (statusFinal == 'succeeded') {
            StripePayment.completeNativePayRequest();
          } else if (statusFinal == 'processing') {
            StripePayment.cancelNativePayRequest();
            print('The payment is still in \'processing\' state. This is unusual. Please contact us');
          } else {
            StripePayment.cancelNativePayRequest();
            print('There was an error to confirm the payment. Details: $statusFinal');
          }
        },
        //If Authentication fails, a PlatformException will be raised which can be handled here
      ).catchError((e) {
        //case B1
        StripePayment.cancelNativePayRequest();
        print('There was an error to confirm the payment. Please try again with another card 1');
      });
    }
  } else {
    //case A
    StripePayment.cancelNativePayRequest();
    print('There was an error in creating the payment. Please try again with another card 2');
  }
}

Future<http.Response> getStripeIntent(PaymentMethod paymentMethod) async {
  try {
    String uri = Constants.nodeURL + "stripe/getStripeIntent";
    print("Sending post request to: " + uri);
    String reqString = '$uri?amount=$amount&currency=USD&paym=${paymentMethod.id}';
    Uri reqUri = Uri.http(reqString, "");
    http.Response response = await http.post(reqUri);
    return response;
  } catch (e) {
    print("ERROR on getting Stripe INTENT");
    return null;
  }
}
