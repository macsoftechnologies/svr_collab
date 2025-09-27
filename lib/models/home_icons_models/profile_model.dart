class ProfileModel {
  String? userId;
  String? name;
  String? email;
  String? mobileNumber;
  String? courseId;
  String? password;
  String? confirm;
  String? payment;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? otp;
  String? hallticketno;
  String? hallticketnoUpload;
  String? profile;
  String? address;
  String? fathername;
  String? dob;
  String? remark;
  String? admin;
  String? referenceId;
  String? gender;
  String? community;
  String? loggedIn;
  String? deviceId;

  ProfileModel(
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

  ProfileModel.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['name'] = name;
    data['email'] = email;
    data['mobile_number'] = mobileNumber;
    data['course_id'] = courseId;
    data['password'] = password;
    data['confirm'] = confirm;
    data['payment'] = payment;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['otp'] = otp;
    data['hallticketno'] = hallticketno;
    data['hallticketno_upload'] = hallticketnoUpload;
    data['profile'] = profile;
    data['address'] = address;
    data['fathername'] = fathername;
    data['dob'] = dob;
    data['remark'] = remark;
    data['admin'] = admin;
    data['reference_id'] = referenceId;
    data['gender'] = gender;
    data['community'] = community;
    data['logged_in'] = loggedIn;
    data['device_id'] = deviceId;
    return data;
  }
}
