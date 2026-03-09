import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svr/models/live_courses_model.dart';

import 'package:svr/utils/colors.dart';
import 'package:svr/view_models/home_icons_view_models/payment_view_model.dart';
import 'package:svr/view_models/live_courses_view_model.dart';
import 'package:svr/view_models/register_view_model.dart';
import 'package:svr/views/demo_courses.dart';
import 'package:svr/views/home_icons_views/forgot_password.dart';
import 'package:svr/views/home_screen.dart';

import '../utils/global_keys.dart';
import '../utils/snackbars_list.dart';
import '../view_models/login_view_model.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  




  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.lightBlue[50],
        appBar: AppBar(
          backgroundColor: primaryColor,
          centerTitle: true,
          title: const Text('Login & Signup'),
          toolbarHeight: 100,
          bottom: TabBar(
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            labelColor: whiteColor,
            tabs: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Tab(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      color: Colors.orange,  // Set the background color to orange
                      borderRadius: BorderRadius.circular(30),  // Rounded corners for button effect
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(color: Colors.white),  // Text color
                    ),
                  ),
                ),
              ),
              // Customizing the "Signup" tab
               Tab(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.orange,  // Set the background color to orange
                    borderRadius: BorderRadius.circular(30),  // Rounded corners for button effect
                  ),
                  child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white),  // Text color
                  ),
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          
          children: [
            LoginCard(),
            SignupCard(),
          ],
        ),
      ),
    );
  }
}

class LoginCard extends StatefulWidget {
  const LoginCard({super.key});

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  bool loading = false;

  TextEditingController emailmobile = TextEditingController();

  TextEditingController password = TextEditingController();
  
String? userId;

@override
void initState() {
  super.initState();

}







  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(
      children: [
        Card(
          margin: const EdgeInsets.all(20.0),
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(55), // Image radius
                        child: Image.asset('assets/logo.jpeg', fit: BoxFit.cover),
                      ),
                    ),
                    TextField(
                      controller: emailmobile,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: 'Email / Phone Number'),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: password,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                    const SizedBox(height: 30),
                    loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(primaryColor)),
                            onPressed: () async {
                              setState(() {
                                loading = true;
                              });
                              await loginValidation();
                              setState(() {
                                loading = false;
                              });
                          
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),
                            ),
                            
                          ),
                  ],
                ),
              )),
        ),


        Positioned(
            right: 30,
            child: InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(

                  builder: (BuildContext context) => const DemoCourses(),
                ),
              ),
              child: const Text(
               "",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            )),
        Positioned(

            right: 30,
            top: 390,
            child: InkWell(
              onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder:(BuildContext context)=> const ForgotPassword())
                  ,);
                   },
              child: const Text(
                "Forgot password",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              
            )),
      ],
    ));
  }



//   loginValidation() async {
//     RegExp numberCheck = RegExp(r'^-?[0-9]+$');
//     String? deviceId = await getDeviceId();
//     var pattern =
//         r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//     RegExp regex = RegExp(pattern);
//     if (emailmobile.text.isEmpty) {
//       SnackBarsList().errorSnackBar(context, "Please Enter Email / Phone Number");
//     } else if (password.text.isEmpty) {
//       SnackBarsList().errorSnackBar(context, "Please Enter Password");
//     } else if(deviceId == null){
//        SnackBarsList().errorSnackBar(context, "Device Id is Missing");
//     }else{
//       if (numberCheck.hasMatch(emailmobile.text[0].toString())) {
//         if (emailmobile.text.length != 10 || emailmobile.text.toString().contains(RegExp(r'[a-z]'))) {
//           SnackBarsList().errorSnackBar(context, "Please Enter Valid Phone Number");
//         } else {
//           if (regex.hasMatch(emailmobile.text.toString())) {
//             try {
//               print('i am in Login');
//               print('Name ${emailmobile.text}');
//               print('Name ${password.text}');
//               print('Device Id ${deviceId}');
//               //print('Name ${}');
//               LoginViewModel loginViewModel = LoginViewModel();
//               await loginViewModel.fetchLoginData(emailmobile.text, password.text, deviceId);

