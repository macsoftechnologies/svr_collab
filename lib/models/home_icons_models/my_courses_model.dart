class MyCoursesModel {
  String? userId;
  String? name;
  String? email;
  String? mobileNumber;
  String? courseId;
  String? courseName;
  String? courseImage;

  MyCoursesModel(
      {this.userId,
        this.name,
        this.email,
        this.mobileNumber,
        this.courseId,
        this.courseName,
        this.courseImage});

  MyCoursesModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    mobileNumber = json['mobile_number'];
    courseId = json['course_id'];
    courseName = json['course_name'];
    courseImage = json['course_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile_number'] = this.mobileNumber;
    data['course_id'] = this.courseId;
    data['course_name'] = this.courseName;
    data['course_image'] = this.courseImage;
    return data;
  }
}
