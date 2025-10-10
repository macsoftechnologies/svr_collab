import 'dart:convert';

import 'package:http/http.dart';
import 'package:svr/models/home_icons_models/materials_model.dart';
import 'package:svr/models/home_icons_models/offline_model.dart';
import 'package:svr/models/home_icons_models/online_classes_model.dart';
import 'package:svr/models/home_icons_models/profile_model.dart';
import 'package:svr/models/home_icons_models/resend_otp_model.dart';
import 'package:svr/models/home_icons_models/test_questions_model.dart';
import 'package:svr/models/home_icons_models/user_payments_model.dart';
import 'package:svr/models/live_courses_model.dart';
import 'package:svr/utils/global_keys.dart';

import '../models/demo_courses_model.dart';
import '../models/home_icons_models/courses_model.dart';
import '../models/subjects_model.dart';
import '../services/web_service.dart';

class Repositories {
  static final Repositories _singleton = Repositories._internal();

  factory Repositories() {
    return _singleton;
  }

  Repositories._internal();


 Future<List<resendOTPmodel>> resendOTPfn()async {
  Response response = await WebService().SendForgotPasswordEmail(userEmail);
  if(response.statusCode == 200){
    return List<resendOTPmodel>.from(
      json.decode(response.body).map((x)=>(
          resendOTPmodel.fromJson((x))
      ))
    );

  }else{
    throw Exception('Failed to Resend OTP');
  }

 }


  Future<List<DemoCoursesModel>> getDemoCourses() async {
    Response response = await WebService().getDemoCourseData();
    if (response.statusCode == 200) {
      return List<DemoCoursesModel>.from(
          json.decode(response.body)['democourse'].map((x) =>
              DemoCoursesModel.fromJson(x)));
    } else {
      throw Exception('Failed to load Demo Courses');
    }
  }

  Future getLogin(emailMobile, password, deviceId) async {
    Response response = await WebService().getLoginData(emailMobile, password, deviceId);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data['userdata'];
    } else {
      throw Exception('Failed to Login');
    }
  }


  Future<List<LiveCoursesModel>> getLiveCourses() async {
    Response response = await WebService().getLiveCourseData();
    if (response.statusCode == 200) {
      return List<LiveCoursesModel>.from(
          json.decode(response.body)['course'].map((x) =>
              LiveCoursesModel.fromJson(x)));
    } else {
      throw Exception('Failed to load Live Courses');
    }
  }

  Future<List<CoursesModel>> getMycourse(userid) async {
    Response response = await WebService().myCourses(userid);

    if (response.statusCode == 200) {
      return List<CoursesModel>.from(
          json.decode(response.body)['studymaterial'].map((x) =>
              CoursesModel.fromJson(x)));
    } else {
      throw Exception('Failed to load courses');
    }

  }

  Future<List<SubjectsModel>> getSubjects(courseId) async {
    Response response = await WebService().getSubjectsData(courseId);
    if (response.statusCode == 200) {
      return List<SubjectsModel>.from(
          json.decode(response.body)['subjects'].map((x) =>
              SubjectsModel.fromJson(x)));
    } else {
      throw Exception('Failed to load Subjects');
    }
  }

  Future<List<MaterialsModel>> getMaterials(subjectId) async {
    Response response = await WebService().getMaterialsData(subjectId);
    if (response.statusCode == 200) {
      return List<MaterialsModel>.from(
          json.decode(response.body)['studymaterials'].map((x) =>
              MaterialsModel.fromJson(x)));
    } else {
      throw Exception('Failed to load Subjects');
    }
  }

  Future<List<OnlineClassesModel>> getOnlineClasses(subjectId) async {
    Response response = await WebService().getOnlineClassesData(subjectId);
    if (response.statusCode == 200) {
      return List<OnlineClassesModel>.from(
          json.decode(response.body)['videos'].map((x) =>
              OnlineClassesModel.fromJson(x)));
    } else {
      throw Exception('Failed to load Subjects');
    }
  }

  Future<List<OfflineModel>> getOfflineClasses(subjectId) async {
    Response response = await WebService().getOfflineClassesData(subjectId);
    if (response.statusCode == 200) {
      return List<OfflineModel>.from(
          json.decode(response.body)['videos'].map((x) =>
              OfflineModel.fromJson(x)));
    } else {
      throw Exception('Failed to load Subjects');
    }
  }

  Future<List<TestQuestionsModel>> getTestQuestions() async {
    Response response = await WebService().getTestQuestionsData();
    if (response.statusCode == 200) {
      return List<TestQuestionsModel>.from(
          json.decode(response.body)['tests'].map((x) =>
              TestQuestionsModel.fromJson(x)));
    } else {
      throw Exception('Failed to load Subjects');
    }
  }

  Future<Map<String, dynamic>> getSubmitTest(answers) async {
    Response response = await WebService().submitTestData(answers);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return data;

      print("Parsed JSON data: $data");
    } else {
      throw Exception('Failed to load Subjects');
    }
  }

  Future<ProfileModel> getProfile() async {
    Response response = await WebService().getProfileData();
    if (response.statusCode == 200) {
      ProfileModel data = ProfileModel.fromJson(
          json.decode(response.body)['result']);
      print(data.userId);
      return ProfileModel.fromJson(json.decode(response.body)['result']);
    } else {
      throw Exception('Failed to load Subjects');
    }
  }

  Future<List<PaymentDetails>> getPaymentDetails(String userId) async {
  Response response = await WebService().getUserPaymentDetails(userId);

  if (response.statusCode == 200) {
    var decoded = json.decode(response.body);

    List<PaymentDetails> payments = (decoded['paymentDetails'] as List)
        .map((item) => PaymentDetails.fromJson(item))
        .toList();

    return payments;
  } else {
    throw Exception('Failed to load payment details');
  }
}


  Future getRegister(name, email, Mobile, password, courseid) async {
    Response response = await WebService().getRegisterData(
        name, email, Mobile, password, courseid);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to register');
    }
  }

  Future confirmPayment(userid, courseid, amount, transcationid, taxid) async {
    Response response = await WebService().getconfirmPayment(
        userid, courseid, amount, transcationid, taxid);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to pay');
    }
  }



}
