class CoursesModel {
  String? paymentId;
  String? userId;
  String? courseId;
  String? name;
  String? courseName;
  String? courseImage;
  String? transactionId;
  String? amount;
  List<dynamic>? study;

  CoursesModel({
    this.paymentId,
    this.userId,
    this.courseId,
    this.name,
    this.courseName,
    this.courseImage,
    this.transactionId,
    this.amount,
    this.study,
  });

  // From JSON to MyCoursesModel
  CoursesModel.fromJson(Map<String, dynamic> json) {
    paymentId = json['payment_id'];
    userId = json['user_id'];
    courseId = json['course_id'];
    name = json['name'];
    courseName = json['course_name'];
    courseImage = json['course_image'];
    transactionId = json['transaction_id'];
    amount = json['amount'];
    study = json['study'] ?? [];
  }

  // From MyCoursesModel to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['payment_id'] = this.paymentId;
    data['user_id'] = this.userId;
    data['course_id'] = this.courseId;
    data['name'] = this.name;
    data['course_name'] = this.courseName;
    data['course_image'] = this.courseImage;
    data['transaction_id'] = this.transactionId;
    data['amount'] = this.amount;
    data['study'] = this.study;
    return data;
  }
}