//               Map<String, dynamic> data = loginViewModel.loginData;
//               SharedPreferences prefs = await SharedPreferences.getInstance();
//               prefs.setBool('isLoggedIn', true);
//               String encodedMap = json.encode(data);
//               userId = data['user_id'];
//               userName = data['name'];
//               userEmail = data['email'];
//               userMobileNumber = data['mobile_number'];
//               userCourseId = data['course_id'];
//               prefs.setString('userData', encodedMap);
//                 String? userDeviceIdFromServer = data['device_id']; // <- This might be null

//     print("✅ User Device ID from server: $userDeviceIdFromServer");
//               //  prefs.setString('userData', encodedMap);

// // Set login status to true

//              Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (BuildContext context) => HomeScreen(
       
//         ),
//       ),
//     );
//               SnackBarsList().successSnackBar(context, "Login Success");
//             } catch (e) {
//               SnackBarsList().errorSnackBar(context, "Login Failed...\nPlease Enter Proper Details");
//             }
//           } else {
//             SnackBarsList().errorSnackBar(context, "Please Enter Valid Email Address");
//           }

       
//         }
//       } else {
//         if (regex.hasMatch(emailmobile.text.toString())) {
//           try {
//             LoginViewModel loginViewModel = LoginViewModel();
//             await loginViewModel.fetchLoginData(emailmobile.text, password.text, deviceId);
//             Map<String, dynamic> data = loginViewModel.loginData;
//             SharedPreferences prefs = await SharedPreferences.getInstance();
//             String encodedMap = json.encode(data);
//             userId = data['user_id'];
//             userName = data['name'];
//             userEmail = data['email'];
//             userMobileNumber = data['mobile_number'];
//             userCourseId = data['course_id'];
//             prefs.setString('userData', encodedMap);
//             String? userDeviceIdFromServer = data['device_id']; // <- This might be null

//     print("✅ User Device ID from server: $userDeviceIdFromServer");
//             Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (BuildContext context) => HomeScreen(
    
//         ),
//       ),
//     );
//             SnackBarsList().successSnackBar(context, "Login Success");
//           } catch (e) {
//             SnackBarsList().errorSnackBar(context, "Login Failed...\nPlease Enter Proper Details");
//           }
//         } else {
//           SnackBarsList().errorSnackBar(context, "Please Enter Valid Email Address");
//         }
//       }
//     }
//   }
// }

Future<void> loginValidation() async {
  RegExp emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  String input = emailmobile.text.trim();
  String pass = password.text.trim();
  String? deviceId = await getDeviceId();

  // Basic validation
  if (input.isEmpty) {
    return SnackBarsList().errorSnackBar(
        context, "Please Enter Email / Phone Number");
  }

  if (pass.isEmpty) {
    return SnackBarsList().errorSnackBar(context, "Please Enter Password");
  }

  if (deviceId == null) {
    return SnackBarsList().errorSnackBar(context, "Device Id is Missing");
  }

  bool isPhone = RegExp(r'^[0-9]+$').hasMatch(input) && input.length == 10;
  bool isEmail = emailRegex.hasMatch(input);

  // Final input validation
  if (!isPhone && !isEmail) {
    return SnackBarsList().errorSnackBar(
        context, "Enter a valid Email or 10-digit Phone Number");
  }

  try {
    print("Logging in with: $input");
    print("Password: $pass");
    print("Device ID: $deviceId");

    LoginViewModel loginViewModel = LoginViewModel();
    await loginViewModel.fetchLoginData(input, pass, deviceId);

    Map<String, dynamic> data = loginViewModel.loginData;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    prefs.setString('userData', json.encode(data));

    userId = data['user_id'];
    userName = data['name'];
    userEmail = data['email'];
    userMobileNumber = data['mobile_number'];

   Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (_) => HomeScreen(),
  ),
);


    SnackBarsList().successSnackBar(context, "Login Successful");

  } catch (e) {
    SnackBarsList().errorSnackBar(
        context, "Login Failed.\nPlease Enter Proper Details");
  }
}


}


