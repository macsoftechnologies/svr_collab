class GetNewProfileModel {
  final int? status;
  final String? message;
  final Result? result;

  GetNewProfileModel({
    this.status,
    this.message,
    this.result,
  });

  factory GetNewProfileModel.fromJson(Map<String, dynamic> json) {
    return GetNewProfileModel(
      status: json['status'],
      message: json['message'],
      result: json['result'] != null ? Result.fromJson(json['result']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      if (result != null) 'result': result!.toJson(),
    };
  }
}

class Result {
  final String? userId;
  final String? name;
  final String? email;
  final String? mobileNumber;
  final String? password;
  final String? joinedDate;

  Result({
    this.userId,
    this.name,
    this.email,
    this.mobileNumber,
    this.password,
    this.joinedDate,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      userId: json['user_id'],
      name: json['name'],
      email: json['email'],
      mobileNumber: json['mobile_number'],
      password: json['password'],
      joinedDate: json['joined_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'mobile_number': mobileNumber,
      'password': password,
      'joined_date': joinedDate,
    };
  }
}
