import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

const kAndroidUserAgent =
    "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36";

// Create Payment Request Function
Future<void> createPaymentRequest(String courseId, String courseAmount, String email, BuildContext context) async {
  Map<String, String> body = {
    "amount": courseAmount,
    "purpose": "Course Payment", // Description of payment
    "buyer_name": "User Name", // You can use the name from registration
    "email": email,
    "phone": "User Phone", // You can use the phone from registration
    "allow_repeated_payments": "true",

    
    "send_email": "false",
    "send_sms": "false",
    "redirect_url": "http://www.example.com/redirect/",
    "webhook": "http://www.example.com/webhook/",
  };

  try {
    var resp = await http.post(
      Uri.parse("https://test.instamojo.com/api/1.1/payment-requests/"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
        "X-Api-Key": "10d10deec5c9d812ef9df1166186c636", // Replace with your Instamojo API key
        "X-Auth-Token": "3042e520659ef254ec691d8cb3018c40" // Replace with your Instamojo Auth token
      },
      body: body,
    );

    if (json.decode(resp.body)['success'] == true) {
      String selectedUrl = json.decode(resp.body)["payment_request"]['longurl'] + "?embed=form";

      // Launch WebView for payment
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentWebViewPage(url: selectedUrl),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${json.decode(resp.body)['message']}')));
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
  }
}

// Payment WebView Page
class PaymentWebViewPage extends StatefulWidget {
  final String url;
  const PaymentWebViewPage({Key? key, required this.url}) : super(key: key);

  @override
  _PaymentWebViewPageState createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // Initialize the WebView plugin
   // WebViewPlatform.instance.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Gateway'),
      ),

      );

  }
}
