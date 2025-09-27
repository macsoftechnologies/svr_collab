import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svr/utils/colors.dart';
import 'package:svr/views/home_screen.dart';

import '../utils/global_keys.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    startTime();
    super.initState();
  }

  startTime() {
    Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (mounted) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        // bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

        if (prefs.getString("userData") == null || prefs.getString("userData") == "") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const LoginPage(),
            ),
          );
        } else {
          String encodedMap = prefs.getString('userData').toString();
          Map<String, dynamic> data = json.decode(encodedMap);
          userId = data['user_id'];
          userName = data['name'];
          userEmail = data['email'];
          userMobileNumber = data['mobile_number'];
          userCourseId = data['course_id'];
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const HomeScreen(),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/svrhd.png"),
              const SizedBox(
                height: 20,
              ),
              const CircularProgressIndicator(
                color: Colors.black,

              ),

            ],
          )),
    );
  }
}
