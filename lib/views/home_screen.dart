import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;


import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svr/models/live_courses_model.dart';
import 'package:svr/utils/colors.dart';
import 'package:svr/view_models/home_icons_view_models/payment_view_model.dart';
import 'package:svr/view_models/live_courses_view_model.dart';
import 'package:svr/views/home_icons_views/my_courses.dart';
import 'package:svr/views/home_icons_views/rewards_page.dart';
import 'package:svr/views/home_icons_views/test_questions.dart';
import 'package:svr/views/login_page.dart';
import '../utils/common_widgets.dart';
import '../utils/global_keys.dart';
import '../utils/snackbars_list.dart';
import 'home_icons_views/home_views/user_courses.dart';
import 'home_icons_views/profile_page.dart';

class HomeScreen extends StatefulWidget {


  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  late String courseamount,userid;
  late LiveCoursesModel selectedCourseToPurchase;
  String? suspenseDeviceId;
  Timer? _deviceCheckTimer;

  // late Razorpay _razorpay;
  Map<String, dynamic> userData = {};
  Razorpay _razorpay = Razorpay();
  @override
  void initState() {
    
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();

       checkDeviceChange();

         _deviceCheckTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
    await checkDeviceChange();
  });


  }

Future<void> _handleRefresh() async {
   checkDeviceChange();
}

Future<void> checkDeviceChange() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? encodedMap = prefs.getString('userData');

  if (encodedMap == null) return;

  userData = json.decode(encodedMap);
  userId = userData['user_id'];
  String savedDeviceId = userData['device_id'];

  // Fetch current device ID from API
  String? currentDeviceId = await getDeviceIdFromApi();

  if (currentDeviceId != null && savedDeviceId != currentDeviceId) {
    prefs.clear();

    SnackBarsList().errorSnackBar(
      context,
      "You have been logged in on another device.",
    );

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
  }
}

