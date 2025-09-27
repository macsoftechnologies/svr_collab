import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svr/models/live_courses_model.dart';
import 'package:svr/repositories/repositories.dart';
import 'package:svr/utils/colors.dart';
import 'package:svr/view_models/home_icons_view_models/payment_view_model.dart';
import 'package:svr/view_models/live_courses_view_model.dart';
import 'package:svr/view_models/login_view_model.dart';
import 'package:svr/views/home_icons_views/my_courses.dart';
import 'package:svr/views/home_icons_views/offline_download_page.dart';
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
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  late String courseamount,userid;
  late LiveCoursesModel selectedCourseToPurchase;
  // late Razorpay _razorpay;
  Map<String, dynamic> userData = {};
  Razorpay _razorpay = Razorpay();
  @override
  void initState() {
    // _razorpay = Razorpay();
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  @override
  void dispose() {
    //_razorpay.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor,
        appBar: CommonWidgets(

        ).appBar("SVR ACADEMY",context),



        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                  color: Colors.orange,
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
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: secondaryColor, borderRadius: const BorderRadius.all(Radius.circular(20))),
                          child: const Text(
                            "APPSC GROUPS",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Our online Courses ",
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            decorationThickness: 2,
                            decorationStyle: TextDecorationStyle.dotted,
                            color: blackColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        textAlign: TextAlign.left,
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
                            height: 170,
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

                                    createPaymentRequest(userName, userId, amount);

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
                                      color: primaryColor,
                                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox.fromSize(
                                          size: const Size.fromRadius(50),
                                          child: Image.network('${liveCourses[index].courseImage}', fit: BoxFit.cover),
                                        ),
                                        Text(
                                          "${liveCourses[index].courseName}",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: whiteColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
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
                height: MediaQuery.of(context).size.height / 2.8,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(12),
                child: GridView.builder(
                  itemCount: homeIcons.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 6.0, mainAxisSpacing: 40),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        if (homeIcons[index]["name"] == "My Courses") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => const MyCourses(),
                            ),
                          );
                        } else if (homeIcons[index]["name"] == "Online Classes") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>  UserCoursesView(type: "Online Classes"),
                            ),
                          );
                        } else if (homeIcons[index]["name"] == "Study Materials") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>  UserCoursesView(type: "Materials"),
                            ),
                          );
                        }
                        else if (homeIcons[index]["name"] == "Tests") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => const TestQuestions(),
                            ),
                          );
                        } else if (homeIcons[index]["name"] == "Profile") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => const Profile(),
                            ),
                          );
                        } else if (homeIcons[index]["name"] == "socialize") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => const RewardsPage(),
                            ),
                          );
                        }
                        // else if (homeIcons[index]["name"] == "Offline") {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (BuildContext context) => const OfflineDownloadPage(),
                        //     ),
                       //    );
                       // }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: const BorderRadius.all(Radius.circular(20))
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible( // or Expanded
                              child: Image.asset(
                                homeIcons[index]["img"],
                                height: 80,
                                width: 80,
                                fit: BoxFit.contain, // Add this to maintain aspect ratio
                              ),
                            ),
                            const SizedBox(height: 5), // Add some spacing
                            Text(
                              "${homeIcons[index]["name"]}",
                              style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center, // Optional: center align text
                              maxLines: 2, // Optional: limit text to 2 lines
                              overflow: TextOverflow.ellipsis, // Optional: add ellipsis if text overflows
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
        ));
  }


  createPaymentRequest(String name, String userId, double amount) {
    var options = {
      'key': 'rzp_test_0gAUBx3H6twMaj', // Use your Razorpay Test or Live key
      'amount': (amount).toString(), // Amount in paise
      'name': name,
      'description': 'Course Payment',
      // 'order_id': userId,  // You can use the user ID as the order ID
      // Optional: Timeout in seconds (5 minutes)
      'prefill': {
        'email': " jjajhaj@gmail.com", // User's email
        'contact': "8247447102", // User's mobile number
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

