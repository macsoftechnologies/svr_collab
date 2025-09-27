class LiveCoursesModel {
  String? courseId;
  String? courseName;
  String? courseImage;
  String? coursePrice;
  String? description;
  String? courseValidity;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? sortOrder;

  LiveCoursesModel(
      {this.courseId,
        this.courseName,
        this.courseImage,
        this.coursePrice,
        this.description,
        this.courseValidity,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.sortOrder});

  LiveCoursesModel.fromJson(Map<String, dynamic> json) {
    courseId = json['course_id'];
    courseName = json['course_name'];
    courseImage = json['course_image'];
    coursePrice = json['course_price'];
    description = json['description'];
    courseValidity = json['course_validity'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    sortOrder = json['sort_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['course_id'] = this.courseId;
    data['course_name'] = this.courseName;
    data['course_image'] = this.courseImage;
    data['course_price'] = this.coursePrice;
    data['description'] = this.description;
    data['course_validity'] = this.courseValidity;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['sort_order'] = this.sortOrder;
    return data;
  }
}
