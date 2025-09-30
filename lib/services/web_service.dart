import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:svr/utils/global_keys.dart';

import '../utils/strings_info.dart';

class WebService {
  static final WebService _singleton = WebService._internal();

  factory WebService() {
    return _singleton;
  }

  WebService._internal();

  // demo Courses
  Future<Response> getDemoCourseData() async {
    Response response = await http.get(
        Uri.parse(main_url + demo_course_api), headers: headers);
    return response;
  }



 Future<Response> getUserPaymentDetails(String userId) async {
  final data = jsonEncode({
    "user_id": userId,
  });

  var response = await post(
    Uri.parse(main_url + PaymentDetails_api),
    headers: headers,
    body: data,
  );

  return response;
}



  // login service
  getLoginData(emailMobile, password, deviceId) async {
    final data = jsonEncode(
        {"emailmobile": "$emailMobile", "password": "$password", "device_id" : deviceId});
    var response = await post(
      Uri.parse(main_url + login_api),
      headers: headers,
      body: data,
    );
    return response;
  }

  getRegisterData(name, email, Mobile, password, courseid) async {
    final data = jsonEncode({
      "name": "$name",
      "email": "$email",
      "mobile_number": "$Mobile",
      "password": "$password",
      "course_id": "$courseid"
    });
    var response = await post(
      Uri.parse(main_url + registerapi),
      headers: headers,
      body: data,
    );
    return response;
  }

  getconfirmPayment(userid, courseid, amount, transcationid, taxid) async {
    final data = jsonEncode({
      "user_id": "$userid",
      "course_id": "$courseid",
      "amount": "$amount",
      "transaction_id": "$transcationid",
      "txn_payment_id": "$taxid"
    });
    var response = await post(
      Uri.parse(main_url + confirm_payment_api),
      headers: headers,
      body: data,
    );
    return response;
  }
  Future<Response>myCourses(userid) async {
    final data = jsonEncode({
      "user_id": "$userid",

    });
    var response = await post(
      Uri.parse(main_url + mycourses),
      headers: headers,
      body: data,
    );
    return response;
   }
  // get courses
  Future<Response> getLiveCourseData() async {
    Response response = await http.get(
        Uri.parse(main_url + live_courses_api), headers: headers);
    return response;
  }

  // get subjects
  Future<Response> getSubjectsData(courseId) async {
    final data = jsonEncode({"course_id": courseId});
    var response = await post(
      Uri.parse(main_url + subjects_api),
      headers: headers,
      body: data,
    );
    return response;
  }

  // get Materials
  Future<Response> getMaterialsData(subjectId) async {
    final data = jsonEncode({"subject_id": int.parse(subjectId)});
    var response = await post(
      Uri.parse(main_url + materials_api),
      headers: headers,
      body: data,
    );
    return response;
  }

  // get Materials
  Future<Response> getOnlineClassesData(subjectId) async {
    final data = jsonEncode({"subject_id": int.parse(subjectId)});
    print("iam in web_services");
    print("subject_id ${subjectId}");
    var response = await post(
      Uri.parse(main_url + videos_api),
      headers: headers,
      body: data,
    );
    print("iam in web_servicesjjj ${response}");
    return response;
  }

  Future<Response> getOfflineClassesData(subjectId) async {
    final data = jsonEncode({"subject_id": int.parse(subjectId)});
    var response = await post(
      Uri.parse(main_url + offlinecourses),
      headers: headers,
      body: data,
    );
    return response;
  }

  // get Test Questions
  Future<Response> getTestQuestionsData() async {
    final data = jsonEncode({"user_id": userId});
    var response = await post(
      Uri.parse(main_url + test_questions_api),
      headers: headers,
      body: data,
    );
    return response;
  }

  // Submit Test
  Future<Response> submitTestData(answers) async {
    final data = jsonEncode(answers);
    var response = await post(
      Uri.parse(main_url + submit_test_api),
      headers: headers,
      body: data,
    );
    return response;
    //print(response);
  }

  // get Test Questions
  Future<Response> getProfileData() async {
    final data = jsonEncode({"user_id": userId});
    var response = await post(
      Uri.parse(main_url + profile_api),
      headers: headers,
      body: data,
    );
    return response;
  }

  Future<Response> logoutFromApp() async {
    final data = jsonEncode({"user_id": userId});
    var response = await post(
      Uri.parse(main_url + logout_api),
      headers: headers,
      body: data,
    );
    return response;
  }
}
  //Confirm Course Payment
//   Future<Response> confirmCoursePayment(
//       {required int userId,
//       required int courseId,
//       required String amount,
//       required String transactionId,
//       required String transactionPaymentId}) async {
//     final data = jsonEncode(
//         {"user_id": userId, "course_id": courseId, "amount": amount, "transaction_id": transactionId, "txn_payment_id": transactionPaymentId});
//     var response = await post(
//       Uri.parse(main_url + confirm_payment_api),
//       headers: headers,
//       body: data,
//     );
//     return response;
//   }
// }
