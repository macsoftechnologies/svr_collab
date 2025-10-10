import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:svr/models/home_icons_models/resend_otp_model.dart';
import 'package:svr/views/home_icons_views/reset_password_page.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  resendOTPmodel? resendOtp;
  bool isLoading = false;
  int? status;
  String? message;
  String? user_id;

  TextEditingController emailAddress = TextEditingController();

Future<void> _resendOTP() async {
  final email = emailAddress.text.trim();

  if (email.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please enter your email address.')),
    );
    return;
  }

  try {
    setState(() {
      isLoading = true;
    });

    print("📤 Sending email: $email");

    final response = await http.post(
      Uri.parse('https://svracademy.in/services/users/sendforgotOTPPassword'),
      headers: {
        "auth-key": "svrapi",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: {
        'email': email,
      },
    );

    final decodeJson = jsonDecode(response.body);

    // ✅ Check for successful response
    if (response.statusCode == 200) {
      var resendOtp = resendOTPmodel.fromJson(decodeJson);

      setState(() {
        status = resendOtp.status ?? 0;
        message = resendOtp.message ?? "";
        user_id = resendOtp.userId ?? "";
        isLoading = false;
      });

      print("✅ OTP sent. User ID: $user_id");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? 'OTP sent successfully.')),
      );


      Navigator.push(
  context,
  MaterialPageRoute(
    builder: (BuildContext context) => ResetPasswordPage(user_id: user_id ?? ''),
  ),
);


      
    } else {
    
      final errorMessage = decodeJson['message'] ?? 'Unknown error from API';
      print("❌ API Error: $errorMessage");

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  } catch (e) {
    setState(() {
      isLoading = false;
    });


    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Something went wrong. Please try again.')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFBB),
      appBar: AppBar(
     
        backgroundColor: Colors.black,
        title: const Text(
          'Forgot Password',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Step 1 : Enter your Email..', style: TextStyle(fontWeight: FontWeight.w900),),
                  SizedBox(height: 20,),
                  TextField(
                    controller: emailAddress,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Please Enter your Email Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _resendOTP,
                          child: const Text('Send OTP'),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
