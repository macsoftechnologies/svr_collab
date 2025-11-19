import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart'; // for API calls
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:svr/models/home_icons_models/new_profile_model.dart';
import 'package:svr/models/home_icons_models/profile_model.dart';
import 'package:svr/models/home_icons_models/user_payments_model.dart';
import 'package:svr/utils/colors.dart';
import 'package:svr/utils/common_widgets.dart';
import 'package:svr/utils/global_keys.dart';
import 'package:svr/view_models/home_icons_view_models/profile_view_model.dart';
import 'package:svr/views/login_page.dart';
import 'package:svr/services/web_service.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List<PaymentDetails> paymentDetailsList = [];
  bool isLoadingPayment = true;
  Result? profileResult;

  @override
  void initState() {
    super.initState();
    _fetchUserProfileDetails();
    _fetchPaymentDetails();
  }

  Future<void> _fetchUserProfileDetails() async {
    try {
      Response response = await WebService().getUserProfileDetails(userId);
      if (response.statusCode == 200) {
        final jsonresponse = json.decode(response.body);
        if (jsonresponse['result'] != null) {
          setState(() {
            profileResult = Result.fromJson(jsonresponse['result']);
          });
        }
      } else {
        throw Exception('Failed to load user profile details!');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  Future<void> _fetchPaymentDetails() async {
    try {
      Response response = await WebService().getUserPaymentDetails(userId);
      if (response.statusCode == 200) {
        final jsonResp = json.decode(response.body);
        final List<dynamic> detailsJson = jsonResp['paymentDetails'];
        if (detailsJson.isNotEmpty) {
          setState(() {
            paymentDetailsList =
                detailsJson.map((e) => PaymentDetails.fromJson(e)).toList();
          });
        }
      } else {
        throw Exception("Failed to load payment details");
      }
    } catch (e) {
      print("Error fetching payment details: $e");
    } finally {
      setState(() {
        isLoadingPayment = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: CommonWidgets().appBar("Profile", context),
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          if (!viewModel.fetchData && viewModel.getProfileInfo == null) {
            Provider.of<ProfileViewModel>(context, listen: false)
                .fetchProfileData(context);
          }

          if (viewModel.fetchData) {
            return const Center(child: CircularProgressIndicator());
          }

          final profileInfo = viewModel.getProfileInfo;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(58),
                    child: Image.asset('assets/logo.jpeg', fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Profile Info",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10),
                if (profileResult != null)
                  _buildInfoCard(profileResult!)
                else
                  const Text("No profile info found"),
                const SizedBox(height: 10),
                if (profileInfo != null)
                  // _buildAdditionalInfoCard(profileInfo),
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Payment Info",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10),
                if (isLoadingPayment)
                  const CircularProgressIndicator()
                else if (paymentDetailsList.isNotEmpty)
                  Column(
                    children: paymentDetailsList
                        .map((e) => buildPaymentDetailsCard(e))
                        .toList(),
                  )
                else
                  const Text("No payment details found."),
                const SizedBox(height: 20),
                _buildActionsCard(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: logout,
                  child: const Text("Logout"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildPaymentDetailsCard(PaymentDetails paymentInfo) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Transaction ID", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Course Name", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(":  ${paymentInfo.transactionId ?? ""}", overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Text(":  ${paymentInfo.courseName ?? ""}", overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(Result profileInfo) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Name", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Mobile Number", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Email", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Password",style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold) ),
                  SizedBox(height: 10),
                  Text("Joined Date", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(":  ${profileInfo.name ?? ""}", overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Text(":  ${profileInfo.mobileNumber ?? ""}", overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Text(":  ${profileInfo.email ?? ""}", overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Text(":  ${profileInfo.password ?? ""}", overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 10),
                  Text(":  ${profileInfo.joinedDate ?? ""}", overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildAdditionalInfoCard(ProfileModel profileInfo) {
  //   return Card(
  //     child: Padding(
  //       padding: const EdgeInsets.all(10),
  //       child: Row(
  //         children: [
  //           Expanded(
  //             flex: 4,
  //             child: const Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text("DOB", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
  //                 SizedBox(height: 10),
  //                 Text("Hall Ticket No", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
  //                 SizedBox(height: 10),
  //                 Text("Gender", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
  //                 SizedBox(height: 10),
  //                 Text("Course ID", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
  //                 SizedBox(height: 10),
  //                 Text("Remarks", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
  //               ],
  //             ),
  //           ),
  //           Expanded(
  //             flex: 6,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(":  ${profileInfo.dob ?? ""}", overflow: TextOverflow.ellipsis),
  //                 const SizedBox(height: 10),
  //                 Text(":  ${profileInfo.hallticketno ?? ""}", overflow: TextOverflow.ellipsis),
  //                 const SizedBox(height: 10),
  //                 Text(":  ${profileInfo.gender ?? ""}", overflow: TextOverflow.ellipsis),
  //                 const SizedBox(height: 10),
  //                 Text(":  ${profileInfo.courseId ?? ""}", overflow: TextOverflow.ellipsis),
  //                 const SizedBox(height: 10),
  //                 Text(":  ${profileInfo.remark ?? ""}", overflow: TextOverflow.ellipsis),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildActionsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("View Hall Ticket", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("Update Profile Info", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  onPressed: () {
                    print('user_id is $userId');
                  },
                  icon: const Icon(Icons.remove_red_eye_rounded),
                ),
                const SizedBox(height: 10),
                IconButton(
                  onPressed: () {
                    // Handle profile update here
                  },
                  icon: const Icon(Icons.edit_note_sharp),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