getDeviceId()async{
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if(Platform.isAndroid){
    final androidInfo = await deviceInfo.androidInfo;
    print(androidInfo.id);
    return androidInfo.id;
  }else if (Platform.isIOS){
    final Iosinfo = await deviceInfo.iosInfo;
    return Iosinfo.identifierForVendor;
  }
  return null;
}

class SignupCard extends StatefulWidget {
  const SignupCard({super.key});

  @override
  State<SignupCard> createState() => _SignupCardState();
}

class _SignupCardState extends State<SignupCard> {
  TextEditingController fullname = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController phoneNumber = TextEditingController();

  TextEditingController password = TextEditingController();
  late String courseid, courseamount,userid;

  late List<LiveCoursesModel> courseList; // = ['course 01', 'course 02', 'course 03', 'course 04', 'course 05'];

  LiveCoursesModel? selectedCourse; // = "";
  bool loading = false;
  Razorpay _razorpay = Razorpay();
  Map<String, dynamic> userData = {};


  @override
  void initState() {
    getCourseList();
    getUserData();
      getDeviceId();
    Razorpay _razorpay = Razorpay();
    super.initState();

     // _razorpay.on(Razorpay.EVENT_PAYMENT_CANCELLED, _handlePaymentCancelled);
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedMap = prefs.getString('userData').toString();
    userData = json.decode(encodedMap);
    // userId = userData['user_id'];
    // userName = userData['name'];
    // userEmail = userData['email'];
    // userMobileNumber = userData['mobile_number'];
  }

  @override
  void dispose() {
    super.dispose();
  
    _razorpay.clear(); // Clear Razorpay instance to avoid memory leaks
  }



  Future<void> getCourseList() async {
    try {
      setState(() {
        loading = true;
      });
      LiveCoursesViewModel liveCoursesViewModel = LiveCoursesViewModel();
      await liveCoursesViewModel.fetchLiveCourse();
      setState(() {
        courseList = liveCoursesViewModel.liveCourses;
      });
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: loading
            ? const CircularProgressIndicator()
            : Stack(
                children: [
                  Card(
                    margin: const EdgeInsets.all(20.0),
                    child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ClipOval(
                                child: SizedBox.fromSize(
                                  size: const Size.fromRadius(58), // Image radius
                                  child: Image.asset('assets/logo.jpeg', fit: BoxFit.cover),
                                ),
                              ),
                              TextField(
                                controller: fullname,
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(labelText: 'Full Name'),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(labelText: 'Email'),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: phoneNumber,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(labelText: 'Phone Number'),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: password,
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(labelText: 'Password'),
                                obscureText: true,
                              ),
                              const SizedBox(height: 20),
                              PopupMenuButton(
                                initialValue: 2,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(border: Border.all()),
                                  width: MediaQuery.of(context).size.width,
                                  child: Text(
                                    selectedCourse == null ? 'Select Course' : selectedCourse!.courseName!,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                  ),
                                ),
                                itemBuilder: (context) {
                                  return List.generate(courseList.length, (index) {
                                    return PopupMenuItem(
                                      value: index,
                                      onTap: () {
                                        setState(() {
                                          selectedCourse = courseList[index];
                                          courseid = courseList[index].courseId!;
                                          courseamount = courseList[index].coursePrice!;
                                        });
                                      },
                                      child: Text('${courseList[index].courseName}'),
                                    );
                                  });
                                },
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                style: ButtonStyle(backgroundColor: WidgetStateProperty.all(primaryColor)),
                                onPressed: () {
                                  signUpValidation();
                                },
                                child: Text(
                                  'Signup',
                                  style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                  Positioned(
                      right: 30,
                      child: InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => const DemoCourses(),
                          ),
                        ),
                        child: const Text(
                          "-> Demo Courses",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      )),
                ],
              ));
  }