Future<String?> getDeviceIdFromApi() async {
  try {
    final response = await http.post(
      Uri.parse('https://svracademy.in/services/users/getuserdetails'),
      headers: {
        'Content-Type': 'application/json',
        'Auth-Key': 'svrapi'
      },
      body: jsonEncode({'user_id': userId}), 
    );

    print('Device API response: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> result = json.decode(response.body);

      if (result['result'] != null && result['result'] is Map<String, dynamic>) {
        return result['result']['device_id']?.toString(); // safe access
      } else {
        print("API response 'result' is null or invalid: $result");
        return null;
      }
    } else {
      print('API Error: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error fetching device ID: $e');
    return null;
  }
}


  



 @override
void dispose() {
  _razorpay.clear();
  _deviceCheckTimer?.cancel(); 
  super.dispose();
}
  @override
  Widget build(BuildContext context) {

    final filteredHomeIcons = homeIcons.where((icon) {
    return icon["name"] != "Online Classes" && icon["name"] != "Study Materials";
  }).toList();
    return Scaffold(
        backgroundColor: secondaryColor,
        
        appBar: CommonWidgets(
        
        ).appBar(
          
          "SVR ACADEMY",context),
        



        body:RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(), // Needed for pull-to-refresh
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                  color: Colors.green,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/svrhd.png",
                          width: 150,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                         
                          width: MediaQuery.of(context).size.width * 0.7,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: secondaryColor, borderRadius: const BorderRadius.all(Radius.circular(20))),
                          child: const Text(
                            "APPSC GROUPS",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Online Coaching Center",
                          style: TextStyle(color:Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )),
              Card(
              
                child: Container(
                  padding: const EdgeInsets.all(3),
                  height: 200,
                  color: Colors.yellow,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Our Online Courses ",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 13, ),
                        textAlign: TextAlign.center,
                      ),
                      Consumer<LiveCoursesViewModel>(builder: (context, viewModel, child) {
                        if (!viewModel.fetchingData && viewModel.liveCourses.isEmpty) {
                          Provider.of<LiveCoursesViewModel>(context, listen: false).fetchLiveCourse();
                        }
                        if (viewModel.fetchingData) {
                          // While data is being fetched
                          return const LinearProgressIndicator();
                        } else {
                          // If data is successfully fetched
                          List<LiveCoursesModel> liveCourses = viewModel.liveCourses;
                          return SizedBox(
                            height: 150,
                            child: ListView.builder(
                              itemCount: liveCourses.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                          
                                  onTap: () async {
                                    //Code to check the course purchased or not
                                    //check the amount
                                    selectedCourseToPurchase = liveCourses[index];

                                    double amount = selectedCourseToPurchase.coursePrice == 'course not available'
                                        ? 0.0
                                        : double.tryParse(liveCourses[index].coursePrice.toString())! * 100;
                                    courseamount = selectedCourseToPurchase.coursePrice!;
                                    if (amount == 0.0) {
                                      SnackBarsList().errorSnackBar(context, "Payment can't be processed for zero rupee");
                                      return;
                                    }


                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    String encodedMap = prefs.getString('userData').toString();
                                    userData = json.decode(encodedMap);
                                    userId = userData['user_id'];
                                    userName = userData['name'];
                                    userEmail = userData['email'];
                                    userMobileNumber = userData['mobile_number'];
                                    userCourseId = selectedCourseToPurchase.courseId.toString();
                                    courseamount = selectedCourseToPurchase.coursePrice!;

                                    createPaymentRequest(userName, userId, amount, userEmail, userMobileNumber );

                                      // Extract the 'mobile_number'
                                    // Map<String, dynamic> options = {
                                    //   'key': 'rzp_test_0gAUBx3H6twMaj',
                                    //   'amount': amount,
                                    //   'name': userName,
                                    //   'description': 'Course Payment',
                                    //   // 'order_id': userId,  // You can use the user ID as the order ID
                                    //   // Optional: Timeout in seconds (5 minutes)
                                    //   'prefill': {
                                    //     'email': " jjajhaj@gmail.com", // User's email
                                    //     'contact': "8247447102", // User's mobile number
                                    //   },
                                    //   'theme': {
                                    //     'color': '#ff5e5e',
                                    //   }
                                    // };

                                    //_razorpay.open(options);
                                  },
                                  child: Container(
                                  
                                    width: 150,
                                    height: 150,
                                    margin: const EdgeInsets.all(10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color:  Colors.indigo,
                                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      
                                      children: [
                                        SizedBox.fromSize(
                                          size: const Size.fromRadius(50),
                                          child: Image.network('${liveCourses[index].courseImage}', fit: BoxFit.contain, ),
                                          
                                        ),
                                        Text(
                                          "${liveCourses[index].courseName}",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 7,
                                            
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      }),
                    ],
                  ),
                ),
              ),


              Container(
               color: Colors.white60,
                height: MediaQuery.of(context).size.height / 2.8,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(12),
                child:
                
                 GridView.builder(
                
  itemCount: filteredHomeIcons.length,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    crossAxisSpacing: 6.0,
    mainAxisSpacing: 40,
  ),
  itemBuilder: (BuildContext context, int index) {
    return InkWell(
      onTap: () {
        final iconName = filteredHomeIcons[index]["name"];
        if (iconName == "My Courses") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyCourses()),
          );
        // } else if (iconName == "Tests") {
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(builder: (context) => const TestQuestions()),
        //   );
        } else if (iconName == "Profile") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Profile()),
          );
        } else if (iconName == "socialize") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RewardsPage()),
          );
        }
      },
      child: Container(
      
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.lightBlue[100],
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              filteredHomeIcons[index]["img"],
              height: 73,
              width: 80,
            ),
            Text(
              "${filteredHomeIcons[index]["name"]}",
              style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  },
),


              ),



              
            ],
          ),
        )
          ],
        ),
      ),
        
        
        
        
        
        ));
  }


   createPaymentRequest(String name, String userId, double amount, String email, String userMobileNumber ) {
    var options = {
      'key': 'rzp_live_pgxwzTl1qssb4I', // Use your Razorpay Test or Live key
      'amount': (amount).toString(), // Amount in paise
      'name': name,
      'description': 'Course Payment',
      // 'order_id': userId,  // You can use the user ID as the order ID
      // Optional: Timeout in seconds (5 minutes)
      'prefill': {
        'email': email, // User's email
        'contact': userMobileNumber, // User's mobile number
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
        builder: (BuildContext context) => const MyCourses(),
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
      await paymentViewModel.confirmPaymentData(int.parse(userId),int.parse(userCourseId),courseamount,response.paymentId,response.paymentId).then((onvalue){ } );
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
  // Future<void>logout() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   // Clear user data and set login status to false
  //   await prefs.remove('userData');
  //   // await prefs.setBool('isLoggedIn', false);
  //
  //   // Navigate to login screen or any other screen
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (BuildContext context) => const LoginPage(),
  //     ),
  //   );
  // }

}




// void _handleExternalWallet(ExternalWalletResponse response) {
  //   // Do something when an external wallet is selected
  // }

