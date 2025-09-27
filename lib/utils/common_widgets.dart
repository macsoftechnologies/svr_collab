import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svr/views/login_page.dart';

import '../services/web_service.dart';
import 'colors.dart';

class CommonWidgets
{
  appBar(text,BuildContext context)
  {
    return AppBar(
      backgroundColor:primaryColor,
      title: Text("$text"),
      actions: [
        TextButton(
          onPressed: () {
            logout(context);
          },
          child: const Text(
            "Logout",
            style: TextStyle(color: Colors.white, fontSize: 16), // Style the text as needed
          ),
        ),
      ],
    );
  }
  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      // Get user ID from SharedPreferences
      String? userDataString = prefs.getString('userData');
      if (userDataString == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User data not found')),
        );
        return; // Don't proceed
      }

      Map<String, dynamic> userData = json.decode(userDataString);
      String userId = userData['user_id'].toString();

      // Make logout API call
      final response = await http.post(
        Uri.parse('https://svracademy.in/services/users/logout'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': userId}),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> result = json.decode(response.body);

        if (result['status'] == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Logout Successfully!')),
          );
          // API success - clear data and navigate
          await prefs.setBool('isLoggedIn', false);
          await prefs.remove('userData');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        } else {
          // API returned error status
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Logout failed: ${result['message']}')),
          );
        }
      } else {
        // HTTP error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed: HTTP ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }
  // Future<void>logout(BuildContext context) async {
  //   //sk
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? userDataString = prefs.getString('userData');
  //
  //   // Clear user data and set login status to false
  //
  //   print("iamInLogout");
  //
  //   if (userDataString != null) {
  //     // Decode the JSON string into a Map
  //     Map<String, dynamic> userData = json.decode(userDataString);
  //     // Access the 'user_id' key
  //     String userId = userData['user_id'];
  //     // Print the user ID to the console
  //     print('User ID: $userId');
  //     try {
  //       Map<String, dynamic> result = (await WebService().logoutFromApp()) as Map<String, dynamic>;
  //       if (result['status'] == 200) {
  //         print('Logout API call successful');
  //         print('Message: ${result['message']}');
  //         await prefs.setBool('isLoggedIn', false);
  //         await prefs.remove('userData');
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (BuildContext context) => const LoginPage(),
  //           ),
  //         );
  //       } else {
  //         print('Logout API call failed: ${result['message']}');
  //         throw Exception('Failed to logout');
  //       }
  //     } catch (e) {
  //       print('An error occurred: $e');
  //       // You can show a snackbar or toast here if needed
  //     }
  //   }
  //  print(prefs.getString('userData'));
  //
  //
  //
  //
  //   // await prefs.setBool('isLoggedIn', false);
  //
  //   // Navigate to login screen or any other screennnnnnnnnnnnnnnnnnn
  //   // await prefs.remove('userData');
  //   //
  //
  // }
}