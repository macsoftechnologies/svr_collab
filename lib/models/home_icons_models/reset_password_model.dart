class resetPasswordModel {
  int? status;
  String? message;
  Userdetails? userdetails;

  resetPasswordModel({this.status, this.message, this.userdetails});

  resetPasswordModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userdetails = json['Userdetails'] != null
        ? new Userdetails.fromJson(json['Userdetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.userdetails != null) {
      data['Userdetails'] = this.userdetails!.toJson();
    }
    return data;
  }
}

class Userdetails {
  String? userId;
  String? name;
  String? email;
  String? mobileNumber;
  String? courseId;
  String? password;
  Null? confirm;
  String? payment;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? otp;
  Null? hallticketno;
  Null? hallticketnoUpload;
  Null? profile;
  Null? address;
  Null? fathername;
  Null? dob;
  Null? remark;
  String? admin;
  Null? referenceId;
  Null? gender;
  Null? community;
  String? loggedIn;
  String? deviceId;

  Userdetails(
      {this.userId,
      this.name,
      this.email,
      this.mobileNumber,
      this.courseId,
      this.password,
      this.confirm,
      this.payment,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.otp,
      this.hallticketno,
      this.hallticketnoUpload,
      this.profile,
      this.address,
      this.fathername,
      this.dob,
      this.remark,
      this.admin,
      this.referenceId,
      this.gender,
      this.community,
      this.loggedIn,
      this.deviceId});

  Userdetails.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    mobileNumber = json['mobile_number'];
    courseId = json['course_id'];
    password = json['password'];
    confirm = json['confirm'];
    payment = json['payment'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    otp = json['otp'];
    hallticketno = json['hallticketno'];
    hallticketnoUpload = json['hallticketno_upload'];
    profile = json['profile'];
    address = json['address'];
    fathername = json['fathername'];
    dob = json['dob'];
    remark = json['remark'];
    admin = json['admin'];
    referenceId = json['reference_id'];
    gender = json['gender'];
    community = json['community'];
    loggedIn = json['logged_in'];
    deviceId = json['device_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile_number'] = this.mobileNumber;
    data['course_id'] = this.courseId;
    data['password'] = this.password;
    data['confirm'] = this.confirm;
    data['payment'] = this.payment;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['otp'] = this.otp;
    data['hallticketno'] = this.hallticketno;
    data['hallticketno_upload'] = this.hallticketnoUpload;
    data['profile'] = this.profile;
    data['address'] = this.address;
    data['fathername'] = this.fathername;
    data['dob'] = this.dob;
    data['remark'] = this.remark;
    data['admin'] = this.admin;
    data['reference_id'] = this.referenceId;
    data['gender'] = this.gender;
    data['community'] = this.community;
    data['logged_in'] = this.loggedIn;
    data['device_id'] = this.deviceId;
    return data;
  }
}