  // signUpValidation() async {
  //   var pattern =
  //       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  //   RegExp emailCheck = RegExp(pattern);
  //   if (fullname.text.isEmpty) {
  //     SnackBarsList().errorSnackBar(context, "Please Enter Full Name");
  //   } else if (email.text.isEmpty) {
  //     SnackBarsList().errorSnackBar(context, "Please Enter Email");
  //   } else if (phoneNumber.text.isEmpty) {
  //     SnackBarsList().errorSnackBar(context, "Please Enter Phone Number");
  //   } else if (password.text.isEmpty) {
  //     SnackBarsList().errorSnackBar(context, "Please Enter Password");
  //   } else if (selectedCourse == "") {
  //     SnackBarsList().errorSnackBar(context, "Please Select Course");
  //   } else {
  //     try {
  //       RegisterViewModel registerViewModel = RegisterViewModel();
  //       await registerViewModel.fetchRegisterData(fullname.text, email.text, phoneNumber.text, password.text, courseid);
  //       Map<String, dynamic> data = registerViewModel.registerData;
  //       print('vvvvvvvvvvvvvvvvvvvvvvvvvvvvv');

  //       print(data);
  //       Map<String, dynamic> userDetails = data['Userdetails']; // Extract user details

  //       String username = userDetails['name']; // Extract the 'name' from the response
  //       String userId = userDetails['user_id']; // Extract the 'user_id'
  //       String emaill = userDetails['email']; // Extract the 'email'
  //       String mobile = userDetails['mobile_number'];
  //       // Extract the 'mobile_number'
  //       userid = userId;
  //       // await createPaymentRequest(courseid, courseamount, emaill, context);
  //       double courseAmount = double.parse(selectedCourse!.coursePrice!); //courseamount.toString()); // Example amount, replace with actual course amount

  //       //courseamount.toString()); // Example amount, replace with actual course amount
  //       createPaymentRequest(username, userId, courseAmount);

  //       // You can now use this data for navigation or display it
  //       SnackBarsList().successSnackBar(context, "Welcome, $username! Your ID: $courseid");

   
  //     } catch (e) {
  //       SnackBarsList().errorSnackBar(context, "Registration Failed...\nPlease Enter Proper Details:$courseid");
  //     }
  
  //   }
  // }

  signUpValidation() async {
  var pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp emailCheck = RegExp(pattern);

  // ---------- VALIDATIONS ----------
  if (fullname.text.isEmpty) {
    SnackBarsList().errorSnackBar(context, "Please Enter Full Name");
    return;
  } 
  if (email.text.isEmpty) {
    SnackBarsList().errorSnackBar(context, "Please Enter Email");
    return;
  } 
  if (!emailCheck.hasMatch(email.text)) {
    SnackBarsList().errorSnackBar(context, "Please Enter Valid Email");
    return;
  }
  if (phoneNumber.text.isEmpty) {
    SnackBarsList().errorSnackBar(context, "Please Enter Phone Number");
    return;
  } 
  if (password.text.isEmpty) {
    SnackBarsList().errorSnackBar(context, "Please Enter Password");
    return;
  }
  if (selectedCourse == null || selectedCourse == "") {
    SnackBarsList().errorSnackBar(context, "Please Select Course");
    return;
  }

  // ---------- API CALL ----------
  try {
    RegisterViewModel registerViewModel = RegisterViewModel();
    await registerViewModel.fetchRegisterData(
      fullname.text,
      email.text,
      phoneNumber.text,
      password.text,
      courseid,
    );

    Map<String, dynamic> data = registerViewModel.registerData;

    print("========= API RESPONSE =========");
    print(data);
print("FULL REGISTER API RESPONSE:");
print(data);

if (!data.containsKey("Userdetails") || data["Userdetails"] == null) {
SnackBarsList().errorSnackBar(
  context,
  "Registration Failed: ${data["message"] ?? "Unknown error"}"
);

  return;
}


    Map<String, dynamic> userDetails = data["Userdetails"];

    print("========= USER DETAILS =========");
    print(userDetails);

    // Safe extraction
    String username = userDetails["name"] ?? "No Name";
    String userId = userDetails["user_id"] ?? "0";
    String userEmail = userDetails["email"] ?? "";
    String userMobile = userDetails["mobile_number"] ?? "";

    userid = userId;

    // Course amount parsing safely
    double courseAmount = double.tryParse(selectedCourse!.coursePrice ?? "0") ?? 0;

    // ---------- PAYMENT CALL ----------
    createPaymentRequest(username, userId, courseAmount);

    SnackBarsList()
        .successSnackBar(context, "Welcome, $username! Your ID: $userId");

  } catch (e, stacktrace) {
    print("========= REGISTRATION ERROR =========");
    print("Error: $e");
    print("Stacktrace: $stacktrace");

    SnackBarsList()
        .errorSnackBar(context, "Registration Failed: $e");
  }
}



// 

