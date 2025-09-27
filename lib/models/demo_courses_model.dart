class DemoCoursesModel {
  String? demo_id;
  String? demo_course_name;
  String? video_name;
  String? video_image;
  String? course_id;
  String? video_link;
  String? description;
  String? demo_course_image;
  String? status;

  DemoCoursesModel(
      {this.demo_id,
      this.demo_course_name,
      this.video_name,
      this.video_image,
      this.course_id,
      this.video_link,
      this.description,
      this.demo_course_image,
      this.status});

  factory DemoCoursesModel.fromJson(Map<String, dynamic> json) =>
      DemoCoursesModel(
          demo_id: json['demo_id'],
          demo_course_name: json['demo_course_name'],
          video_name: json['video_name'],
          video_image: json['video_image'],
          course_id: json['course_id'],
          video_link: json['video_link'],
          description: json['description'],
          demo_course_image: json['demo_course_image'],
          status: json['status']);
}