  createPaymentRequest(String name, String userId, double amount) {
    var options = {
      'key': 'rzp_live_pgxwzTl1qssb4I', // Use your Razorpay Test or Live key
      'amount': (amount * 100).toString(), // Amount in paise
      'name': name,
      'description': 'Course Payment',
      // 'order_id': userId,  // You can use the user ID as the order ID
      // Optional: Timeout in seconds (5 minutes)
      'prefill': {
        'email': userEmail??"", // User's email
        'contact': userMobileNumber??"", // User's mobile number
      },
      'theme': {
        'color': '#ff5e5e',
      }
    };

    try {
      _razorpay.open(options);
      _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
      _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    } catch (e) {
      print(e.toString());
      //SnackBarsList().errorSnackBar(context, "Failed to initiate payment.");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async{
    // Repositories().confirmPayment(
    //     // userId: userData['user_id'],
    //     userId: int.tryParse(userData['user_id'])!,
    //     courseId: int.tryParse(selectedCourse!.courseId!.toString())!,
    //     transactionId: response.orderId!,
    //     transactionPaymentId: response.paymentId!,
    //     amount: selectedCourse!.coursePrice!);
     paymentapi(response);
    print('Payment successful');
    // Fluttertoast.showToast(
    //     msg: "This is Center Short Toast",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.CENTER,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0
    // );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginPage(),
      ),
    );
    // Handle success
    SnackBarsList().successSnackBar(context, 'Payment Successful: ${response.paymentId}');
  }

  void _handlePaymentError(PaymentFailureResponse response) async{
    // Handle failure
    SnackBarsList().errorSnackBar(context, 'Payment Failed: ${response.message}');
  }

  Future<void> paymentapi(PaymentSuccessResponse response) async {
     try{
       PaymentViewModel paymentViewModel = PaymentViewModel();
       await paymentViewModel.confirmPaymentData(int.parse(userid),int.parse(courseid),courseamount,response.paymentId,response.paymentId).then((onvalue){ } );
       Map<String, dynamic> data = paymentViewModel.paymentData;

       // Fluttertoast.showToast(
       //     msg: "payment over ",
       //     toastLength: Toast.LENGTH_SHORT,
       //     gravity: ToastGravity.CENTER,
       //     timeInSecForIosWeb: 1,
       //     backgroundColor: Colors.red,
       //     textColor: Colors.white,
       //     fontSize: 16.0
       // );
     }
     catch(e){
       SnackBarsList().errorSnackBar("$e", 'Payment Cancelled');
     }
  }

}
// void _handlePaymentCancelled(PaymentCancellationResponse response) {
//   // Handle cancellation
//   SnackBarsList().errorSnackBar(, 'Payment Cancelled');
// }
